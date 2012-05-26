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
        sendEscaped(entry->buffer->data[i], false);
        csum += entry->buffer->data[i];
    }
    sendEscaped(~csum, false); // The next operation will be the next poll
    bufferFree(entry->buffer);
    return true;
}

static short getByteCallback() {
    short byte;
    if(!receiveEscaped(&byte, 10))
        return -1;

    return byte;
}

static int doBusReceive(unsigned char devID) {
    short byte;
    unsigned char csum = 0;
    bool forMe = true;

    if(!receiveEscaped(&byte, 10))
        return -2;

    if (byte != START)
        return -1;

    if(!receiveEscaped(&byte, 10))
        return -1;

    csum += byte;

    if (byte != MY_ADDR && byte != BROADCAST_ADDR)
        forMe = -1;

    if(!receiveEscaped(&byte, 10))
        return -1;

    int len = (unsigned char) byte;
    csum += byte;

    if (forMe && len > 0) {
        return networkHandleMessage(len, getByteCallback, csum, PORT_BUS, devID) ? 0 : -1;
    } else {
        // Wait until the message is over
        bool valid = true;
        int i;
        // Read all of the data, plus the checksum
        for (i = 0; i <= len; i++) {
            valid = valid && receiveEscaped(&byte, 10);
            csum += byte;
        }
        return (valid && (csum + 1) % 256 == 0) ? 0 : -1;
    }
}

#define BUS_MAX_REMOTES 32

#define BITFIELD_NUM_INTS ((BUS_MAX_REMOTES - 1) / sizeof(unsigned int) + 1)

static unsigned int activeDevices[BITFIELD_NUM_INTS];
static unsigned int currentActive;
static unsigned int currentInactive;

static int searchActive(bool active, int start) {
    if(start < 0)
        start = 0;

    int var = start << 4;
    int off = start & 0x10;
    for(; var < BITFIELD_NUM_INTS; var++) {
        unsigned int curr = activeDevices[var];
        for(; off < 16; off++) {
            if((curr & 1) ^ active ? 0 : 1) {
                return var * 16 + off;
            }
        }
        off = 0;
    }
    return -1;
}

/* Returns the next address to poll */
static int getNextDevice() {
    while(true) {
        currentActive = searchActive(true, currentActive);
        if(currentActive > 0)
            return currentActive + 1;
    
        if(currentActive < 0) {
            currentInactive = searchActive(false, currentInactive);
            if(currentInactive > 0)
                return currentInactive + 1;
        }
    }
}

static void setDeviceState(int device, bool state) {
    device--;

    int var = device << 4;
    int off = device & 0x10;
    if(state)
        activeDevices[var] |= (1 << off);
    else
        activeDevices[var] &= ~(1 << off);
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

        if (devID == MY_ADDR) {
            sendEscaped(~csum, false);
            // Talk
            prevSuccess = doBusSend(&entry);
        } else {
            sendEscaped(~csum, true);
            // Listen
            int status = doBusReceive(devID);
            prevSuccess = status == 0;
            setDeviceState(devID, status != -2);
        }
    }
}

bool busSend(struct dataQueueEntry *entry, unsigned short waitTime) {
    return xQueueSend(busOutputQueue, entry, waitTime);
}

void startBusReceiver() {
    busOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));

    xTaskCreate(busTaskLoop, (signed char *) "bus", configMINIMAL_STACK_SIZE + 200, NULL, 5, NULL);
}
