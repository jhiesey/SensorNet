#include "config.h"

#ifdef MODULE_LIGHTSENSOR

#include <ports.h>
#include <stdbool.h>
#include <string.h>

#include "FreeRTOS.h"
#include "task.h"

#include "lightSensor.h"
#include "sensor.h"

void sensorInit() {
    TRISB = 0x480;

    T4CON = 0xA;
    T4CONbits.TON = 1;
}

static unsigned int lightCountL, lightCountH;
static portTickType lastTick;

void vApplicationTickHook() {
    portTickType tick = xTaskGetTickCountFromISR();

    if(tick - lastTick >= 250) {
        lastTick = tick;

        lightCountL = TMR4;
        lightCountH = TMR5HLD;

        TMR5HLD = 0;
        TMR4 = 0;
    }
}

bool getLightValue(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = 4;

    portDISABLE_INTERRUPTS();
    unsigned int lightTempL = lightCountL;
    unsigned int lightTempH = lightCountH;
    portENABLE_INTERRUPTS();

    unsigned long outVal = htons(lightTempL) + ((unsigned long) htons(lightTempH)) << 16;
    memcpy(outData, &outVal, 4);

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
            return getLightValue(from, inLen, inData, outLen, outData);
        default:
            return false;
    }
}

void sensorFillAnnounceBuffer(struct rpcDataBuffer *buffer) {
    unsigned short n = ntohs(1);
    unsigned short type = 0;
    memcpy(buffer->data, &n, 2);
    memcpy(buffer->data + 2, &type, 2);
    buffer->len = 4;
}

#endif
