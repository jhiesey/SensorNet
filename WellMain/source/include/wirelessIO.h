#ifndef WIRELESSIO_H
#define WIRELESSIO_H

#include "FreeRTOS.h"

void initializeWirelessIO(void);
void sendByteWireless(unsigned char data);
portBASE_TYPE receiveByteWireless(unsigned char *data, portTickType ticksToWait);


#endif
