#include <p24FJ64GB002.h>
#include <stdbool.h>

#include "busProtocol.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

#include "buffer.h"
#include "network.h"
#include "busIO.h"

enum busByteRepr {
    SYNC = 256,
    START
};

#define ESC_VAL 16

static char specialTokenValues[] = {128, 129, ESC_VAL};
static char specialTokenSubstitutes[] = {192, 193, 194};

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
    char byte;
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
    vTaskDelay(500);
    sendEscaped(START, false);

    // Check for available data
    if (xQueueReceive(busOutputQueue, &entry, 0)) {
        char csum = 0;
        sendEscaped(entry.dest, false);
        csum += entry.dest;

        sendEscaped(entry.length, false);
        csum += entry.length;

        int i;
        for (i = 0; i < entry.length; i++) {
            sendEscaped(entry.buffer[i], false);
            csum += entry.buffer[i];
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

static void doBusReceive() {
    short byte;
    if(!receiveEscaped(&byte, 10))
        return;

    if (byte != START)
        return;

    if(!receiveEscaped(&byte, 10))
        return;

    if (byte != MY_ADDR && byte != BROADCAST_ADDR)
        return;

    if(!receiveEscaped(&byte, 10))
        return;

    int len = byte;
    int i;

    for (i = 0; i < len; i++) {
        if(!receiveEscaped(&byte, 10))
            return;

        networkHandleMessage(len, getByteCallback);
    }

}


static void busTaskLoop(void *parameters) {

    initializeBusIO();

    while(1) {
        short byte;
        char csum = 0;
        char dev_id;
        while (1) {
            if(!receiveEscaped(&byte, portMAX_DELAY))
                continue;
            if(byte == SYNC)
                break;
        }

        // Get device ID
        if(!receiveEscaped(&byte, 10))
            continue;

        dev_id = byte;
        csum += byte;

        // Get checksum
        if(!receiveEscaped(&byte, 10))
            continue;

        csum += byte;

        if (csum + 1 != 0)
            continue;

        if (dev_id == 0) {
            // Listen
            doBusReceive();
        } else if (dev_id == MY_ADDR) {
            // Talk
            doBusSend();
        }
    }
}

void startBusReceiver() {
    xTaskCreate(busTaskLoop, (signed char *) "bus", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
}
