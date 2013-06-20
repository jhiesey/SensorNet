#include <string.h>

#include "network.h"

#include "queue.h"
#include "semphr.h"

#include "buffer.h"
#include "rpc.h"
#include "busProtocol.h"

#ifdef MODULE_INTERFACE
#include "computerProtocol.h"
#elif defined MODULE_HUB
#include "wirelessProtocol.h"
#endif

#define ROUTING_ENTRIES 10

struct routingEntry {
    unsigned long long nextHop;
    unsigned short dest;
    struct routingEntry *prev;
    struct routingEntry *next;
    enum dataPort port;
};

int nextRoute = 0;

struct routingEntry routingTable[ROUTING_ENTRIES];
struct routingEntry *firstRoute;
struct routingEntry *lastRoute;

xSemaphoreHandle routingLock;

static struct routingEntry *findRoute(unsigned short dest) {
    struct routingEntry *entry;
    for (entry = firstRoute; entry != NULL; entry = entry->next) {
        if (entry->dest == dest) {
            return entry;
        }
    }
    return NULL;
}

void startNetwork() {
    routingLock = xSemaphoreCreateMutex();
}

static void removeRoute(struct routingEntry *entry) {
    // Remove from list
    if (entry->prev != NULL) {
        entry->prev->next = entry->next;
    } else {
        firstRoute = entry->next;
    }
    
    if (entry->next != NULL) {
        entry->next->prev = entry->prev;
    } else {
        lastRoute = entry->prev;
    }
}

static void storeRoute(unsigned short from, enum dataPort port, unsigned long long prevHop) {
    xSemaphoreTake(routingLock, portMAX_DELAY);
    struct routingEntry *entry = findRoute(from);
    if(entry == NULL) {
        if(nextRoute >= ROUTING_ENTRIES) {
            entry = lastRoute;
            removeRoute(entry);
        } else {
            entry = routingTable + nextRoute++;
        }
    } else {
        removeRoute(entry);
    }

    entry->prev = NULL;
    entry->next = firstRoute;
    entry->dest = from;
    entry->port = port;
    entry->nextHop = prevHop;

    if(firstRoute != NULL) {
        firstRoute->prev = entry;
    } else {
        lastRoute = entry;
    }
    
    firstRoute = entry;
    
    xSemaphoreGive(routingLock);
}

static void getRoute(unsigned short dest, enum dataPort *port, unsigned long long *nextHop) {
    if(dest == 0xFFFF) {
        *port = PORT_ALL;
        *nextHop = 0xFFFF;
        return;
    }

    xSemaphoreTake(routingLock, portMAX_DELAY);
    struct routingEntry *entry = findRoute(dest);
    if(entry != NULL) {
        *port = entry->port;
        *nextHop = entry->nextHop;
    } else {
        *port = PORT_ALL;
        *nextHop = 0xFFFF;
    }
    xSemaphoreGive(routingLock);
}

unsigned short htons(unsigned short s) {
    return ((s & 0xFF) << 8) | (s >> 8);
}

unsigned long htonl(unsigned long l) {
    return ((l & 0xFF) << 24) | ((l & 0xFF00) << 8) | ((l & 0xFF0000) >> 8) | (l >> 24);
}

static void forwardNetworkPacket(struct dataQueueEntry *entry, unsigned short toField, enum dataPort source) {
    enum dataPort port;
    getRoute(toField, &port, &(entry->dest));

    switch(port) {
        case PORT_BUS:
            if(source == PORT_BUS || !busSend(entry, 0)) {
                bufferFree(entry->buffer);
            }
            break;
#ifdef MODULE_INTERFACE
        case PORT_COMPUTER:
            if(source == PORT_COMPUTER || !computerSend(entry, 0)) {
                bufferFree(entry->buffer);
            }
            break;
#elif defined MODULE_HUB
        case PORT_WIRELESS:
            if(source == PORT_WIRELESS || !wirelessSend(entry, 0)) {
                bufferFree(entry->buffer);
            }
            break;
#endif
        case PORT_ALL:
            if(source != PORT_BUS) {
                bufferRetain(entry->buffer);
                if(!busSend(entry, 0)) {
                    bufferFree(entry->buffer);
                }
            }
#ifdef MODULE_INTERFACE
            if(source == PORT_COMPUTER || !computerSend(entry, 0)) {
                bufferFree(entry->buffer);
            }
#elif defined MODULE_HUB
            if(source == PORT_WIRELESS || !wirelessSend(entry, 0)) {
                bufferFree(entry->buffer);
            }
#else
            bufferFree(entry->buffer);
#endif
            break;
        default:
            bufferFree(entry->buffer);
            break;
    }
}

void handleNetworkPacket(struct dataQueueEntry *entry, enum dataPort source, unsigned long long sourceAddr) {
    unsigned short fromField = entry->buffer->data[0] << 8 | entry->buffer->data[1];
    if(source != PORT_SELF) {
        storeRoute(fromField, source, sourceAddr);
    }
    
    unsigned short toField = entry->buffer->data[2] << 8 | entry->buffer->data[3];
    if(toField == 0xFFFF || toField == NETWORK_ADDRESS) {
        // For us
        handleRPCPacket(entry);
    }

    if(toField != NETWORK_ADDRESS) {
        // Forward
        forwardNetworkPacket(entry, toField, source);
    } else {
        bufferFree(entry->buffer);
    }
}



bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataPort source, unsigned long long sourceAddr) {
    if (len > BUFFER_SIZE)
        return false;
    
    struct refcountBuffer *buf = bufferAlloc(0);
    if (buf == NULL) {
        return true; // Don't consider this a communications error
    }
    
    short byte;

    int i;
    for (i = 0; i < len; i++) {
        byte = getByteCallback();
        if (byte < 0) {
            bufferFree(buf);
            return false;
        }
        buf->data[i] = byte;
        csum += byte;
    }

    // Check the checksum
    byte = getByteCallback();
    if (byte < 0 ||(byte + csum + 1) % 256 != 0) {
        bufferFree(buf);
        return false;
    }

    int contentsLength = len - 8;

    if(contentsLength < 0) {
        bufferFree(buf);
        return false;
    }

    struct dataQueueEntry entry;
    entry.buffer = buf;
    entry.length = len;

    handleNetworkPacket(&entry, source, sourceAddr);

    return true;
}
