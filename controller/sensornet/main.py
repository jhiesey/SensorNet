#!/usr/bin/env python

import sensorRPC
import time
import struct
import threading

def printHex(data):
    print(' '.join( [ "%02X" % ord( x ) for x in data ] ))

# Sensor structure    
class SensorFunction(object):
    name = "<unnamed>"
    
    def __init__(self, addr, index, rpc):
        self.announceTime = time.time()
        self.addr = addr
        self.index = index
        self.rpc = rpc
        
    def readRaw(self):
        return self.rpc.doRPCCall(struct.pack('!H', self.index), self.addr, 0x102)
        
    def writeRaw(self, data):
        return self.rpc.doRPCCall(struct.pack('!H', self.index) + data, self.addr, 0x103)

    def read(self):
        raise Exception("read is not implemented on this sensor")
    
    def write(self, value):
        raise Exception("write is not implemented on this sensor")
        
    def printUser(self, value):
        raise Exception("printUser is not implemented on this sensor")
        
    def parseUser(self, inString):
        raise Exception("parseUser is not implemented on this sensor")
    
class SensorCollection(object):
    expirationTime = 60
    
    def __init__(self, port, sensorTypes, actuatorTypes):
        self.sensors = dict()
        self.sensorsLock = threading.Lock()
        self.sensorTypes = sensorTypes
        self.actuatorTypes = actuatorTypes
        
        self.rpc = sensorRPC.SensorRPC(port, 2)
        self.rpc.registerRPCHandler(self.handleAnnounce, True, 0x100)
        self.rpc.registerRPCHandler(self.null, False, 0x1)
        self.rpc.registerRPCHandler(self.echo, True, 0x2)
        self.rpc.registerRPCHandler(self.printDebugMessage, False, 0x10)
        
        self.rpc.doRPCCall("", 0xFFFF, 0x101, 0, 0)
        
    def echo(self, fromAddr, data):
        printHex(data)
        return data

    def null(self, fromAddr, data):
        print("Null RPC called")
        return None

    def printDebugMessage(self, fromAddr, data):
        print("Debug (from %d): %s" % (fromAddr, data))
        
    def parseSensorInfo(self, addr, data):
        if len(data) < 2:
            return None

        length = struct.unpack('!H', data[0:2])[0]
        # printHex(data)
        # print(length)
        if len(data) < length * 2 + 2:
            return None
        
        newSensor = dict()
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

            newSensor[i] = sensorClass(addr, i, self.rpc)
        
        self.sensorsLock.acquire()    
        self.sensors[addr] = newSensor
        self.sensorsLock.release()
        
    def handleAnnounce(self, fromAddr, data):
        self.parseSensorInfo(fromAddr, data)
        return ""
        
    def listSensors(self):
        """Returns a copy of the sensors dict, with out-of-date items culled"""
        self.sensorsLock.acquire()
        currTime = time.time()
        
        currentSensors = dict([(a, s) for (a, s) in self.sensors.items() if currTime - s[0].announceTime < self.expirationTime])
        retVal = currentSensors.copy()
        
        self.sensorsLock.release()
        
        return retVal

    def getByAddress(self, addr, index=0):
        self.sensorsLock.acquire()
        try:
            retVal = self.sensors[addr][index]
        except KeyError:
            self.sensorsLock.release()
            return None
            
        if time.time() - retVal.announceTime >= self.expirationTime:
            del self.sensors[addr]
            retVal = None
            
        self.sensorsLock.release()
        return retVal

# while True:
#     sensor = sset.getByAddress(21)
#     if sensor is None:
#         print("Sensor not found")
#         time.sleep(5)
#         continue
#         
#     result = sensor.read()
#     
#     print("Brightness is %d" % result)
#     
#     actuator = sset.getByAddress(20)
#     if actuator is not None:
#         print("writing")
#         val = result / 100
#         if val > 255:
#             val = 255
#         message = (val, val, val)
#         actuator.write(message)
#     
#     # time.sleep(1)
# 
# while True:
#     color = raw_input("Choose a color (hex):")
#     
#     try:
#         colorInt = int(color, 16)
#         message = ((colorInt & 0xFF0000) >> 16, (colorInt & 0xFF00) >> 8, (colorInt & 0xFF))
#     except Exception:
#         print("invalid color!")
#         continue
#     
#     # print(message)
#     
#     sensor = sset.getByAddress(20)
#     if sensor is None:
#         print("Sensor not found")
#         continue
#         
#     result = sensor.write(message)
#     if result is None:
#         print("No response")
#         continue
#         
#     try:
#         colorInt = result[0] << 16 | result[1] << 8 | result[2]
#         oldColor = hex(colorInt)
#     except Exception:
#         oldColor = '<invalid response>'
#         
#     print("The light was previously: " + oldColor)
        
    
    
    
    
    