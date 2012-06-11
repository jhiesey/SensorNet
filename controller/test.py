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
        
    # val = result / 50
    # if val > 255:
    #     val = 255
    # message = (val, 0, 255 - val)
    
    if result < 100:
        message = (0, 0, 255)
    elif result < 2000:
        message = (0, 255, 0)
    else:
        message = (255, 0, 0)

    actuator.write(message)

# while True:
#     actuator = sset.getByAddress(20)
#     if actuator is None:
#         time.sleep(1)
#         continue
#     
#     message = (255, 0, 0)
#     actuator.write(message)
#     time.sleep(1)
#     message = (0, 255, 0)
#     actuator.write(message)
#     time.sleep(1)
#     message = (0, 0, 255)
#     actuator.write(message)
#     time.sleep(1)