import interfaceIO
import threading
import Queue
import struct

START_BYTE = 128

class InterfaceReceiveTask(threading.Thread):
    def __init__(self, connection, networkHandler):
        super(InterfaceReceiveTask, self).__init__()
        self.connection = connection
        self.networkHandler = networkHandler
        self.daemon = true  
    
    def run(self):
        while True:
            csum = 0
            while True:
                data = self.connection.receiveBytes(1)
                if len(data) == 1 and struct.unpack('!B', data)[0] == START_BYTE:
                    break
            
            data = self.connection.receiveBytes(1)
            if len(data) == 0:
                continue
                
            length = struct.unpack('!B', data)[0]
            csum += length
            
            data = self.connection.receiveBytes(length + 1)
            if len(data) < length + 1:
                continue
            
            csum += sum([struct.unpack('!B', b)[0] for b in data])
            if (csum + 1) % 256 != 0:
                continue
            
            # Now we know the data is correct    
            data = data[0:-1]
            
            self.networkHandler.handleMessage(data)
    
    
class InterfaceTransmitTask(threading.Thread):
    def __init__(self, connection):
        super(InterfaceTransmitTask, self).__init__()
        self.connection = connection
        self.queue = Queue.Queue()
        self.daemon = true
        
    def run(self):
        while True:
            csum = 0
            data = self.queue.get()
            
            self.connection.sendBytes(struct.pack('!B', START_BYTE))
            self.connection.sendBytes(struct.pack('!B', len(data)))
            csum += len(data)
            self.connection.sendBytes(data)
            
            csum += sum([struct.unpack('!B', b)[0] for b in data])
            self.connection.sendBytes(struct.pack('!B', ~csum & 0xFF))
    

class InterfaceProtocol(object):
    def __init__(self, port, networkHandler):
        super(InterfaceProtocol, self).__init__()
        self.connection = interfaceIO.InterfaceIO(port, 1)
        self.receiveTask = InterfaceReceiveTask(self.connection, networkHandler)
        self.transmitTask = InterfaceTransmitTask(self.connection)
        
        self.receiveTask.start()
        self.transmitTask.start()
            
    def sendMessage(self, data):
        self.transmitTask.queue.put(data)
        
            
        