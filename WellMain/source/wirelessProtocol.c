#include "wirelessProtocol.h"
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "task.h"
#include "queue.h"

#include "wirelessIO.h"
#include "buffer.h"
#include "network.h"


#define checkedReceiveWireless(data, wait) do {if(!receiveByteWireless(data, wait)) goto wireless_restart;} while (0)

static short getByteCallback() {
    unsigned char byte;
    if(!receiveByteWireless(&byte, 10))
        return -1;

    return byte;
}

static void computerReceiveTaskLoop(void *parameters) {

    initializeWirelessIO();

//    while(1) {
//        unsigned char data;
//        receiveByteComputer(&data, portMAX_DELAY);
//        sendByteComputer(data);
//    }

    while(1) {
        unsigned char byte;
        unsigned char csum;
        
wireless_restart:
        csum = 0;

        while (1) {
            if(!receiveByteWireless(&byte, portMAX_DELAY))
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

        static char buf[81];
        int validLen = entry.length > 80 ? 80 : entry.length;
        memcpy(buf, entry.buffer, validLen);
        buf[validLen] = 0;

        printf("%s\n", buf);

        unsigned char csum = 0;
        unsigned short wirelessLength = entry.length + 14;

        sendByteWireless(0x7E);
        sendByteWireless(wirelessLength >> 8);
        sendByteWireless(wirelessLength & 0xFF);
        sendByteWireless(0x10);
        sendByteWireless(0x0); // Change to use ID!

        int i;
        unsigned char byte;
        for(i = 7; i >= 0; i--) {
            byte = (entry.dest >> (8 * i)) & 0xFF;
            sendByteWireless(byte);
            csum += byte;
        }

        sendByteWireless(0xFF);
        sendByteWireless(0xFE);
        sendByteWireless(0x0);
        sendByteWireless(0x0);

        for(i = 0; i < entry.length; i++) {
            byte = entry.buffer[i];
            sendByteWireless(byte);
            csum += byte;
        }

        csum += 0x0D;
        sendByteWireless(~csum);

        bufferFree(entry.buffer);
    }
}

void startWirelessReceiverTransmitter() {
    xTaskCreate(computerReceiveTaskLoop, (signed char *) "wrx", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
    xTaskCreate(wirelessTransmitTaskLoop, (signed char *) "wtx", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
}

