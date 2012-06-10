#include <uart.h>
#include <ports.h>
#include <string.h>
#include "config.h"

#include "FreeRTOS.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"
#include "semphr.h"

#include "busProtocol.h"
#include "buffer.h"
#include "rpc.h"

_CONFIG1 (FWDTEN_OFF & ICS_PGx1 & GWRP_OFF & GCP_OFF & JTAGEN_OFF);
_CONFIG2 (POSCMOD_NONE & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSDCMD & FNOSC_FRC & PLL96MHZ_OFF & IESO_OFF);
_CONFIG3 (SOSCSEL_IO);

void initHardware(void) {
    __builtin_write_OSCCONL(OSCCON & 0xBF);
    // Configure RS485 UART pins
    RPINR18bits.U1RXR = 7;
    RPOR4bits.RP8R = 3;

#ifdef MODULE_LIGHTOUTPUT
    RPOR5bits.RP10R = 18;
    RPOR5bits.RP11R = 19;
    RPOR6bits.RP13R = 20;
#elif defined MODULE_LIGHTSENSOR
    RPINR4bits.T4CKR = 10;
#endif

    __builtin_write_OSCCONL(OSCCON | 0x40);

    // Enable pullups for DIP switches
    EnablePullUpCN2;
    EnablePullUpCN3;
    EnablePullUpCN30;
    EnablePullUpCN29;
    EnablePullUpCN0;

    // Disable analog inputs and set TRIS
    AD1PCFG = 0x1FFF;
    LATA = 0;
    LATB = 0;
    TRISA = 0x1F;

#ifdef MODULE_LIGHTOUTPUT
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
#elif defined MODULE_LIGHTSENSOR
    TRISB = 0x480;

    T4CON = 0xA;
    T4CONbits.TON = 1;
#endif
}

#ifdef MODULE_LIGHTOUTPUT
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

bool writeRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {

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

bool readRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {

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

#elif defined MODULE_LIGHTSENSOR

static unsigned int lightCountL, lightCountH;
static portTickType lastTick;

void vApplicationTickHook() {
    portTickType tick = xTaskGetTickCountFromISR();

    if(tick - lastTick >= 1000) {
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

bool readRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {

    LATBbits.LATB11 = 1;
    portNOP();
    portNOP();
    portNOP();
    portNOP();
    portNOP();
    portNOP();
    portNOP();
    portNOP();
    LATBbits.LATB11 = 0;

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

#endif

bool echo(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = inLen;

    memcpy(outData, inData, inLen);
    return true;
}

bool nullRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    return false;
}

xSemaphoreHandle rpcNotificationSem;

bool queryRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    xSemaphoreGive(rpcNotificationSem);

    return true;
}

static void sensorLoop(void *parameters) {
    while(1) {
        vTaskDelay(1000);
        xSemaphoreTake(rpcNotificationSem, 20000);
        struct rpcDataBuffer buffer;
        if (allocRPCBuffer(&buffer)) {

            unsigned short n = ntohs(1);
#ifdef MODULE_LIGHTOUTPUT
            unsigned short type = ntohs(0x100);
#elif defined MODULE_LIGHTSENSOR
            unsigned short type = 0;
#endif
            memcpy(buffer.data, &n, 2);
            memcpy(buffer.data + 2, &type, 2);
            buffer.len = 4;

            doRPCCall(&buffer, NULL, 0, 0x100, 3, 2000);
        }
    }
}

int main(void) {
    initHardware();
    initBufferQueues();

    startBusReceiver();
    startNetwork();
    startRPC();

    registerRPCHandler(nullRPC, false, 0x1);
    registerRPCHandler(echo, true, 0x2);

    registerRPCHandler(queryRPC, false, 0x101);
    registerRPCHandler(readRPC, true, 0x102);
#ifdef MODULE_LIGHTOUTPUT
    registerRPCHandler(writeRPC, true, 0x103);
#endif

    vSemaphoreCreateBinary(rpcNotificationSem);
    xTaskCreate(sensorLoop, (signed char *) "sen", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);

    vTaskStartScheduler();

    return 0;
}

void vApplicationIdleHook(void) {
	vCoRoutineSchedule();
}
