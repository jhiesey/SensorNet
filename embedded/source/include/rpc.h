#ifndef RPC_H
#define RPC_H

#include <stdbool.h>

#include "config.h"
#include "FreeRTOS.h"

#include "network.h"
#include "buffer.h"

#define MAX_RPC_SIZE (BUFFER_SIZE - 8)

struct rpcDataBuffer {
    struct refcountBuffer *impl;
    void *data;
    unsigned short len;
};

bool allocRPCBuffer(struct rpcDataBuffer *h);
void freeRPCBuffer(struct rpcDataBuffer *h);
bool doRPCCall(struct rpcDataBuffer *requestData, struct rpcDataBuffer *replyData, unsigned short to, unsigned short rpcNum,
                 unsigned short retries, unsigned short waitTime);

typedef bool (*rpcHandler)(unsigned short inLen, void *inData, unsigned short *outLen, void *outData);
void registerRPCHandler(rpcHandler handler, bool hasResponse, int num);

void startRPC();
void handleRPCPacket(struct dataQueueEntry *entry);

#include "buffer.h"


#endif
