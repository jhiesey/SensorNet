#include <p24FJ256GB206.h>
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

#define MY_ADDR 0
#define BROADCAST_ADDR 255

static bool doBusSend(struct dataQueueEntry *entry) {
    unsigned char csum = 0;
    sendEscaped(START, false);
    sendEscaped(entry->dest & 0xFF, false);
    csum += entry->dest;

    sendEscaped(entry->length, false);
    csum += entry->length;

    int i;
    for (i = 0; i < entry->length; i++) {
        sendEscaped(entry->buffer[i], false);
        csum += entry->buffer[i];
    }
    sendEscaped(~csum, true);
    bufferFree(entry->buffer);
    return true;
}

static short getByteCallback() {
    short byte;
    if(!receiveEscaped(&byte, 10))
        return -1;

    return byte;
}

static bool doBusReceive(unsigned char devID) {
    short byte;
    unsigned char csum = 0;
    bool forMe = true;

    if(!receiveEscaped(&byte, 10))
        return false;

    if (byte != START)
        return false;

    if(!receiveEscaped(&byte, 10))
        return false;

    csum += byte;

    if (byte != MY_ADDR && byte != BROADCAST_ADDR)
        forMe = false;

    if(!receiveEscaped(&byte, 10))
        return false;

    int len = (unsigned char) byte;
    csum += byte;

    if (forMe && len > 0) {
        return networkHandleMessage(len, getByteCallback, csum, SOURCE_BUS, devID);
    } else {
        // Wait until the message is over
        bool valid = true;
        int i;
        // Read all of the data, plus the checksum
        for (i = 0; i <= len; i++) {
            valid = valid && receiveEscaped(&byte, 10);
            csum += byte;
        }
        return valid && (csum + 1) % 256 == 0;
    }
}

/* Returns the next address to poll */
static int getNextDevice() {
    return 1;
}


static void busTaskLoop(void *parameters) {

    initializeBusIO();
    bool prevSuccess = true;

    while(1) {
        unsigned char byte;
        unsigned char csum = 0;

        struct dataQueueEntry entry;
        int devID = 0;

        vTaskDelay(2);

        // If we failed last time, wait until no data is sent for a while
        if (!prevSuccess) {
            while(receiveByteBus(&byte, 500));
        }

        // Check for data to send
        if (!xQueueReceive(busOutputQueue, &entry, 0)) {
            devID = getNextDevice();
        }

        sendEscaped(SYNC, false);
        sendEscaped(devID, false);
        csum += devID;
        sendEscaped(~csum, true);

        if (devID == MY_ADDR) {
            // Talk
            prevSuccess = doBusSend(&entry);
        } else {
            // Listen
            prevSuccess = doBusReceive(devID);
        }

    }
}

void startBusReceiver() {
    xTaskCreate(busTaskLoop, (signed char *) "bus", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
}
