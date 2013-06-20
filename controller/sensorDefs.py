import struct

import sensornet.main

class LightSensor(sensornet.main.SensorFunction):
    name = "Light Sensor"
    
    def read(self):
        """Read brightness"""
        result = self.readRaw()
        if result is not None:
            result = struct.unpack('!I', result)[0]
            
        return result
        
    def printUser(self, value):
        return str(value)
    
class LEDOutput(sensornet.main.SensorFunction):
    name = "RGB LED Output"
    
    def read(self):
        """Read color"""
        result = self.readRaw()
        if result is not None:
            result = struct.unpack('!BBB', result)
            
        return result
    
    def write(self, value):
        """Write color"""
        result = self.writeRaw(struct.pack('!BBB', value[0], value[1], value[2]))
        if result is not None:
            result = struct.unpack('!BBB', result)
            
        return result
        
    def printUser(self, data):
        colorInt = data[0] << 16 | data[1] << 8 | data[2]
        return hex(colorInt)
        
    def parseUser(self, inString):
        try:
            colorInt = int(inString, 16)
            return ((colorInt & 0xFF0000) >> 16, (colorInt & 0xFF00) >> 8, (colorInt & 0xFF))
        except Exception:
            return None
            
class TankLevel(sensornet.main.SensorFunction):
    name = "Tank Level"

    def read(self):
        """Read level"""
        result = self.readRaw()
        if result is not None:
            result = struct.unpack('!H', result)[0]

        return result

    def printUser(self, value):
        return str(value)
        
class TankFlow(sensornet.main.SensorFunction):
    name = "Tank Flow"

    def read(self):
        """Read flow"""
        result = self.readRaw()
        if result is not None:
            result = struct.unpack('!H', result)[0]

        return result

    def printUser(self, value):
        return str(value)