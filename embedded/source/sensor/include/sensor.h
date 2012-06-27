#ifndef SENSOR_H
#define SENSOR_H

#include "config.h"
#include "rpc.h"

void sensorInit();

bool sensorReadRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData);
bool sensorWriteRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData);

void sensorFillAnnounceBuffer(struct rpcDataBuffer *buffer);


#ifdef MODULE_LIGHTSENSOR
#include "lightSensor.h"
#elif defined MODULE_LIGHTOUTPUT
#include "lightOutput.h"
#elif defined MODULE_TANKSENSOR
#include "tankSensor.h"
#endif

#endif
