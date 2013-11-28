

import sensorRPC
import time
import struct
import threading

# RPC type definitions
RPC_GET_ENDPOINT_PARAMS = 0x20
RPC_READ_ENDPOINT = 0x21
RPC_WRITE_ENDPOINT = 0x22
RPC_RESET_ENDPOINT = 0x23
RPC_READ_MENU = 0x24

RPC_MASTER_ANNOUNCE = 0x30
RPC_ENDPOINT_SYNC = 0x31
RPC_ENDPOINT_SERVER_ERROR = 0x32
RPC_NOTIFY_ENDPOINT = 0x33

ANNOUNCE_INTERVAL = 1500 # 25 minutes, so even if one gets lost things are OK
MAX_NO_CONTACT_TIME = 3600 # Device assumed missing if no contact in this time

# Data types
ENDPOINT_UNNOWN = 0
ENDPOINT_INT16 = 1
ENDPOINT_INT32 = 2
ENDPOINT_ENUM = 3
ENDPOINT_TIME = 4
ENDPOINT_MENU = 5

# endpoint data flags
ENDPOINT_FLAG_READABLE = 1
ENDPOINT_FLAG_WRITEABLE = 2
ENDPOINT_FLAG_RESETTABLE = 4

MAX_MENU_ENTRIES_PER_CALL = 4

class MenuValue(object):
    """Represents a menu"""
    def __init__(self, entries):
        self.entries = entries

class MenuEntry(object):
    """Represents an entry (row) in a menu"""
    def __init__(self, name, address, endpoint, dataType):
        self.name = name
        self.address = address
        self.endpoint = endpoint
        self.dataType = dataType

class Device(object):
    """Keeps track of the endpoints that a given server should send updates for"""
    def __init__(self, context, address):
        self.context = context
        self.address = address
        self.callbacks = {} # Key is client, value is list of ids
        self.lastContactTime = None # Indicates if this device has been heard from

    # context.devicesLock MUST be held when calling this function!
    def setCallbacksForClient(self, client, endpoints):
        """Sets callbacks for a given client and then sends an update to the client"""
        prevCallbacks = set(self.callbacks[client]) if client in self.callbacks else set()
        if prevCallbacks == set(endpoints):
            return # Don't do any updates if already correct

        self.callbacks[client] = endpoints
        self.context.devicesLock.release() # Release and re-acquire lock during blocking calls
        if self.address != 0 and not self.context.syncWithDevice(self.address):
            self.context._sendServerFailed(client, self.address)

        try:
            if self.address == 0: # Update if we are the server
                print("checking for updates")
                for endpoint in endpoints:
                    print("in for loop")
                    if endpoint in self.context.endpoints:
                        print("calling changed")
                        self.context.endpoints[endpoint].dataChanged()
            self.context.devicesLock.acquire()
        except Exception as e:
            print(e)
        print("relocking")

    # context.devicesLock MUST be held when calling this function!
    def addLocalCallback(self, endpoint):
        callbacks = list(self.callbacks[0]) if 0 in self.callbacks else []
        callbacks.append(endpoint)
        self.setCallbacksForClient(0, callbacks)
        return True

    def removeLocalCallback(self, endpoint):
        callbacks = list(self.callbacks[0]) if 0 in self.callbacks else []
        if endpoint in callbacks:
            callbacks.remove(endpoint)
            self.setCallbacksForClient(0, callbacks)
            return True
        return False

    # Remove the device if it hasn't been heard from in a while
    # context.devicesLock MUST be held when calling this function!
    def checkContactTime(self):
        if self.lastContactTime is not None and self.lastContactTime < time.time() - MAX_NO_CONTACT_TIME:
            for client in self.callbacks.keys():
                 # Release and re-acquire lock during blocking call
                self.context.devicesLock.release()
                self.context._sendServerFailed(client, self.address)
                self.context.devicesLock.acquire()

            self.lastContactTime = None
            # Delete its own entry
            # del self.context.devices[self.address]

# Must be subclassed!
class LocalEndpoint(object):
    def __init__(self, id, parameters):
        self.context = None
        self.id = id
        self.params = parameters

    # Call when the data changes
    def dataChanged(self):
        print("data changed called!")
        value = self.read()
        if value is None:
            return False

        # if self.id not in self.context.devices:
        #     return True # Nothing is interested

        print("getting lock in changed")
        self.context.devicesLock.acquire()
        device = self.context.devices[0]
        relevantClients = []
        for client, endpoints in device.callbacks.items():
            if self.id in endpoints:
                relevantClients.append(client)
        self.context.devicesLock.release()
        print("releasing lock in changed")

        success = True
        for client in relevantClients:
            reqData = None

            dataType = self.params.dataType
            if dataType == ENDPOINT_INT16:
                reqData = struct.pack('<HHh', self.id, dataType, value)
            elif dataType == ENDPOINT_INT32:
                reqData = struct.pack('<HHi', self.id, dataType, value)
            elif dataType == ENDPOINT_ENUM:
                reqData = struct.pack('<HHH', self.id, dataType, value)

            print("sending update data")
            respData = self.context.rpc.doRPCCall(reqData, client, RPC_NOTIFY_ENDPOINT, 4, 5000)

            if len(respData) != 1:
                success = False
                continue

            if struct.unpack('<B', reqData) != 0:
                success = False
                continue
        return success

class AbstractEndpointParams(object):
    """Holds parameters for an endpoint, whether local or remote"""
    def __init__(self, dataType, readable=False, writeable=False, resettable=False):
        self.dataType = dataType
        self.readable = readable
        self.writeable = writeable
        self.resettable = resettable

class IntEndpointParams(AbstractEndpointParams):
    def __init__(self, minVal, maxVal, dpPos, dataType, *args, **kwargs):
        super(IntEndpointParams, self).__init__(dataType, *args, **kwargs)
        self.minVal = minVal
        self.maxVal = maxVal
        self.dpPos = dpPos

class EnumEndpointParams(AbstractEndpointParams):
    def __init__(self, maxVal, valStrings, *args, **kwargs):
        super(EnumEndpointParams, self).__init__(ENDPOINT_ENUM, *args, **kwargs)
        self.maxVal = maxVal
        self.valStrings = valStrings

class Endpoints(object):
    def __init__(self, port, endpoints, menus):
        self.menus = menus # Assumed not to change after initialization. Not locked!
        self.endpoints = dict()
        for endpoint in endpoints: # Assumed not to change after initialization. Not locked!
            endpoint.context = self
            self.endpoints[endpoint.id] = endpoint
        self.devices = dict()
        self.devices[0] = Device(self, 0)
        self.devicesLock = threading.Lock() # Used when operating on devices
        
        self.rpc = sensorRPC.SensorRPC(port, 2)

        # Read/write/etc. handlers
        self.rpc.registerRPCHandler(self._handleReadEndpoint, True, RPC_READ_ENDPOINT)
        self.rpc.registerRPCHandler(self._handleWriteEndpoint, True, RPC_WRITE_ENDPOINT)
        self.rpc.registerRPCHandler(self._handleResetEndpoint, True, RPC_READ_ENDPOINT)
        self.rpc.registerRPCHandler(self._handleGetEndpointParameters, True, RPC_GET_ENDPOINT_PARAMS)
        self.rpc.registerRPCHandler(self._handleReadMenu, True, RPC_READ_MENU)

        # Update handlers
        # self.rpc.registerRPCHandler(self._handleDataUpdated, True, RPC_NOTIFY_ENDPOINT) # TODO: implement? I thought I did!
        self.rpc.registerRPCHandler(self._handleSyncWithDevice, True, RPC_ENDPOINT_SYNC)

        # Misc handlers
        self.rpc.registerRPCHandler(self._echo, True, 0x2)
        self.rpc.registerRPCHandler(self._printDebugMessage, False, 0x10)
        
        self.announceTimer = threading.Timer(ANNOUNCE_INTERVAL, self._sendAnnounce)
        self.announceTimer.start()

    def _numBytesForType(self, dataType):
        if dataType == ENDPOINT_UNNOWN:
            return None
        if dataType == ENDPOINT_INT16:
            return 2
        if dataType == ENDPOINT_INT32:
            return 4
        if dataType == ENDPOINT_ENUM:
            return 2
        if dataType == ENDPOINT_TIME:
            return None # TODO: implement
        if dataType == ENDPOINT_MENU:
            return None # Not done this way

    # Periodically called to announce to devices
    def _sendAnnounce(self):    
        self.rpc.doRPCCall("", 0xFFFF, RPC_MASTER_ANNOUNCE, 0, 0)

        thread.sleep(60) # Wait a minute
        # The lock is released (and re-acquired) within checkContactTime() if needed
        with self.devicesLock:
            for device in self.devices: # Check to make sure all devices have been heard from somewhat recently
                if device.address != 0:
                    device.checkContactTime()

        self.announceTimer.start() # Restart the timer

    # Send data back to device (for testing)
    def _echo(self, fromAddr, data):
        return data

    # Prints messages sent to stdout on devices
    def _printDebugMessage(self, fromAddr, data):
        print("DEBUG from %d: %s" % (fromAddr, data))

    # Devices lock MUST be held when calling this!
    def _parseClientCallbacks(self, fromAddr, data):
        # The lock is released (and re-acquired) within setCallbacksForClient() if needed
        if len(data) % 4 != 0: # Check we have a multiple of four
            return False

        if fromAddr not in self.devices:
            self.devices[fromAddr] = Device(self, fromAddr) # Add the device callbacks work when it appears

        pos = 0
        callbacksForServer = {}
        while pos < len(data):
            serverAddr, endpoint = struct.unpack('<HH', data[pos:pos+4])
            if serverAddr in callbacksForServer:
                callbacksForServer[serverAddr].append(endpoint)
            else:
                callbacksForServer[serverAddr] = [endpoint]
            pos += 4

        for server, endpoints in callbacksForServer.items():
            if server in self.devices:
                self.devices[server].setCallbacksForClient(fromAddr, endpoints)
        return True

    # Devices lock MUST be held when calling this!
    def _generateServerCallbacks(self, toAddr):
        print("Generating server callbacks")
        if toAddr not in self.devices:
            return "" # No data available

        data = ""
        for client, endpoint in self.devices[toAddr].callbacks:
            data += struct.pack('<HH', client, endpoint)

        return data


    def _handleSyncWithDevice(self, fromAddr, data):
        with self.devicesLock:
            if fromAddr not in self.devices:
                self.devices[fromAddr] = Device(self, fromAddr)
            self.devices[fromAddr].lastContactTime = time.time()
            if not self._parseClientCallbacks(fromAddr, data):
                return None

            return self._generateServerCallbacks(fromAddr)

    # Synchronizes data with the given device
    def _syncWithDevice(self, address):
        with self.devicesLock:
            reqData = self._generateServerCallbacks(address)
        respData = self.rpc.doRPCCall(reqData, address, RPC_ENDPOINT_SYNC, 4, 5000)
        if respData is None:
            return False
        with self.devicesLock:
            return self._parseClientCallbacks(address, respData)

    # Notify a client that updates couldn't be requested, or a server lost contact
    def _sendServerFailed(self, destAddr, failedServer):
        self.rpc.doRPCCall(struct.pack('<H', failedServer), destAddr, RPC_ENDPOINT_SERVER_ERROR, 4, 5000)

    def addUpdateNotification(self, address, endpoint, syncNow=True):
        with self.devicesLock:
            if address not in self.devices:
                self.devices[address] = Device(self, address) # Add the device so the callback works when it appears
            self.devices[address].addLocalCallback(endpoint)
            return True

    def removeUpdateNotification(self, address, endpoint, syncNow=True):
        with self.devicesLock:
            if address not in self.devices:
                return True;
            self.devices[address].removeLocalCallback(endpoint)

    def readEndpoint(self, address, endpoint, dataType=None):
        if dataType is None:
            dataType = 0

        reqData = struct.pack('<HH', endpoint, dataType)
        respData = self.rpc.doRPCCall(reqData, address, RPC_READ_ENDPOINT, 4, 5000)
        if respData is None or len(respData) < 2:
            return None

        respData = respData[2:]
        receivedType = struct.unpack('<H', respData[0:2])
        if receivedType == 0:
            return None

        expectedBytes = self._numBytesForType(receivedType)
        if expectedBytes is None or len(respData) != expectedBytes:
            return None

        if receivedType == ENDPOINT_UNNOWN:
            return None
        if receivedType == ENDPOINT_INT16:
            return (receivedType, struct.unpack('<h', respData))
        if receivedType == ENDPOINT_INT32:
            return (receivedType, struct.unpack('<i', respData))
        if receivedType == ENDPOINT_ENUM:
            return (receivedType, struct.unpack('<H', respData))
        if receivedType == ENDPOINT_TIME:
            return None # TODO: implement
        if receivedType == ENDPOINT_MENU:
            return None # Not done this way

    def _handleReadEndpoint(self, fromAddr, data):
        if len(data) != 4:
            return None

        endpoint, dataType = struct.unpack('<HH', data)
        if endpoint not in self.endpoints:
            return struct.pack('<H', 0)
        endpointObj = self.endpoints[endpoint]
        if not hasattr(endpointObj, read):
            return struct.pack('<H', 0)
        if dataType != ENDPOINT_UNNOWN and dataType != endpointObj.params.dataType:
            return struct.pack('<H', 0)

        dataType = endpointObj.params.dataType
        toSend = endpointObj.read()
        if toSend is None:
            return struct.pack('<H', 0)

        if dataType == ENDPOINT_INT16:
            return struct.pack('<Hh', dataType, toSend)
        if dataType == ENDPOINT_INT32:
            return struct.pack('<Hi', dataType, toSend)
        if dataType == ENDPOINT_ENUM:
            return struct.pack('<HH', dataType, toSend)
        return struct.pack('<H', 0)

    def writeEndpoint(self, address, endpoint, dataType, data):
        reqData = None
        if dataType == ENDPOINT_UNNOWN:
            return False
        if dataType == ENDPOINT_INT16:
            reqData = struct.pack('<Hh', dataType, data)
        elif dataType == ENDPOINT_INT32:
            reqData = struct.pack('<Hi', dataType, data)
        elif dataType == ENDPOINT_ENUM:
            reqData = struct.pack('<HH', dataType, data)
        elif dataType == ENDPOINT_TIME:
            return False # TODO: implement
        elif dataType == ENDPOINT_MENU:
            return False

        if reqData is None:
            return False

        respData = self.rpc.doRPCCall(reqData, address, RPC_WRITE_ENDPOINT, 4, 5000)
        if respData is None or len(respData) != 1:
            return None

        return struct.unpack('<B', respData) == 0

    def _handleWriteEndpoint(self, fromAddr, data):
        if len(data) < 4:
            return None

        endpoint, dataType = struct.unpack('<HH', data[0:4])
        if endpoint not in self.endpoints:
            return struct.pack('<B', 1)
        endpointObj = self.endpoints[endpoint]
        if not hasattr(endpointObj, write):
            return struct.pack('<B', 1)
        if dataType != endpointObj.params.dataType:
            return struct.pack('<B', 1)

        data = data[2:]
        expectedBytes = self._numBytesForType(dataType)
        if expectedBytes is None or len(data) != expectedBytes:
            return struct.pack('<B', 1)

        toWrite = None
        if dataType == ENDPOINT_INT16:
            toWrite = struct.unpack('<h', data)
        elif dataType == ENDPOINT_INT32:
            toWrite = struct.unpack('<i', data)
        elif dataType == ENDPOINT_ENUM:
            toWrite = struct.unpack('<H', data)
        elif toWrite is None:
            return struct.pack('<B', 1)

        writeStatus = endpointObj.write(toWrite)
        if not writeStatus:
            return struct.pack('<B', 1)

        endpontObj.dataChanged()
        return struct.pack('<B', 0)

    def resetEndpoint(self, address, endpoint):
        reqData = struct.pack('<H')
        respData = self.rpc.doRPCCall(reqData, address, RPC_RESET_ENDPOINT, 4, 5000)
        if len(respData) != 1:
            return False

        return struct.unpack('<B', respData) == 0

    def _handleResetEndpoint(self, fromAddr, data):
        if len(data) != 2:
            return None

        endpoint = struct.unpack('<H', data)
        if endpoint not in self.endpoints:
            return struct.pack('<B', 1)
        endpointObj = self.endpoints[endpoint]
        if not hasattr(endpointObj, reset):
            return struct.pack('<B', 1)

        resetStatus = endpointObj.reset()
        if not resetStatus:
            return struct.pack('<B', 1)
        return struct.pack('<B', 0)

    def getEndpointParameters(self, address, endpoint):
        """This always gets enum values"""
        reqData = struct.pack('<HH', endpoint, 256) # Buffer can be really long on here
        respData = self.rpc.doRPCCall(reqData, address, RPC_GET_ENDPOINT_PARAMS, 4, 5000)
        if respData is None or len(respData) < 1:
            return None

        status = struct.unpack('<B', respData[0:1])
        if status != 0:
            return None

        respData = respData[1:]
        if len(respData) < 3: # Not even enough for type and flags
            return None

        (dataType, flags) = struct.unpack('<BH', respData[0:3])
        readable = flags & ENDPOINT_FLAG_READABLE
        writeable = flags & ENDPOINT_FLAG_WRITEABLE
        resettable = flags & ENDPOINT_FLAG_RESETTABLE

        if dataType == ENDPOINT_INT16 or dataType == ENDPOINT_INT32:
            if len(respData) != 10:
                return None

            (minVal, maxVal, dpPos) = struct.unpack('<llh', respDdata)
            return IntEndpointParams(dataType, minVal, maxVal, dpPos, readable, writeable, resettable)
        elif dataType == ENDPOINT_ENUM:
            if len(respData) < 6: # 6 including the ignored pointer field
                return None

            maxVal = struct.unpack('<H', respData[0:2])
            stringData = respData[4:]
            strs = []
            if len(stringData) == 0 or stringData[-1] != 0: # Check for null terminator
                return None
            for i in xrange(maxVal):
                s = ''
                if len(stringData) <= 1:
                    return None # Ran out of data
                while stringData[0] != 0:
                    s += stringData[0]
                strs.append(s)

            return EnumEndpointParams(maxVal, strs, readable, writeable, resettable)

        return None

    def _handleGetEndpointParameters(self, fromAddr, data):
        print("IN GET PARAMS")
        if len(data) != 4:
            return None

        (endpoint, bufferLen) = struct.unpack('<HH', data)

        if endpoint not in self.endpoints:
            print("BAD ENDPOINT")
            return struct.pack('<B', 1)
        params = self.endpoints[endpoint].params

        flags = 0
        if params.readable:
            flags |= ENDPOINT_FLAG_READABLE
        if params.writeable:
            flags |= ENDPOINT_FLAG_WRITEABLE
        if params.resettable:
            flags |= ENDPOINT_FLAG_RESETTABLE

        if params.dataType == ENDPOINT_INT16 or params.dataType == ENDPOINT_INT32:
            return struct.pack('<BHHllh', 0, params.dataType, flags, params.minVal, params.maxVal, params.dpPos)
        elif params.dataType == ENDPOINT_ENUM:
            respData = struct.pack('<BHHHHH', 0, params.dataType, flags, params.maxVal, 0, 0)

            stringData = ""
            for s in params.valStrings:
                stringData += s + '\0'

            if len(stringData) > bufferLen:
                print("TOO LONG")
                return struct.pack('<B', 1)
            return respData + stringData
        else:
            print("BAD TYPE")
            return struct.pack('<B', 1)

    def _handleReadMenu(self, fromAddr, data):
        if len(data) != 6:
            return False

        (menu, begin, end) = struct.unpack('<HHH', data)

        # Length 0 indicates error
        if menu not in self.menus:
            return ""

        menuObj = self.menus[menu]
        available = len(menuObj.entries) - begin
        if available > end - begin:
            available = end - begin
        if available < 0:
            available = 0
        if available > MAX_MENU_ENTRIES_PER_CALL:
            available = MAX_MENU_ENTRIES_PER_CALL

        respData = struct.pack('<HHH', len(menuObj.entries), begin, begin + available)
        for i in xrange(begin, begin + available):
            entryObj = menuObj.entries[i]
            entry = struct.pack('<16sHHB', entryObj.name, entryObj.address, entryObj.endpoint, entryObj.dataType)
            respData += entry

        return respData

class MenuValue(object):
    """Represents a menu"""
    def __init__(self, entries):
        self.entries = entries

class MenuEntry(object):
    """Represents an entry (row) in a menu"""
    def __init__(self, name, address, endpoint, dataType):
        self.name = name
        self.address = address
        self.endpoint = endpoint
        self.dataType = dataType
