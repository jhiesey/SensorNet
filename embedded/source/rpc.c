#include <string.h>

#include "rpc.h"

#include "queue.h"
#include "semphr.h"

#define MAX_RPC_HANDLERS 10

#define MAX_OUTSTANDING_RPCS 4

/* RPC REPLY HANDLING */
static unsigned short currSerial = 0;

xQueueHandle freeHandleNumbers;
xSemaphoreHandle handlesLock;

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
    handles[handleNum].active = true;
    return handleNum;
}

static void freeHandle(unsigned short handleNum) {
    handles[handleNum].active = false;
    xQueueSend(freeHandleNumbers, &handleNum, portMAX_DELAY);
}

bool allocRPCBuffer(struct rpcDataBuffer *h) {
    memset(h, 0, sizeof(struct rpcDataBuffer));
    h->impl = bufferAlloc(portMAX_DELAY);
    if(h->impl == NULL)
        return false;

    h->data = h->impl->data + 8;
    return true;
}
void freeRPCBuffer(struct rpcDataBuffer *h) {
    bufferFree(h->impl);
}


/* RPC REQUEST HANDLING */
xQueueHandle rpcRequestInputQueue;

struct handlerInfo {
    unsigned short num;
    rpcHandler handler;
    bool hasResponse;
};

static int currHandler = 0;

static struct handlerInfo handlers[MAX_RPC_HANDLERS];

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

void handleRPCPacket(struct dataQueueEntry *entry) {
    struct refcountBuffer *buf = entry->buffer;
    bufferRetain(buf);

    if (buf->data[6] == 0 && buf->data[7] == 0) {
        // This is a reply
        unsigned short serial = (buf->data[4] << 8) | buf->data[5];
        unsigned short from = (buf->data[0] << 8) | buf->data[1];

        xSemaphoreTake(handlesLock, portMAX_DELAY);
        short handle = findHandle(serial);
        if (handle >= 0 && handles[handle].remoteAddr == from) {
            if (!xQueueSend(handles[handle].queue, entry, 0)) {
                bufferFree(buf);
            }
            handles[handle].active = false;
        } else {
            bufferFree(buf);
        }
        xSemaphoreGive(handlesLock);
    } else {
        if (!xQueueSend(rpcRequestInputQueue, entry, 0)) {
            bufferFree(buf);
        }
    }
}

bool doRPCCall(struct rpcDataBuffer *requestData, struct rpcDataBuffer *replyData, unsigned short to, unsigned short rpcNum,
                 unsigned short retries, unsigned short waitTime) {

    struct dataQueueEntry outEntry;

    unsigned short hostHandle;

    if(replyData != NULL) {
        xSemaphoreTake(handlesLock, portMAX_DELAY);
        hostHandle = allocHandle();
        xSemaphoreGive(handlesLock);
    }

    outEntry.buffer = requestData->impl;
    outEntry.length = requestData->len + 8;
    unsigned short from = htons(NETWORK_ADDRESS);
    to = htons(to);
    unsigned short serial = waitTime != NULL ? htons(handles[hostHandle].serial) : 0;
    rpcNum = htons(rpcNum);
    memcpy(outEntry.buffer->data, &from, 2);
    memcpy(outEntry.buffer->data + 2, &to, 2);
    memcpy(outEntry.buffer->data + 4, &serial, 2);
    memcpy(outEntry.buffer->data + 6, &rpcNum, 2);

    struct dataQueueEntry replyEntry;
    int i;
    for (i = 0; i <= retries; i++) {
        bufferRetain(outEntry.buffer);
        handleNetworkPacket(&outEntry, PORT_SELF, 0);

        if(replyData == NULL) {
            bufferFree(outEntry.buffer);
            return true;
        }

        if(!xQueueReceive(handles[hostHandle].queue, &replyEntry, waitTime)) {
            continue;
        }

        replyData->impl = replyEntry.buffer;
        replyData->data = replyEntry.buffer->data + 8;
        replyData->len = replyEntry.length - 8;
        break;
    }

    // Make sure no data is put in the queue right before disabling it
    xSemaphoreTake(handlesLock, portMAX_DELAY);
    freeHandle(hostHandle);
    if(xQueueReceive(handles[hostHandle].queue, &replyEntry, 0)) {
        bufferFree(replyEntry.buffer);
    }
    xSemaphoreGive(handlesLock);

    bufferFree(outEntry.buffer);

    return i <= retries;
}

static void rpcThreadLoop(void *parameters) {
    struct dataQueueEntry entry;
    struct dataQueueEntry outEntry;

    while(1) {
        // Wait for available messages
        xQueueReceive(rpcRequestInputQueue, &entry, portMAX_DELAY);

        unsigned short rpcNum = entry.buffer->data[6] << 8 | entry.buffer->data[7];
        unsigned short from = entry.buffer->data[0] << 8 | entry.buffer->data[1];
        int contentsLength = entry.length - 8;
        unsigned short outputLength = BUFFER_SIZE - 8;

        int h = findRPCHandler(rpcNum);

        if (h >= 0) {
            if (handlers[h].hasResponse) {
                outEntry.buffer = bufferAlloc(0);
                if (outEntry.buffer != NULL && handlers[h].handler(from, contentsLength, entry.buffer->data + 8, &outputLength, outEntry.buffer->data + 8)) {
                    outEntry.length = outputLength + 8;
                    unsigned short replyFrom = htons(NETWORK_ADDRESS);
                    memcpy(outEntry.buffer->data, &replyFrom, 2);
                    memcpy(outEntry.buffer->data + 2, entry.buffer->data, 2);
                    memcpy(outEntry.buffer->data + 4, entry.buffer->data + 4, 2);
                    memset(outEntry.buffer->data + 6, 0, 2);
                    handleNetworkPacket(&outEntry, PORT_SELF, 0);
                } else {
                    bufferFree(entry.buffer);
                }
            } else {
                handlers[h].handler(from, contentsLength, entry.buffer->data + 8, NULL, NULL);
            }
        }
        bufferFree(entry.buffer);
    }
}

void startRPC() {
    rpcRequestInputQueue = xQueueCreate( 4, sizeof (struct dataQueueEntry));
    freeHandleNumbers = xQueueCreate( MAX_OUTSTANDING_RPCS, sizeof (unsigned short));
    handlesLock = xSemaphoreCreateMutex();

    unsigned short i;
    for (i = 0; i < 2; i++) {
        xTaskCreate(rpcThreadLoop, (signed char *) "rpc", configMINIMAL_STACK_SIZE + 200, NULL, 4, NULL);
    }

    for (i = 0; i < MAX_OUTSTANDING_RPCS; i++) {
        xQueueSend(freeHandleNumbers, &i, 0);
        handles[i].queue = xQueueCreate(1, sizeof(struct dataQueueEntry));
    }
}
