#include <uart.h>
#include <ports.h>
#include "config.h"

#include "FreeRTOS.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

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
    TRISB = 0x80;
}

bool changeLED(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = 1;

    if(inLen == 0)
        return false;

    char inState = *(char *) inData;;
    char outState = 0;

    outState |= LATBbits.LATB10 ? 1 : 0;
    outState |= LATBbits.LATB11 ? 2 : 0;
    
    LATBbits.LATB10 = (inState & 0x1) ? 1 : 0;
    LATBbits.LATB11 = (inState & 0x2) ? 1 : 0;

    *(char *) outData = outState;

    return true;
}


int main(void) {
    initHardware();
    initBufferQueues();

    startBusReceiver();
    startNetwork();
    startRPC();

    registerRPCHandler(changeLED, true, 10);

    vTaskStartScheduler();

    return 0;
}

void vApplicationIdleHook(void) {
	vCoRoutineSchedule();
}
