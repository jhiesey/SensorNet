#ifndef NETWORK_H
#define NETWORK_H

#include <stdbool.h>

#include "config.h"
#include "FreeRTOS.h"

#include "buffer.h"

enum dataPort {
    PORT_BUS,
    PORT_WIRELESS,
    PORT_COMPUTER,
    PORT_SELF,
    PORT_ALL
};

int htons(unsigned short s);
int ntohs(unsigned short s);

void startNetwork();
bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataPort source, unsigned long long sourceAddr);
void handleNetworkPacket(struct dataQueueEntry *entry, enum dataPort source, unsigned long long sourceAddr);

#endif
