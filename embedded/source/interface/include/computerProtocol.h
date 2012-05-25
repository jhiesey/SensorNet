#ifndef COMPUTERPROTOCOL_H
#define COMPUTERPROTOCOL_H

#include <stdbool.h>

#include "config.h"
#include "FreeRTOS.h"
#include "buffer.h"

bool computerSend(struct dataQueueEntry *entry, unsigned short waitTime);
void startComputerReceiverTransmitter();


#endif
