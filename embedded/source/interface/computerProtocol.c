#include "computerProtocol.h"
#include <stdbool.h>

#include "task.h"
#include "queue.h"

#include "serialIO.h"
#include "buffer.h"
#include "network.h"

xQueueHandle computerOutputQueue;

#define START_BYTE 128

static short getByteCallback() {
    unsigned char byte;
    if(!receiveByteSerial(&byte, 10))
        return -1;

    return byte;
}

static void computerReceiveTaskLoop(void *parameters) {

    initializeSerialIO();

//    while(1) {
//        unsigned char data;
//        receiveByteComputer(&data, portMAX_DELAY);
//        sendByteComputer(data);
//    }

    while(1) {
        unsigned char byte;
        unsigned char csum = 0;
        while (1) {
            if(!receiveByteSerial(&byte, portMAX_DELAY))
                continue;
            if(byte == START_BYTE)
                break;
        }

        // Get length
        if(!receiveByteSerial(&byte, 10))
            continue;

        int len = byte;
        csum += byte;

        networkHandleMessage(len, getByteCallback, csum, PORT_COMPUTER, 0);
    }
}

static void computerTransmitTaskLoop(void *parameters) {
    struct dataQueueEntry entry;

    while(1) {
        // Wait for available data
        xQueueReceive(computerOutputQueue, &entry, portMAX_DELAY);

        sendByteSerial(START_BYTE);

        unsigned char csum = 0;

        sendByteSerial(entry.length);
        csum += entry.length;

        int i;
        for (i = 0; i < entry.length; i++) {
            sendByteSerial(entry.buffer->data[i]);
            csum += entry.buffer->data[i];
        }
        sendByteSerial(~csum);
        bufferFree(entry.buffer);
    }
}

bool computerSend(struct dataQueueEntry *entry, unsigned short waitTime) {
    return xQueueSend(computerOutputQueue, entry, waitTime);
}

void startComputerReceiverTransmitter() {
    computerOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));

    xTaskCreate(computerReceiveTaskLoop, (signed char *) "crx", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
    xTaskCreate(computerTransmitTaskLoop, (signed char *) "ctx", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
}
