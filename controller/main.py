#!/usr/bin/env python

def printHex(data):
    print(' '.join( [ "%02X" % ord( x ) for x in data ] ))

import interfaceProtocol

class Network(object):
    def handleMessage(self, data):
        global protocol
        s = data[4:6]
        replyData = bytes('\x00\x00\x00\x01%s\x00\x00echo...\x0A' % s)
        protocol.sendMessage(replyData)
        printHex(data)
 
network = Network()   
protocol = interfaceProtocol.InterfaceProtocol('/dev/tty.usbserial-ftE12KJD', network)