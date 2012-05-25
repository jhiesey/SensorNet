import threading
import sensorNetwork
import struct
import Queue

class Handle(object):
    def __init__(self, ser, remoteAddr):
        self.ser = ser
        self.remoteAddr = remoteAddr
        self.queue = Queue.Queue()
        self.valid = True
        
class Handler(object):
    def __init__(self, handler, hasResponse):
        self.handler = handler
        self.hasResponse = hasResponse
        
class RPCHandlerThread(threading.Thread):
    def __init__(self, rpc):
        super(RPCHandlerThread, self).__init__()
        self.rpc = rpc
    
    def run(self):
        while True:
            data = self.rpc.requestQueue.get()
            (fromAddr, toAddr, ser, rpcNum) = struct.unpack('!HHHH', data[0:8])
            
            handler = self.rpc.handlers.get(rpcNum)
            if handler is not None:
                if handler.hasResponse:
                    response = handler.handler(fromAddr, data[8:])
                    if response is not None:
                        responseData = struct.pack('!HHHH', sensorNetwork.NETWORK_ADDRESS, fromAddr, ser, 0) + response
                        self.rpc.network.handleMessage(responseData)
                else:
                    handler.handler(fromAddr, data[8:])
            
    
class SensorRPC(object):
    def __init__(self, port, numHandlers):
        self.network = sensorNetwork.Network(port, self)
        self.requestQueue = Queue.Queue()
        self.handlesLock = threading.Lock()
        self.handles = dict()
        self.nextSerial = 0
        self.handlers = dict()
        for i in range(numHandlers):
            RPCHandlerThread(self).start()
            
    def registerRPCHandler(self, handler, hasResponse, rpcNum):
        h = Handler(handler, hasResponse)
        self.handlers[rpcNum] = h
    
    def handleRPC(self, data):
        (fromAddr, toAddr, ser, rpcNum) = struct.unpack('!HHHH', data[0:8])
        
        if rpcNum == 0:
            # This is a reply
            self.handlesLock.acquire()
            if ser in self.handles:
                handle = self.handles[ser]
                if handle.remoteAddr == fromAddr and handle.valid:
                    handle.queue.put(data)
            
            self.handlesLock.release()
            
        else:
            # This is an incoming call
            self.requestQueue.put(data)
            
    def doRPCCall(self, requestData, toAddr, rpcNum, retries=3, waitTime=1):
        ser = 0
        handle = None
        
        if waitTime > 0:
            self.handlesLock.acquire()
            ser = self.nextSerial
            self.nextSerial += 1
            handle = Handle(ser, toAddr)
            self.handles[ser] = handle
            self.handlesLock.release()
        
        data = struct.pack('!HHHH', sensorNetwork.NETWORK_ADDRESS, toAddr, ser, rpcNum) + requestData
        replyData = None
        
        for i in range(retries + 1):
            self.network.handleMessage(data)
            
            if waitTime == 0:
                return True
            try:    
                reply = handle.queue.get(timeout=waitTime)
            except Queue.Empty:
                continue
                
            replyData = reply[8:]
            break
        
        self.handlesLock.acquire()
        handle.valid = False
        try:
            while True:
                handle.queue.get(False)
        except Queue.Empty:
            pass
            
        del self.handles[ser]
        self.handlesLock.release()
        
        return replyData