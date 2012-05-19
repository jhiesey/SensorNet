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

typedef bool (*rpcHandler)(unsigned short inLen, void *inData, unsigned short *outLen, struct refcountBuffer *outBuffer);

void startRPC();
void registerRPCCall(rpcHandler handler, int num);
bool sendRPCCall(unsigned short outLen, struct refcountBuffer *outBuffer, unsigned short *replyLen,
struct refcountBuffer **replyBuffer, unsigned short to, unsigned short rpcNum, unsigned short waitTime);

bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, unsigned long long sourceAddr);

#endif
