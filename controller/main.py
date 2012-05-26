#!/usr/bin/env python

import sensorRPC
import time

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

while True:
    toprint = raw_input()
    
    rpc.doRPCCall(bytes(toprint), 1, 1, 0, 0)