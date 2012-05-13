#ifndef COMPUTERIO_H
#define COMPUTERIO_H

#include "FreeRTOS.h"

void initializeComputerIO(void);
void sendByteComputer(char data);
portBASE_TYPE receiveByteComputer(char *data, portTickType ticksToWait);


#endif
