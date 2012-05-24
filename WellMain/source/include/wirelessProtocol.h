#ifndef WIRELESSPROTOCOL_H
#define WIRELESSPROTOCOL_H

#include <stdbool.h>

#include "config.h"
#include "FreeRTOS.h"
#include "buffer.h"

bool wirelessSend(struct dataQueueEntry *entry, unsigned short waitTime);
void startWirelessReceiverTransmitter();


#endif
