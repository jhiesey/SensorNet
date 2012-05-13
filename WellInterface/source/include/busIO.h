#ifndef BUSIO_H
#define BUSIO_H

#include "FreeRTOS.h"

void initializeBusIO();
void waitForReceive();
void sendByteBus(char data, bool last);
portBASE_TYPE receiveByteBus(char *data, portTickType ticksToWait);


#endif
