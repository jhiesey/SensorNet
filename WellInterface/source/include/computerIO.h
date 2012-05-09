#ifndef COMPUTERIO_H
#define COMPUTERIO_H

#include "FreeRTOS.h"

void initializeComputerIO(void);
void sendByteComputer(char data);
char receiveByteComputer(portTickType ticksToWait);


#endif
