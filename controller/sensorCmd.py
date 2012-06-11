#!/usr/bin/env python

import cmd
import re

import sensornet.main
import sensorDefs

class SensorCommand(cmd.Cmd):
    def set_sset(self, sset):
        self.sset = sset
        self.shouldExit = False
        
    def postcmd(self, stop, line):
        return self.shouldExit
        
    def do_quit(self, line):
        self.shouldExit = True
    
    def do_list(self, line):
        sensorList = self.sset.listSensors()
        if len(sensorList) == 0:
            print("No sensors present")
            return
        
        for (addr, sensorBoard) in sensorList.items():
            for (index, sensor) in sensorBoard.items():
                print("%d %d: %s" % (addr, index, sensor.name))
    
    def do_read(self, line):
        p = re.match(r"(\S*)\s*(\S*)$", line)
        if p is None:
            print("Invalid read command")
            return
        
        path = p.groups()
        sensor = self.sset.getByAddress(int(path[0]), int(path[1]))
        if sensor is None:
            print("Cannot find specified sensor")
            return
        
        try:
            readValue = sensor.read()
            if readValue is None:
                print("Unable to read sensor")
                return
                
            formatted = sensor.printUser(readValue)
            print("Value: %s" % formatted)
        except Exception, e:
            print("Error in read: %s" % str(e))
    
    def do_write(self, line):
        p = re.match(r"(\S*)\s*(\S*)\s*?(.*)$", line)
        if p is None:
            print("Invalid read command")
            return
        
        path = p.groups()    
        sensor = self.sset.getByAddress(int(path[0]), int(path[1]))
        if sensor is None:
            print("Cannot find specified sensor")
            return
    
        try:
            parsed = sensor.parseUser(path[2])
            if parsed is None:
                print("Invalid value for write")
                return
            
            oldValue = sensor.write(parsed)
            if oldValue is None:
                return
                
            formatted = sensor.printUser(oldValue)
            print("Previous value: %s" % formatted)
        except Exception, e:
            print("Error in write: %s" % str(e))


if __name__ == '__main__':
    sensorTypes = {0x0: sensorDefs.LightSensor}
    actuatorTypes = {0x100: sensorDefs.LEDOutput}
    sset = sensornet.main.SensorCollection('/dev/tty.usbserial-ftE12KJD', sensorTypes, actuatorTypes)            
            
    command = SensorCommand()
    command.set_sset(sset)
    command.prompt = '> '
    command.cmdloop()