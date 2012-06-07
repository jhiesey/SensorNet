#!/usr/bin/env python

import sensorRPC
import time
import struct

def printHex(data):
    print(' '.join( [ "%02X" % ord( x ) for x in data ] ))

def echo(fromAddr, data):
    printHex(data)
    return data
    
def printDebugMessage(fromAddr, data):
    print("Debug (from %d): %s" % (fromAddr, data))

rpc = sensorRPC.SensorRPC('/dev/tty.usbserial-ftE12KJD', 2)
rpc.registerRPCHandler(echo, True, 1)
rpc.registerRPCHandler(printDebugMessage, False, 3)

# while True:
#     data = bytes('foo')
#     result = rpc.doRPCCall(data, 1, 2, 3, 2)
#     print(result)
#     
#     time.sleep(5)

# while True:
#     toprint = raw_input()
#     
#     rpc.doRPCCall(bytes(toprint), 1, 1, 0, 0)

while True:
    color = raw_input("Choose a color (r, g, o, off):")
    
    if color == 'r':
        message = 2
    elif color == 'g':
        message = 1
    elif color == 'o':
        message = 3
    elif color == 'off':
        message = 0
    else:
        print("Invalid color!")
        continue
        
    result = rpc.doRPCCall(struct.pack('!B', message), 20, 10, 3, 2)
    if result is None:
        print("No response")
        continue
    
    resultByte = struct.unpack('!B', result)[0]
    
    if resultByte == 2:
        oldColor = 'red'
    elif resultByte == 1:
        oldColor = 'green'
    elif resultByte == 3:
        oldColor = 'orange'
    elif resultByte == 0:
        oldColor = 'off'
    else:
        oldColor = '<invalid response>'
        
    print("The light was previously: " + oldColor)
        
    
    
    
    
    