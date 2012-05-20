#ifndef NETWORK_H
#define NETWORK_H

#include <stdbool.h>

#include "FreeRTOS.h"

#include "buffer.h"


enum dataSource {
    SOURCE_BUS,
    SOURCE_WIRELESS,
    SOURCE_SELF
};

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

void startRPC();
void registerRPCHandler(rpcHandler handler, bool hasResponse, int num);
//bool sendRPCCall(unsigned short outLen, struct refcountBuffer *outBuffer, unsigned short *replyLen,
//struct refcountBuffer **replyBuffer, unsigned short to, unsigned short rpcNum, unsigned short waitTime);

bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, unsigned long long sourceAddr);

#endif
