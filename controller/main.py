#!/usr/bin/env python

import sensorRPC
import time
import struct

def printHex(data):
    print(' '.join( [ "%02X" % ord( x ) for x in data ] ))

def echo(fromAddr, data):
    printHex(data)
    return data
    
def null(fromAddr, data):
    print("Null RPC called")
    return None
    
def printDebugMessage(fromAddr, data):
    print("Debug (from %d): %s" % (fromAddr, data))

# Sensor structure    
class SensorFunction(object):
    def __init__(self, addr, index):
        self.announceTime = time.time()
        self.addr = addr
        self.index = index

    def read(self):
        raise Exception("Invalid read from sensor")
    
    def write(self, value):
        raise Exception("Invalid write to sensor")
    
class SensorSet(object):
    def __init__(self, rpc, sensorTypes, actuatorTypes):
        self.sensors = dict()
        self.sensorTypes = sensorTypes
        self.actuatorTypes = actuatorTypes
        self.rpc = rpc
        rpc.registerRPCHandler(self.handleAnnounce, True, 0x100)
        
        rpc.doRPCCall("", 0xFFFF, 0x101, 0, 0)
        
    def parseSensorInfo(self, addr, data):
        if len(data) < 2:
            return None

        length = struct.unpack('!H', data[0:2])[0]
        # printHex(data)
        # print(length)
        if len(data) < length * 2 + 2:
            return None
        
        self.sensors[addr] = dict()
        data = data[2:]
        for i in range(length):
            typ = struct.unpack('!H', data[0:2])[0]
            data = data[2:]
            
            if typ in self.sensorTypes:
                sensorClass = self.sensorTypes[typ]
            elif typ in self.actuatorTypes:
                sensorClass = self.actuatorTypes[typ]
            else:
                continue

            self.sensors[addr][i] = sensorClass(addr, i)
        
    def handleAnnounce(self, fromAddr, data):
        self.parseSensorInfo(fromAddr, data)
        return ""

    def verifySensors(self):
        for (a, s) in iter(self.sensors):
            response = self.rpc.doRPCCall("", a, 0x101)
            if response is not None:
                parseSensorInfo(a, response)
            else:
                del self.sensors[a]
                
    def getByAddress(self, addr, index=0):
        try:
            return self.sensors[addr][index]
        except KeyError:
            return None

class LightSensor(SensorFunction):
    pass
    
class LEDOutput(SensorFunction):
    def write(self, value):
        """Write color"""
        result = rpc.doRPCCall(struct.pack('!HBBB', 0, value[0], value[1], value[2]), self.addr, 0x103)
        if result is not None:
            result = struct.unpack('!BBB', result)
            
        return result

rpc = sensorRPC.SensorRPC('/dev/tty.usbserial-ftE12KJD', 2)
rpc.registerRPCHandler(null, False, 0x1)
rpc.registerRPCHandler(echo, True, 0x2)

rpc.registerRPCHandler(printDebugMessage, False, 0x10)

sensorTypes = {0x0: LightSensor}
actuatorTypes = {0x100: LEDOutput}

sset = SensorSet(rpc, sensorTypes, actuatorTypes)

# Register Announce, Query, etc.

# while True:
#     data = bytes('foo')
#     result = rpc.doRPCCall(data, 1, 1, 3, 2)
#     print(result)
#     
#     time.sleep(5)

# while True:
#     toprint = raw_input()
#     
#     rpc.doRPCCall(bytes(toprint), 1, 2, 0, 0)

while True:
    color = raw_input("Choose a color (hex):")
    
    try:
        colorInt = int(color, 16)
        message = ((colorInt & 0xFF0000) >> 16, (colorInt & 0xFF00) >> 8, (colorInt & 0xFF))
    except Exception:
        print("invalid color!")
        continue
    
    # print(message)
    
    sensor = sset.getByAddress(20)
    if sensor is None:
        print("Sensor not found")
        continue
        
    result = sensor.write(message)
    if result is None:
        print("No response")
        continue
        
    try:
        colorInt = result[0] << 16 | result[1] << 8 | result[2]
        oldColor = hex(colorInt)
    except Exception:
        oldColor = '<invalid response>'
        
    print("The light was previously: " + oldColor)
        
    
    
    
    
    