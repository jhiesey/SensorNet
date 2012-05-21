#ifndef BUFFER_H
#define BUFFER_H

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

#define BUFFER_SIZE 128

struct refcountBuffer {
    char refcount;
    char data[BUFFER_SIZE];
};

struct dataQueueEntry {
    unsigned long long dest;
    short length;
    struct refcountBuffer *buffer;
};

void initBufferQueues();

struct refcountBuffer *bufferAlloc(unsigned short waitTime);
void bufferFree(struct refcountBuffer *buffer);
void bufferRetain(struct refcountBuffer *buffer);

extern xQueueHandle wirelessOutputQueue;
extern xQueueHandle busOutputQueue;

#endif
