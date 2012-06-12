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
        time.sleep(1)
        continue
        
    result = sensor.read()
    
    if result is None:
        continue
        
    print("Brightness is %d" % result)
    
    actuator = sset.getByAddress(20)
    if actuator is None:
        print("Actuator not found")
        continue
    
    if result < 5000:
        message = (255, 0, 255)
    elif result < 10000:
        message = (0, 255, 0)
    else:
        message = (255, 0, 0)

    actuator.write(message)
