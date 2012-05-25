#ifndef NETWORK_H
#define NETWORK_H

#include <stdbool.h>

#include "config.h"
#include "FreeRTOS.h"

#include "buffer.h"

#define NETWORK_ADDRESS 2

enum dataSource {
    SOURCE_BUS,
    SOURCE_WIRELESS,
    SOURCE_COMPUTER,
    SOURCE_SELF
};

int htons(unsigned short s);
int ntohs(unsigned short s);

bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, unsigned long long sourceAddr);
void handleNetworkPacket(struct dataQueueEntry *entry, enum dataSource source);

#endif
