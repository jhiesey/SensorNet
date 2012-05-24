#ifndef BUSPROTOCOL_H
#define BUSPROTOCOL_H

#include <stdbool.h>

#include "config.h"
#include "FreeRTOS.h"
#include "buffer.h"

bool busSend(struct dataQueueEntry *entry, unsigned short waitTime);
void startBusReceiver();


#endif
