#include <string.h>

#include "network.h"

#include "queue.h"
#include "semphr.h"

#include "buffer.h"
#include "rpc.h"
#include "wirelessProtocol.h"
#include "busProtocol.h"

int htons(unsigned short s) {
    return (s & 0xFF) << 8 | (s >> 8);
}

int ntohs(unsigned short s) {
    return (s & 0xFF) << 8 | (s >> 8);
}

static void forwardNetworkPacket(struct dataQueueEntry *entry, enum dataSource source) {
    entry->dest = 0xFFFF; // TODO: fix this

    switch(source) {
        case SOURCE_BUS:
            if(!NET_NONBUS_SEND(entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
        case SOURCE_WIRELESS:
            if(!busSend(entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
        case SOURCE_SELF:
            bufferRetain(entry->buffer);
            if(!NET_NONBUS_SEND(entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            if(!busSend(entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
    }
}



void handleNetworkPacket(struct dataQueueEntry *entry, enum dataSource source) {
    unsigned short toField = entry->buffer->data[2] << 8 | entry->buffer->data[3];
    if(toField == 0xFFFF || toField == NETWORK_ADDRESS) {
        // For us
        handleRPCPacket(entry);
    }

    if(toField != NETWORK_ADDRESS) {
        // Forward
        forwardNetworkPacket(entry, source);
    } else {
        bufferFree(entry->buffer);
    }
}



bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, unsigned long long sourceAddr) {
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

    handleNetworkPacket(&entry, source);

    return true;
}
