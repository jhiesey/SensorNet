#include <stdbool.h>

#include "network.h"

#include "queue.h"

#include "buffer.h"

bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, unsigned long long sourceAddr) {
    if (len > BUFFER_SIZE)
        return false;
    
    char *buf = bufferAlloc();
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
        buf[i] = byte;
        csum += byte;
    }

    // Check the checksum
    byte = getByteCallback();
    if (byte < 0 ||(byte + csum + 1) % 256 != 0) {
        bufferFree(buf);
        return false;
    }

    struct dataQueueEntry entry;
    entry.buffer = buf;
    entry.length = len;
    entry.dest = 0xFFFF; // TODO: fix this

    xQueueHandle destQueue = source == SOURCE_BUS ? wirelessOutputQueue : busOutputQueue;

    if(!xQueueSend(destQueue, &entry, 5)) { // TODO: see if this delay is reasonable
        bufferFree(buf);
        return true; // Don't consider this a communications error
    }

    return true;
}
