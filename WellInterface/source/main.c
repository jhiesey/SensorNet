#include <p24FJ64GB002.h>
#include <uart.h>
#include <ports.h>

#include "FreeRTOS.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

_CONFIG1 (FWDTEN_OFF & ICS_PGx1 & GWRP_OFF & GCP_OFF & JTAGEN_OFF);
_CONFIG2 (POSCMOD_NONE & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSDCMD & FNOSC_FRC & PLL96MHZ_OFF & IESO_OFF);
_CONFIG3 (SOSCSEL_IO);

void initHardware(void) {
    __builtin_write_OSCCONL(OSCCON & 0xBF);
    // Configure RS485 UART pins
    RPINR18bits.U1RXR = 7;
    RPOR4bits.RP9R = 4;
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

    // Open the port for the computer connection
    OpenUART2(UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE & UART_MODE_SIMPLEX & UART_UEN_00 & UART_DIS_WAKE & UART_DIS_LOOPBACK & UART_DIS_ABAUD & UART_NO_PAR_8BIT & UART_UXRX_IDLE_ONE & UART_BRGH_SIXTEEN & UART_1STOPBIT,
        UART_INT_TX & UART_IrDA_POL_INV_ZERO & UART_SYNC_BREAK_DISABLED & UART_TX_ENABLE & UART_INT_RX_CHAR & UART_ADR_DETECT_DIS, 25);
}

static xQueueHandle computerRxQueue;
static xQueueHandle computerTxQueue;


void mainTaskLoop(void *parameters) {

    // Turn on the UART interrupts
    EnableIntU2RX;
    EnableIntU2TX;
    IEC4bits.U2ERIE = 1;

    while(1) {
        char data;
        xQueueReceive(computerRxQueue, &data, portMAX_DELAY);
        xQueueSendToBack(computerTxQueue, &data, portMAX_DELAY);
        IFS1bits.U2TXIF = 1;
    }
}

int main(void) {
    initHardware();

    computerRxQueue = xQueueCreate( 4, sizeof (char));
    computerTxQueue = xQueueCreate( 4, sizeof (char));

    xTaskCreate(mainTaskLoop, (signed char *) "main", configMINIMAL_STACK_SIZE + 100, NULL, 1, NULL);

    vTaskStartScheduler();

    return 0;
}

void vApplicationIdleHook(void) {
	vCoRoutineSchedule();
}


void __attribute__((__interrupt__, auto_psv)) _U2RXInterrupt( void ) {
    portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS1bits.U2RXIF = 0;

    while(DataRdyUART2()) {
        char byte = ReadUART2();
        xQueueSendToBackFromISR(computerRxQueue, &byte, &higherPriorityTaskWoken);
    }

    U2STAbits.OERR = 0;
    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}

void __attribute((__interrupt__, auto_psv)) _U2TXInterrupt( void ) {
     portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS1bits.U2TXIF = 0;

    while(!(U2STAbits.UTXBF)) {
        char byte;
        if (xQueueReceiveFromISR(computerTxQueue, &byte, &higherPriorityTaskWoken)) {
            WriteUART2(byte);
        } else {
            break;
        }
    }

    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}



///* Standard includes. */
//#include <stdio.h>
//#include <string.h>
//
///* Scheduler includes. */
//#include "FreeRTOS.h"
//#include "task.h"
//#include "queue.h"
//#include "semphr.h"
//#include "croutine.h"
//
//#include "controls.h"
//#include "lcd.h"
//
///* Configuration directives. */
//_CONFIG1(WDTPS_PS1 & FWPSA_PR32 & ALTVREF_ALTVREDIS & WINDIS_OFF & FWDTEN_OFF & ICS_PGx1 & GWRP_OFF & GCP_OFF & JTAGEN_OFF);
//_CONFIG2(POSCMOD_HS & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSDCMD & FNOSC_PRI & PLL96MHZ_OFF & PLLDIV_DIV2 & IESO_OFF);
//_CONFIG3(WPFP_WPFP255 & SOSCSEL_LPSOSC & WUTSEL_FST & ALTPMP_ALPMPDIS & WPDIS_WPDIS & WPCFG_WPCFGDIS & WPEND_WPSTARTMEM);
//
//static xQueueHandle mainQueue;
//static xSemaphoreHandle mainLock;
//static enum buttonState bState[5];
//
//static void bHandler(enum buttonState *state) {
//	xSemaphoreTake(mainLock, portMAX_DELAY);
//	memcpy(bState, state, sizeof(bState));
//	xQueueSend(mainQueue, NULL, 0);
//	xSemaphoreGive(mainLock);
//}
//
//static void mainTaskLoop(void *parameters) {
//	static enum lightState lState[4];
//	static enum buttonState localBState[5];
//	int i;
//
//	for(i = 0; i < 4; i++)
//		lState[i] = LIGHT_OFF;
//
//	setLights(lState);
//	LCDSetCursorType (CURSOR_BOTH);
//
//	while(1) {
//		xQueueReceive(mainQueue, NULL, portMAX_DELAY);
//		xSemaphoreTake(mainLock, portMAX_DELAY);
//		memcpy(localBState, bState, sizeof(localBState));
//		xSemaphoreGive(mainLock);
//
//		memset(lState, 0, sizeof(lState));
//		for(i = 0; i < 5; i++) {
//			if(localBState[i] == BUTTON_RELEASED) {
//				lState[i % 4] = LIGHT_TOGGLE;
//				printf ("%d rel!\n", i);
//			} else if (localBState[i] == BUTTON_PRESSED) {
//				printf ("%d pressed... ", i);
//			}
//		}
//		setLights(lState);
//		//LCDWrite(1, 7, "worked!");
//	}
//}
//
//static void mainTaskInit(void) {
//	mainQueue = xQueueCreate(1, 0);
//	mainLock = xSemaphoreCreateMutex();
//
//	registerButtonHandler(bHandler);
//
//	xTaskCreate(mainTaskLoop, (signed char *) "main", configMINIMAL_STACK_SIZE + 100, NULL, 1, NULL);
//}
//
//int main(void) {
//	TRISGbits.TRISG9 = 0;
//	LATGbits.LATG9 = 1;
//
//	TRISD = 0;
//	LATD = 0b00111110;
//
//	LATE = 0;
//	TRISE = 0;
//
//	controlsInit();
//	LCDInit();
//
//	mainTaskInit();
//
//	vTaskStartScheduler();
//
//	return 0;
//}
//
//void vApplicationIdleHook(void) {
//	vCoRoutineSchedule();
//}
