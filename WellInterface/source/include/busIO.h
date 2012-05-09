#ifndef BUSIO_H
#define BUSIO_H

#include "FreeRTOS.h"

void initializeBusIO();
void switchDirection(BOOL transmit);
void sendByteBus(char data);
char receiveByteBus(portTickType ticksToWait);


#endif
