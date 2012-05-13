#include <p24FJ64GB002.h>
#include <uart.h>
#include <ports.h>
#include <assert.h>

#include "FreeRTOS.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

#include "computerProtocol.h"
#include "busProtocol.h"

_CONFIG1 (FWDTEN_OFF & ICS_PGx1 & GWRP_OFF & GCP_OFF & JTAGEN_OFF);
_CONFIG2 (POSCMOD_NONE & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSDCMD & FNOSC_FRC & PLL96MHZ_OFF & IESO_OFF);
_CONFIG3 (SOSCSEL_IO);

void initHardware(void) {
    __builtin_write_OSCCONL(OSCCON & 0xBF);
    // Configure RS485 UART pins
    RPINR18bits.U1RXR = 7;
//    RPOR4bits.RP9R = 4;
    RPOR4bits.RP8R = 3;

    // Configure RS232 UART pins
    RPINR19bits.U2RXR = 11;
    RPOR5bits.RP10R = 5;

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
    TRISB = 0x880;
}


int main(void) {
    initHardware();

    startComputerReceiver();
    startBusReceiver();

    vTaskStartScheduler();

    return 0;
}

void vApplicationIdleHook(void) {
//	vCoRoutineSchedule();
}

