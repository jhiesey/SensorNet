#include <stdbool.h>

#include "buffer.h"

static xQueueHandle freeBufferQueue;

#define NUM_BUFFERS 6

static struct refcountBuffer buffers[NUM_BUFFERS];

struct refcountBuffer *bufferAlloc(unsigned short waitTime) {
    struct refcountBuffer *buffer;
    if(!xQueueReceive(freeBufferQueue, &buffer, waitTime))
        return NULL;
    buffer->refcount = 1;
    return buffer;
}

void bufferFree(struct refcountBuffer *buffer) {
    if (buffer == NULL)
        return;
    
    bool mustFree = false;
    portENTER_CRITICAL();
    if (--(buffer->refcount) == 0) {
        mustFree = true;
    }
    portEXIT_CRITICAL();
    
    if (mustFree) {
        xQueueSend(freeBufferQueue, &buffer, portMAX_DELAY);
    }
}

void bufferRetain(struct refcountBuffer *buffer) {
    portENTER_CRITICAL();
    buffer->refcount++;
    portEXIT_CRITICAL();
}

void initBufferQueues() {
    freeBufferQueue = xQueueCreate( NUM_BUFFERS, sizeof(struct refcountBuffer *));

    int i;
    for (i = 0; i < NUM_BUFFERS; i++) {
        struct refcountBuffer *buf = buffers + i;
        xQueueSend(freeBufferQueue, &buf, portMAX_DELAY);
    }
}
