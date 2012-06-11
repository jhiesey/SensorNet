#!/usr/bin/env python

import time

import sensornet.main
import sensorDefs

sensorTypes = {0x0: sensorDefs.LightSensor}
actuatorTypes = {0x100: sensorDefs.LEDOutput}
sset = sensornet.main.SensorCollection('/dev/tty.usbserial-ftE12KJD', sensorTypes, actuatorTypes)            

while True:
    sensor = sset.getByAddress(21)
    if sensor is None:
        print("Sensor not found")
        time.sleep(5)
        continue
        
    result = sensor.read()
    
    print("Brightness is %d" % result)
    
    actuator = sset.getByAddress(20)
    if actuator is None:
        print("Actuator not found")
        continue
        
    val = result / 100
    if val > 255:
        val = 255
    message = (val, val, val)
    actuator.write(message)
