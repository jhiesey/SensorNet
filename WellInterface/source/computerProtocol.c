#include "computerProtocol.h"
#include <stdbool.h>

#include "task.h"
#include "queue.h"

#include "computerIO.h"
#include "buffer.h"
#include "network.h"


#define START_BYTE 128

static short getByteCallback() {
    unsigned char byte;
    if(!receiveByteComputer(&byte, 10))
        return -1;

    return byte;
}

static void computerReceiveTaskLoop(void *parameters) {

    initializeComputerIO();

//    while(1) {
//        unsigned char data;
//        receiveByteComputer(&data, portMAX_DELAY);
//        sendByteComputer(data);
//    }

    while(1) {
        unsigned char byte;
        unsigned char csum = 0;
        while (1) {
            if(!receiveByteComputer(&byte, portMAX_DELAY))
                continue;
            if(byte == START_BYTE)
                break;
        }

        // Get length
        if(!receiveByteComputer(&byte, 10))
            continue;

        int len = byte;
        csum += byte;

        networkHandleMessage(len, getByteCallback, csum, SOURCE_COMPUTER, 0);
    }
}

static void computerTransmitTaskLoop(void *parameters) {
    struct dataQueueEntry entry;

    while(1) {
        // Wait for available data
        xQueueReceive(computerOutputQueue, &entry, portMAX_DELAY);

        sendByteComputer(START_BYTE);

        unsigned char csum = 0;

        sendByteComputer(entry.length);
        csum += entry.length;

        int i;
        for (i = 0; i < entry.length; i++) {
            sendByteComputer(entry.buffer[i]);
            csum += entry.buffer[i];
        }
        sendByteComputer(~csum);
        bufferFree(entry.buffer);
    }
}

void startComputerReceiverTransmitter() {
    xTaskCreate(computerReceiveTaskLoop, (signed char *) "crx", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
    xTaskCreate(computerTransmitTaskLoop, (signed char *) "ctx", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
}
