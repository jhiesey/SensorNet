#include "network.h"

#include "queue.h"

#include "buffer.h"

void networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, char sourceAddr) {
    if (len > BUFFER_SIZE)
        return;
    
    char *buf = bufferAlloc();
    if (buf == NULL)
        return;
    
    short byte;

    int i;
    for (i = 0; i < len; i++) {
        byte = getByteCallback();
        if (byte < 0) {
            bufferFree(buf);
            return;
        }
        buf[i] = byte;
        csum += byte;
    }

    // Check the checksum
    byte = getByteCallback();
    if (byte < 0 ||(byte + csum + 1) % 256 != 0) {
        bufferFree(buf);
        return;
    }

    struct dataQueueEntry entry;
    entry.buffer = buf;
    entry.length = len;
    entry.dest = 255; // TODO: fix this

    if (source == SOURCE_BUS) {
        xQueueSend(computerOutputQueue, &entry, 5); // TODO: see if these delays are reasonable
    } else {
        xQueueSend(busOutputQueue, &entry, 5);
    }
}
