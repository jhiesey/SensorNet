#include <stdbool.h>

#include "buffer.h"

xQueueHandle wirelessOutputQueue;
xQueueHandle busOutputQueue;
static xQueueHandle freeBufferQueue;

#define NUM_BUFFERS 6

static struct refcountBuffer buffers[NUM_BUFFERS];

struct refcountBuffer *bufferAlloc() {
    struct refcountBuffer *buffer = NULL;
    xQueueReceive(freeBufferQueue, &buffer, 0);
    buffer->refcount = 1;
    return buffer;
}

void bufferFree(struct refcountBuffer *buffer) {
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

void initBufferQueues() {
    wirelessOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));
    busOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));
    freeBufferQueue = xQueueCreate( NUM_BUFFERS, sizeof(struct refcountBuffer *));

    int i;
    for (i = 0; i < NUM_BUFFERS; i++) {
        struct refcountBuffer *buf = buffers + i;
        xQueueSend(freeBufferQueue, &buf, portMAX_DELAY);
    }
}
