#include "config.h"

#ifdef MODULE_LIGHTOUTPUT

#include <ports.h>
#include <stdbool.h>
#include <string.h>

#include "FreeRTOS.h"
#include "task.h"

#include "lightOutput.h"
#include "sensor.h"

void sensorInit() {
    TRISB = 0x80;

    OC1R = 0;
    OC2R = 0;
    OC3R = 0;

    OC1CON2 = 0x1;
    OC2CON2 = 0x1;
    OC3CON2 = 0x1;

    OC1RS = 0xFFF;
    OC1CON1 = 0x1C06;
    OC2CON1 = 0x1C06;
    OC3CON1 = 0x1C06;
}

bool changeLightColor(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(inLen != 3) {
        return false;
    }

    *outLen = 3;

    unsigned char *inColors = (unsigned char *) inData;
    unsigned char *outColors = (unsigned char *) outData;

    outColors[0] = OC1R >> 4;
    outColors[1] = OC2R >> 4;
    outColors[2] = OC3R >> 4;

    OC1R = inColors[0] << 4;
    OC2R = inColors[1] << 4;
    OC3R = inColors[2] << 4;

    return true;
}

bool sensorWriteRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {

    if(inLen == 0)
        return false;

    unsigned short index;
    memcpy(&index, inData, 2);
    inLen -= 2;
    inData = (char *) inData + 2;

    switch(ntohs(index)) {
        case 0:
            return changeLightColor(from, inLen, inData, outLen, outData);
        default:
            return false;
    }
}

bool getLightColor(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = 3;

    unsigned char *outColors = (unsigned char *) outData;

    outColors[0] = OC1R >> 4;
    outColors[1] = OC2R >> 4;
    outColors[2] = OC3R >> 4;

    return true;
}

bool sensorReadRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {

    if(inLen == 0)
        return false;

    unsigned short index;
    memcpy(&index, inData, 2);
    inLen -= 2;
    inData = (char *) inData + 2;

    switch(ntohs(index)) {
        case 0:
            return getLightColor(from, inLen, inData, outLen, outData);
        default:
            return false;
    }
}

void vApplicationTickHook() {
    // Not needed
}

void sensorFillAnnounceBuffer(struct rpcDataBuffer *buffer) {
    unsigned short n = ntohs(1);
    unsigned short type = ntohs(0x100);
    memcpy(buffer->data, &n, 2);
    memcpy(buffer->data + 2, &type, 2);
    buffer->len = 4;
}

#endif
