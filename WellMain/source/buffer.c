#include "buffer.h"

xQueueHandle wirelessOutputQueue;
xQueueHandle busOutputQueue;
static xQueueHandle freeBufferQueue;

#define NUM_BUFFERS 6

static char buffers[NUM_BUFFERS][BUFFER_SIZE];

char *bufferAlloc() {
    char *buffer = NULL;
    xQueueReceive(freeBufferQueue, &buffer, 0);
    return buffer;
}

void bufferFree(char *buffer) {
    xQueueSend(freeBufferQueue, &buffer, portMAX_DELAY);
}

void initBufferQueues() {
    wirelessOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));
    busOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));
    freeBufferQueue = xQueueCreate( NUM_BUFFERS, sizeof(char *));

    int i;
    for (i = 0; i < NUM_BUFFERS; i++) {
        bufferFree(buffers[i]);
    }
}
