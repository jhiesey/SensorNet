#ifndef WIRELESSIO_H
#define WIRELESSIO_H

#include "config.h"
#include "FreeRTOS.h"

void initializeSerialIO(void);
void sendByteSerial(unsigned char data);
portBASE_TYPE receiveByteSerial(unsigned char *data, portTickType ticksToWait);


#endif
