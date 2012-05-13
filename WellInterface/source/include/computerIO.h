#ifndef COMPUTERIO_H
#define COMPUTERIO_H

#include "FreeRTOS.h"

void initializeComputerIO(void);
void sendByteComputer(unsigned char data);
portBASE_TYPE receiveByteComputer(unsigned char *data, portTickType ticksToWait);


#endif
