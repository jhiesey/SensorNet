#!/opt/local/bin/python2.7

import time

from sensornet import endpoints
# import sensorDefs

# sensorTypes = {0x0: sensorDefs.LightSensor, 0x10: sensorDefs.TankLevel, 0x11: sensorDefs.TankFlow}
# actuatorTypes = {0x100: sensorDefs.LEDOutput}

basicEndpointParams = endpoints.IntEndpointParams(0, 0, 0, endpoints.ENDPOINT_INT16, readable=True)
basicEndpoint = endpoints.LocalEndpoint(10, basicEndpointParams)

mainMenu = endpoints.MenuValue([endpoints.MenuEntry("Main Menu", 0, 10, endpoints.ENDPOINT_INT16)])

sset = endpoints.Endpoints('/dev/tty.usbserial-ftE12KJD', [basicEndpoint], {0: mainMenu})            

while True:
    sensor = sset.getByAddress(20)
    if sensor is None:
        print("Sensor not found")
        time.sleep(1)
        continue
        
    result = sensor.read()
    
    if result is None:
        continue
        
    print("Level is %d" % result)
