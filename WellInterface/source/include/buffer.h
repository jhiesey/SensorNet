#ifndef BUFFER_H
#define BUFFER_H

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

struct dataQueueEntry {
    char dest;
    short length;
    char *buffer;
};

void initBufferQueues();
char *bufferAlloc();
void bufferFree(char *buffer);

extern xQueueHandle computerOutputQueue;
extern xQueueHandle busOutputQueue;

#endif
