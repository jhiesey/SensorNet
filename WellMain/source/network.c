#include <string.h>

#include "network.h"

#include "queue.h"
#include "semphr.h"

#include "buffer.h"

#define NETWORK_ADDRESS 0

#define MAX_RPC_NUM 10

int htons(unsigned short s) {
    return (s & 0xFF) << 8 | (s >> 8);
}

int ntohs(unsigned short s) {
    return (s & 0xFF) << 8 | (s >> 8);
}

xQueueHandle rpcInputQueue;

static rpcHandler handlers[MAX_RPC_NUM + 1];

static void networkSendMessageFrom(struct dataQueueEntry *entry, enum dataSource source) {
    entry->dest = 0xFFFF; // TODO: fix this

    switch(source) {
        case SOURCE_BUS:
            if(!xQueueSend(wirelessOutputQueue, &entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
        case SOURCE_WIRELESS:
            if(!xQueueSend(busOutputQueue, &entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
        case SOURCE_SELF:
            entry->buffer->refcount++;
            if(!xQueueSend(wirelessOutputQueue, &entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            if(!xQueueSend(busOutputQueue, &entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
    }
}

void registerRPCCall(rpcHandler handler, int num) {
    if (num > MAX_RPC_NUM)
        return;

    handlers[num] = handler;
}

#define MAX_OUTSTANDING_RPCS 4
#define MAX_RPC_RETRIES 4

xQueueHandle freeHandleNumbers;
xSemaphoreHandle handlesLock; // TODO: check locking discipline

struct handleInfo {
    bool used;
    xQueueHandle queue;
};

struct handleInfo handles[MAX_OUTSTANDING_RPCS];

static unsigned short allocateSerial() {
    unsigned short serial;
    xQueueReceive(freeHandleNumbers, &serial, portMAX_DELAY);
    return serial;
}

static void freeSerial(unsigned short serial) {
    xQueueSend(freeHandleNumbers, &serial, portMAX_DELAY);
}

bool sendRPCCall(unsigned short outLen, struct refcountBuffer *outBuffer, unsigned short *replyLen,
struct refcountBuffer **replyBuffer, unsigned short to, unsigned short rpcNum, unsigned short waitTime) {
    struct dataQueueEntry outEntry;

    unsigned short hostSerial;

    if(waitTime > 0) {
        outEntry.buffer->refcount++;
        hostSerial = allocateSerial();
        handles[hostSerial].used = true;
    } else {
        hostSerial = 0;
    }

    outEntry.buffer = outBuffer;
    outEntry.length = outLen + 8;
    unsigned short from = htons(NETWORK_ADDRESS);
    to = htons(to);
    unsigned short serial = htons(hostSerial);
    rpcNum = htons(rpcNum);
    memcpy(outEntry.buffer->data, &from, 2);
    memcpy(outEntry.buffer->data + 2, &to, 2);
    memcpy(outEntry.buffer->data + 4, &serial, 2);
    memcpy(outEntry.buffer->data + 6, &rpcNum, 2);

    int i;
    for (i = 0; i <= MAX_RPC_RETRIES; i++) {
        networkSendMessageFrom(&outEntry, SOURCE_SELF);

        if(waitTime == 0) {
            return true;
        }

        struct dataQueueEntry replyEntry;
        if(!xQueueReceive(handles[hostSerial].queue, &replyEntry, waitTime)) {
            continue;
        }

        *replyBuffer = replyEntry.buffer;
        *replyLen = replyEntry.length;
        break;
    }

    freeSerial(hostSerial);

    return i <= MAX_RPC_RETRIES;
}

static void rpcThreadLoop(void *parameters) {
    struct dataQueueEntry entry;
    struct dataQueueEntry outEntry;

    while(1) {
        // Wait for available messages
        xQueueReceive(rpcInputQueue, &entry, portMAX_DELAY);

        unsigned short rpcNum = entry.buffer->data[3] << 8 | entry.buffer->data[2];
        if (rpcNum <= MAX_RPC_NUM) {
            rpcHandler h = handlers[rpcNum];

            int contentsLength = entry.length - 8;
            unsigned short outputLength = 0;

            if (h != NULL) {
                if(h(contentsLength, entry.buffer->data + 8, &outputLength, outEntry.buffer)) {
                    outEntry.length = outputLength + 8;
                    memcpy(outEntry.buffer->data, entry.buffer->data + 2, 2);
                    memcpy(outEntry.buffer->data + 2, entry.buffer->data, 2);
                    memcpy(outEntry.buffer->data + 4, entry.buffer->data + 4, 2);
                    memset(outEntry.buffer->data + 6, 0, 2);
                    networkSendMessageFrom(&outEntry, SOURCE_SELF);
                }
            }
        }
        bufferFree(entry.buffer);
    }
}

void startRPC() {
    rpcInputQueue = xQueueCreate( 4, sizeof (struct dataQueueEntry));

    int i;
    for (i = 0; i < 2; i++) {
        xTaskCreate(rpcThreadLoop, (signed char *) "rpc", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
    }

    for (i = 0; i < MAX_OUTSTANDING_RPCS; i++) {
        xQueueSend(freeHandleNumbers, &i, 0);
        handles[i].used = false;
        handles[i].queue = xQueueCreate(1, sizeof(struct dataQueueEntry));
    }
}

bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, unsigned long long sourceAddr) {
    if (len > BUFFER_SIZE)
        return false;
    
    struct refcountBuffer *buf = bufferAlloc();
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

    unsigned short toField = buf->data[2] << 8 | buf->data[3];
    if(toField == 0xFFFF || toField == NETWORK_ADDRESS) {
        // For us
        buf->refcount++;

        if (buf->data[6] == 0 && buf->data[7] == 0) {
            // This is a reply
            xSemaphoreTake(handlesLock, portMAX_DELAY);
            unsigned short serial = (buf->data[5] << 8) | buf->data[6];
            if (serial < MAX_OUTSTANDING_RPCS && handles[serial].used) {
                if(!xQueueSend(handles[serial].queue, &entry, 0)) {
                    bufferFree(buf);
                }
                handles[serial].used = false;
            } else {
                bufferFree(buf);
            }
            xSemaphoreGive(handlesLock);
        } else {
            if(!xQueueSend(rpcInputQueue, &entry, 0)) {
                bufferFree(buf);
            }
        }
    }

    if(toField != NETWORK_ADDRESS) {
        // Forward
        networkSendMessageFrom(&entry, source);
    } else {
        bufferFree(buf);
    }

    return true;
}
