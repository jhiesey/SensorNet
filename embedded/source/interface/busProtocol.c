#include <stdbool.h>

#include "busProtocol.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

#include "buffer.h"
#include "network.h"
#include "busIO.h"

xQueueHandle busOutputQueue;

enum busByteRepr {
    SYNC = 256,
    START
};

#define ESC_VAL 16

static unsigned char specialTokenValues[] = {128, 129, ESC_VAL};
static unsigned char specialTokenSubstitutes[] = {192, 193, 194};

static void sendEscaped(short data, bool last) {
    if (data > 255) {
        data = specialTokenValues[data - 256];
    } else {
        int i;
        for (i = 0; i < sizeof(specialTokenValues); i++) {
            if (specialTokenValues[i] == data) {
                data = specialTokenSubstitutes[i];
                sendByteBus(ESC_VAL, false);
                break;
            }
        }
    }
    sendByteBus(data, last);
}

static portBASE_TYPE receiveEscaped(short *data, portTickType ticksToWait) {
    unsigned char byte;
    portBASE_TYPE result = receiveByteBus(&byte, ticksToWait);
    if (!result)
        return 0;

    int i;

    if (byte == ESC_VAL) {
        result = receiveByteBus(&byte, ticksToWait);
        if (!result)
            return 0;

        for (i = 0; i < sizeof(specialTokenValues); i++) {
            if (specialTokenSubstitutes[i] == byte) {
                *data = specialTokenValues[i];
                return result;
            }
        }
        return 0; // Invalid input
    }

    *data = byte;

    for (i = 0; i < sizeof(specialTokenValues); i++) {
        if (specialTokenValues[i] == byte) {
            *data = i + SYNC;
        }
    }

    return result;
}

#define MY_ADDR 1
#define BROADCAST_ADDR 255

static void doBusSend() {
    struct dataQueueEntry entry;
    vTaskDelay(5);
    sendEscaped(START, false);

    // Check for available data
    if (xQueueReceive(busOutputQueue, &entry, 0)) {
        unsigned char csum = 0;
        sendEscaped(entry.dest, false);
        csum += entry.dest;

        sendEscaped(entry.length, false);
        csum += entry.length;

        int i;
        for (i = 0; i < entry.length; i++) {
            sendEscaped(entry.buffer->data[i], false);
            csum += entry.buffer->data[i];
        }
        sendEscaped(~csum, true);
        bufferFree(entry.buffer);
    } else {
        sendEscaped(0, false);
        sendEscaped(0, false);
        sendEscaped(255, true);
    }
}

static short getByteCallback() {
    short byte;
    if(!receiveEscaped(&byte, 10))
        return -1;

    return byte;
}

static void doBusReceive(unsigned char devID) {
    short byte;
    unsigned char csum = 0;
    if(!receiveEscaped(&byte, 10))
        return;

    if (byte != START)
        return;

    if(!receiveEscaped(&byte, 10))
        return;

    csum += byte;

    if (byte != MY_ADDR && byte != BROADCAST_ADDR)
        return;

    if(!receiveEscaped(&byte, 10))
        return;

    int len = byte;
    csum += byte;

    networkHandleMessage(len, getByteCallback, csum, SOURCE_BUS, devID);
}


static void busTaskLoop(void *parameters) {

    initializeBusIO();

    while(1) {
        short byte;
        unsigned char csum = 0;
        while (1) {
            if(!receiveEscaped(&byte, portMAX_DELAY))
                continue;
            if(byte == SYNC)
                break;
        }

        // Get device ID
        if(!receiveEscaped(&byte, 10))
            continue;

        unsigned char devID = byte;
        csum += byte;

        // Get checksum
        if(!receiveEscaped(&byte, 10))
            continue;

        csum += byte;

        if ((csum + 1) % 256 != 0)
            continue;

        if (devID == MY_ADDR) {
            // TalkF
            doBusSend();
        } else {
            // Listen
            doBusReceive(devID);
        }
    }
}

bool busSend(struct dataQueueEntry *entry, unsigned short waitTime) {
    return xQueueSend(busOutputQueue, entry, waitTime);
}

void startBusReceiver() {
    busOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));

    xTaskCreate(busTaskLoop, (signed char *) "bus", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
}
