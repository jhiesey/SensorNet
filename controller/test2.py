#!/opt/local/bin/python2.7

import time

from sensornet import endpoints
# import sensorDefs

# sensorTypes = {0x0: sensorDefs.LightSensor, 0x10: sensorDefs.TankLevel, 0x11: sensorDefs.TankFlow}
# actuatorTypes = {0x100: sensorDefs.LEDOutput}

class DemoEndpoint(endpoints.LocalEndpoint):
	def __init__(self):
		params = endpoints.IntEndpointParams(0, 0, 0, endpoints.ENDPOINT_INT16, readable=True)
		super(DemoEndpoint, self).__init__(10, params)

	def read(self):
		return 111

basicEndpoint = DemoEndpoint()

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
