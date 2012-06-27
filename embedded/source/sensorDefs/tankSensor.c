#include "config.h"

#ifdef MODULE_TANKSENSOR

#include <ports.h>
#include <stdbool.h>
#include <string.h>

#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

#include <incap.h>

#include "tankSensor.h"
#include "sensor.h"

//static unsigned int lightCountL, lightCountH;
//static unsigned long flowCount;
//static portTickType lastTick;

xQueueHandle flowQueue;
xQueueHandle serialRxQueue;

void __attribute((__interrupt__, auto_psv)) _IC1Interrupt( void ) {
    static unsigned long flowCount;
    portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS0bits.IC1IF = 0;

    while(!IC1CON1bits.ICBNE) {
        static unsigned int countL, countH;
        countH = IC2BUF;
        countL = IC1BUF;

//        // Check for too-long intervals
//        if(countH > 1000)
//            continue;

        flowCount = countL | (unsigned long) countH << 16;
        xQueueSendToBackFromISR(flowQueue, &flowCount, &higherPriorityTaskWoken);
    }

    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}

void __attribute((__interrupt__, auto_psv)) _U2RXInterrupt( void ) {
    portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS1bits.U2RXIF = 0;

    while(DataRdyUART2()) {
        unsigned char byte = ReadUART2();
        xQueueSendToBackFromISR(serialRxQueue, &byte, &higherPriorityTaskWoken);
    }

    U2STAbits.OERR = 0;
    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}

static unsigned int flowAccum;

static unsigned int flowRate;
static unsigned long flowTotal;
static unsigned int tankLevel;
static xSemaphoreHandle tankLock;

static void flowLoop(void *parameters) {
    while(1) {
        unsigned long receivedFlow;
        if(xQueueReceive(flowQueue, &receivedFlow, 1000)) {
            flowAccum += 16;
            unsigned int fullLiters = flowAccum / 333;
            if(fullLiters > 0)
                flowAccum = flowAccum % 333;

            xSemaphoreTake(tankLock, portMAX_DELAY);
            flowRate = 1153153153UL / receivedFlow;
            flowTotal += fullLiters;

        } else {
            xSemaphoreTake(tankLock, portMAX_DELAY);
            flowRate = 0;
        }
        xSemaphoreGive(tankLock);
    }
}

static void levelLoop(void *parameters) {
    while(1) {
        int i;
        unsigned char byte;
        unsigned int level;
level_restart:
        while (1) {
            if(!xQueueReceive(serialRxQueue, &byte, portMAX_DELAY))
                continue;
            if(byte == 'R')
                break;
        }

        for(i = 0; i < 3; i++) {
            if(!xQueueReceive(serialRxQueue, &byte, 10) || byte < '0' || byte > '9')
                goto level_restart;

            level = level * 10 + byte;
        }

        if(!xQueueReceive(serialRxQueue, &byte, 10) || byte != 0xD)
            continue;

        xSemaphoreTake(tankLock, portMAX_DELAY);
        tankLevel = level;
        xSemaphoreGive(tankLock);
    }
}

void vApplicationTickHook() {
}

bool getLevel(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = 2;

    xSemaphoreTake(tankLock, portMAX_DELAY);
    unsigned int outVal = htons(tankLevel);
    xSemaphoreGive(tankLock);

    memcpy(outData, &outVal, 2);

    return true;
}

bool getFull(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    // Not implemented

    return false;
}

bool getFlow(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = 2;

    xSemaphoreTake(tankLock, portMAX_DELAY);
    unsigned int outVal = htons(flowRate);
    xSemaphoreGive(tankLock);

    memcpy(outData, &outVal, 2);

    return true;
}

bool getFlowTotal(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = 2;

    xSemaphoreTake(tankLock, portMAX_DELAY);
    unsigned long outVal = htonl(flowTotal);
    xSemaphoreGive(tankLock);

    memcpy(outData, &outVal, 4);

    return true;
}

bool sensorReadRPC(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    if(inLen < 2)
        return false;

    unsigned short index;
    memcpy(&index, inData, 2);
    inLen -= 2;
    inData = (char *) inData + 2;

    switch(ntohs(index)) {
        case 0:
            return getLevel(from, inLen, inData, outLen, outData);
        case 1:
            return getFull(from, inLen, inData, outLen, outData);
        case 2:
            return getFlow(from, inLen, inData, outLen, outData);

        default:
            return false;
    }
}

void sensorFillAnnounceBuffer(struct rpcDataBuffer *buffer) {
    unsigned short n = ntohs(3);
    unsigned short type = 0;
    memcpy(buffer->data, &n, 2);
    memcpy(buffer->data + 2, &type, 2);
    type = 1;
    memcpy(buffer->data + 4, &type, 2);
    type = 2;
    memcpy(buffer->data + 6, &type, 2);
    buffer->len = 8;
}

void sensorInit() {
    TRISB = 0x80;

    IC2CON2bits.IC32 = 1;
    IC1CON2bits.IC32 = 1;

    IC2CON1bits.ICTSEL = 7;
    IC2CON2bits.SYNCSEL = 0;
    IC1CON1bits.ICTSEL = 7;
    IC1CON2bits.SYNCSEL = 0;

    IC1CON1bits.ICI = 1;
    IC1CON1bits.ICM = 4;

    SetPriorityIntIC1(1);
    EnableIntIC1;

    OpenUART2(UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE & UART_MODE_SIMPLEX & UART_UEN_00 & UART_DIS_WAKE & UART_DIS_LOOPBACK & UART_DIS_ABAUD & UART_NO_PAR_8BIT & UART_UXRX_IDLE_ONE & UART_BRGH_SIXTEEN & UART_1STOPBIT,
        UART_INT_TX & UART_IrDA_POL_INV_ZERO & UART_SYNC_BREAK_DISABLED & UART_TX_ENABLE & UART_INT_RX_CHAR & UART_ADR_DETECT_DIS, 25);

    // Turn on the UART interrupts
    SetPriorityIntU2RX(1);
    EnableIntU2RX;

    flowQueue = xQueueCreate(4, sizeof(unsigned long));
    serialRxQueue = xQueueCreate(4, 1);
    tankLock = xSemaphoreCreateMutex();

    xTaskCreate(flowLoop, (signed char *) "flo", configMINIMAL_STACK_SIZE + 50, NULL, 2, NULL);
    xTaskCreate(levelLoop, (signed char *) "lev", configMINIMAL_STACK_SIZE + 50, NULL, 2, NULL);
}

#endif
