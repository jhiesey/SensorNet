NETWORK_ADDRESS = 0

import interfaceProtocol
import struct

class Network(object):
    def __init__(self, port, handler):
        self.protocol = interfaceProtocol.InterfaceProtocol(port, self)
        self.handler = handler
    
    def handleMessage(self, data, source=True):
        if len(data) < 8:
            return
        
        to = struct.unpack('!H', data[2:4])[0]
        
        if to == 0xFFFF or to == NETWORK_ADDRESS:
            self.handler.handleRPC(data)
            
        if to != NETWORK_ADDRESS and source:
            self.protocol.sendMessage(data)