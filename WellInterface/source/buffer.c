#include "buffer.h"

xQueueHandle computerOutputQueue;
xQueueHandle busOutputQueue;
static xQueueHandle freeBufferQueue;

#define NUM_BUFFERS 6
#define BUFFER_SIZE 128

static char buffers[NUM_BUFFERS][BUFFER_SIZE];

char *bufferAlloc() {
    char *buffer;
    xQueueReceive(freeBufferQueue, &buffer, portMAX_DELAY);
    return buffer;
}

void bufferFree(char *buffer) {
    xQueueSend(freeBufferQueue, &buffer, portMAX_DELAY);
}

void initBufferQueues() {
    computerOutputQueue = xQueueCreate( 3, sizeof(char *));
    busOutputQueue = xQueueCreate( 3, sizeof(char *));
    freeBufferQueue = xQueueCreate( NUM_BUFFERS, sizeof(char *));

    int i;
    for (i = 0; i < NUM_BUFFERS; i++) {
        bufferFree(buffers[i]);
    }
}
