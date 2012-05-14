#ifndef BUFFER_H
#define BUFFER_H

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

#define BUFFER_SIZE 128

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
