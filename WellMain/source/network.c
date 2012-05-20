#include <string.h>

#include "network.h"

#include "queue.h"
#include "semphr.h"

#include "buffer.h"

#define NETWORK_ADDRESS 1

#define MAX_RPC_NUM 10

int htons(unsigned short s) {
    return (s & 0xFF) << 8 | (s >> 8);
}

int ntohs(unsigned short s) {
    return (s & 0xFF) << 8 | (s >> 8);
}

xQueueHandle rpcInputQueue;

struct handlerInfo {
    unsigned short num;
    rpcHandler handler;
    bool hasResponse;
};

static int currHandler = 0;

static struct handlerInfo handlers[MAX_RPC_NUM + 1];

static void networkSendMessageFrom(struct dataQueueEntry *entry, enum dataSource source) {
    entry->dest = 0xFFFF; // TODO: fix this

    switch(source) {
        case SOURCE_BUS:
            if(!xQueueSend(wirelessOutputQueue, entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
        case SOURCE_WIRELESS:
            if(!xQueueSend(busOutputQueue, entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
        case SOURCE_SELF:
            entry->buffer->refcount++;
            if(!xQueueSend(wirelessOutputQueue, entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            if(!xQueueSend(busOutputQueue, entry, 5)) { // TODO: see if this delay is reasonable
                bufferFree(entry->buffer);
            }
            break;
    }
}

// RPCs should be registered before the scheduler starts!
void registerRPCHandler(rpcHandler handler, bool hasResponse, int num) {
    if (num == 0)
        return;

    int index = currHandler++;

    handlers[index].num = num;
    handlers[index].handler = handler;
    handlers[index].hasResponse = hasResponse;
}

static int findRPCHandler(int num) {
    int i;
    for (i = 0; i < currHandler; i++) {
        if(handlers[i].num == num) {
            return i;
        }
    }

    return -1;
}

#define MAX_OUTSTANDING_RPCS 4
#define MAX_RPC_RETRIES 4

static unsigned short currSerial = 0;

xQueueHandle freeHandleNumbers;
xSemaphoreHandle handlesLock; // TODO: check locking discipline

struct handleInfo {
    unsigned short serial;
    unsigned short remoteAddr;
    bool active;
    xQueueHandle queue;
};

struct handleInfo handles[MAX_OUTSTANDING_RPCS];

// These two functions assume lock is held
static short findHandle(unsigned short serial) {
    int i;
    for (i = 0; i < MAX_OUTSTANDING_RPCS; i++) {
        if (handles[i].active && handles[i].serial == serial)
            return i;
    }
    return -1;
}

static unsigned short allocHandle() {
    unsigned short handleNum;
    xQueueReceive(freeHandleNumbers, &handleNum, portMAX_DELAY);
    handles[handleNum].serial = currSerial++;
    return handleNum;
}

static void freeHandle(unsigned short handleNum) {
    handles[handleNum].active = false;
    xQueueSend(freeHandleNumbers, &handleNum, portMAX_DELAY);
}

bool allocRPCBuffer(struct rpcDataBuffer *h) {
    memset(h, 0, sizeof(struct rpcDataBuffer));
    h->impl = bufferAlloc();
    if(h->impl == NULL)
        return false;
    
    h->data = h->impl->data + 8;
    return true;
}
void freeRPCBuffer(struct rpcDataBuffer *h) {
    bufferFree(h->impl);
}

//bool sendRPCCall(unsigned short outLen, struct refcountBuffer *outBuffer, unsigned short *replyLen,
//struct refcountBuffer **replyBuffer, unsigned short to, unsigned short rpcNum, unsigned short waitTime) {

bool doRPCCall(struct rpcDataBuffer *requestData, struct rpcDataBuffer *replyData, unsigned short to, unsigned short rpcNum,
                 unsigned short retries, unsigned short waitTime) {

    struct dataQueueEntry outEntry;

    unsigned short hostHandle;

    if(retries > 0) {
        requestData->impl->refcount++;
        xSemaphoreTake(handlesLock, portMAX_DELAY);
        hostHandle = allocHandle();
        handles[hostHandle].active = true;
        xSemaphoreGive(handlesLock);
    }

    outEntry.buffer = requestData->impl;
    outEntry.length = requestData->len + 8;
    unsigned short from = htons(NETWORK_ADDRESS);
    to = htons(to);
    unsigned short serial = retries > 0 ? htons(handles[hostHandle].serial) : 0;
    rpcNum = htons(rpcNum);
    memcpy(outEntry.buffer->data, &from, 2);
    memcpy(outEntry.buffer->data + 2, &to, 2);
    memcpy(outEntry.buffer->data + 4, &serial, 2);
    memcpy(outEntry.buffer->data + 6, &rpcNum, 2);

    int i;
    for (i = 0; i <= retries; i++) {
        networkSendMessageFrom(&outEntry, SOURCE_SELF);

        if(waitTime == 0) {
            return true;
        }

        struct dataQueueEntry replyEntry;
        if(!xQueueReceive(handles[hostHandle].queue, &replyEntry, waitTime)) {
            continue;
        }

        replyData->impl = replyEntry.buffer;
        replyData->len = replyEntry.length - 8;
        break;
    }

    freeHandle(hostHandle);

    return i <= MAX_RPC_RETRIES;
}

static void rpcThreadLoop(void *parameters) {
    struct dataQueueEntry entry;
    struct dataQueueEntry outEntry;

    while(1) {
        // Wait for available messages
        xQueueReceive(rpcInputQueue, &entry, portMAX_DELAY);

        unsigned short rpcNum = entry.buffer->data[6] << 8 | entry.buffer->data[7];
        int contentsLength = entry.length - 8;
        unsigned short outputLength = BUFFER_SIZE - 8;
        
        int h = findRPCHandler(rpcNum);

        if (h >= 0) {
            if (handlers[h].hasResponse) {
                outEntry.buffer = bufferAlloc();
                if (outEntry.buffer != NULL && handlers[h].handler(contentsLength, entry.buffer->data + 8, &outputLength, outEntry.buffer->data + 8)) {
                    outEntry.length = outputLength + 8;
                    memcpy(outEntry.buffer->data, entry.buffer->data + 2, 2);
                    memcpy(outEntry.buffer->data + 2, entry.buffer->data, 2);
                    memcpy(outEntry.buffer->data + 4, entry.buffer->data + 4, 2);
                    memset(outEntry.buffer->data + 6, 0, 2);
                    networkSendMessageFrom(&outEntry, SOURCE_SELF);
                } else {
                    bufferFree(entry.buffer);
                }
            } else {
                handlers[h].handler(contentsLength, entry.buffer->data + 8, NULL, NULL);
            }
        }
        bufferFree(entry.buffer);
    }
}

void startRPC() {
    rpcInputQueue = xQueueCreate( 4, sizeof (struct dataQueueEntry));
    freeHandleNumbers = xQueueCreate( MAX_OUTSTANDING_RPCS, sizeof (unsigned short));

    unsigned short i;
    for (i = 0; i < 2; i++) {
        xTaskCreate(rpcThreadLoop, (signed char *) "rpc", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
    }

    for (i = 0; i < MAX_OUTSTANDING_RPCS; i++) {
        xQueueSend(freeHandleNumbers, &i, 0);
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
            unsigned short serial = (buf->data[5] << 8) | buf->data[6];
            unsigned short from = (buf->data[0] << 8) | buf->data[1];
            
            xSemaphoreTake(handlesLock, portMAX_DELAY);
            short handle = findHandle(serial);
            if (handle > 0 && handles[handle].remoteAddr == from) {
                if(!xQueueSend(handles[handle].queue, &entry, 0)) {
                    bufferFree(buf);
                }
                handles[handle].active = false;
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
