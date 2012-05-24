#ifndef BUSIO_H
#define BUSIO_H

#include "config.h"
#include "FreeRTOS.h"

void initializeBusIO();
void waitForReceive();
void sendByteBus(unsigned char data, bool last);
portBASE_TYPE receiveByteBus(unsigned char *data, portTickType ticksToWait);


#endif
