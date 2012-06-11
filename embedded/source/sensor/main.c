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
#include "sensor.h"

_CONFIG1 (FWDTEN_OFF & ICS_PGx1 & GWRP_OFF & GCP_OFF & JTAGEN_OFF);
_CONFIG2 (POSCMOD_NONE & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSDCMD & FNOSC_FRC & PLL96MHZ_OFF & IESO_OFF);
_CONFIG3 (SOSCSEL_IO);

void initHardware(void) {
    __builtin_write_OSCCONL(OSCCON & 0xBF);
    // Configure RS485 UART pins
    RPINR18bits.U1RXR = 7;
    RPOR4bits.RP8R = 3;

    // Do sensor-specific remapping
    SENSOR_REMAP

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

    sensorInit();
}

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
            sensorFillAnnounceBuffer(&buffer);

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
    
    registerRPCHandler(sensorReadRPC, true, 0x102);
#ifdef SENSOR_WRITABLE
    registerRPCHandler(sensorWriteRPC, true, 0x103);
#endif



    vSemaphoreCreateBinary(rpcNotificationSem);
    xTaskCreate(sensorLoop, (signed char *) "sen", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);

    vTaskStartScheduler();

    return 0;
}

void vApplicationIdleHook(void) {
	vCoRoutineSchedule();
}
