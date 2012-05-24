#include "wirelessProtocol.h"
#include <string.h>
#include <stdio.h>

#include "task.h"
#include "queue.h"

#include "serialIO.h"
#include "buffer.h"
#include "network.h"

xQueueHandle wirelessOutputQueue;

#define checkedReceiveWireless(data, wait) do {if(!receiveByteSerial(data, wait)) goto wireless_restart;} while (0)

static short getByteCallback() {
    unsigned char byte;
    if(!receiveByteSerial(&byte, 10))
        return -1;

    return byte;
}

static void wirelessReceiveTaskLoop(void *parameters) {

    initializeSerialIO();

    while(1) {
        unsigned char byte;
        unsigned char csum;
        
wireless_restart:
        csum = 0;

        while (1) {
            if(!receiveByteSerial(&byte, portMAX_DELAY))
                continue;
            if(byte == 0x7E)
                break;
        }

        unsigned short wirelessLength;

        // Get length
        checkedReceiveWireless(&byte, 10);

        wirelessLength = byte << 8;

        checkedReceiveWireless(&byte, 10);

        wirelessLength += byte;

        // Check the frame type
        checkedReceiveWireless(&byte, 10);
        csum += byte;

        if (byte != 0x90) {
            int i;
            for (i = 0; i < wirelessLength; i++) {
                checkedReceiveWireless(&byte, 10);
            }

            continue;
        }

        int i;
        unsigned long long sourceAddr = 0;
        for(i = 7; i >= 0; i--) {
            checkedReceiveWireless(&byte, 10);
            csum += byte;

            sourceAddr |= ((unsigned long long) byte) << (8 * i);
        }

        // Dump reserved field
        checkedReceiveWireless(&byte, 10);
        csum += byte;
        checkedReceiveWireless(&byte, 10);
        csum += byte;

        // Dump options
        checkedReceiveWireless(&byte, 10);
        csum += byte;

        networkHandleMessage(wirelessLength - 12, getByteCallback, csum, SOURCE_WIRELESS, 0);
    }
}

static void wirelessTransmitTaskLoop(void *parameters) {
    struct dataQueueEntry entry;

    while(1) {
        // Wait for available data
        xQueueReceive(wirelessOutputQueue, &entry, portMAX_DELAY);

        unsigned char csum = 0;
        unsigned short wirelessLength = entry.length + 14;

        sendByteSerial(0x7E);
        sendByteSerial(wirelessLength >> 8);
        sendByteSerial(wirelessLength & 0xFF);
        sendByteSerial(0x10);
        sendByteSerial(0x0); // Change to use ID!

        int i;
        unsigned char byte;
        for(i = 7; i >= 0; i--) {
            byte = (entry.dest >> (8 * i)) & 0xFF;
            sendByteSerial(byte);
            csum += byte;
        }

        sendByteSerial(0xFF);
        sendByteSerial(0xFE);
        sendByteSerial(0x0);
        sendByteSerial(0x0);

        for(i = 0; i < entry.length; i++) {
            byte = entry.buffer->data[i];
            sendByteSerial(byte);
            csum += byte;
        }

        csum += 0x0D;
        sendByteSerial(~csum);

        bufferFree(entry.buffer);
    }
}

bool wirelessSend(struct dataQueueEntry *entry, unsigned short waitTime) {
    return xQueueSend(wirelessOutputQueue, entry, waitTime);
}

void startWirelessReceiverTransmitter() {
    wirelessOutputQueue = xQueueCreate( 3, sizeof(struct dataQueueEntry));

    xTaskCreate(wirelessReceiveTaskLoop, (signed char *) "wrx", configMINIMAL_STACK_SIZE + 200, NULL, 5, NULL);
    xTaskCreate(wirelessTransmitTaskLoop, (signed char *) "wtx", configMINIMAL_STACK_SIZE + 200, NULL, 4, NULL);
}
