/* Standard includes. */
#include <uart.h>
#include <ports.h>
#include <stdio.h>
#include <string.h>
#include "config.h"

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "croutine.h"

#include "controls.h"
#include "lcd.h"
#include "busProtocol.h"
#include "wirelessProtocol.h"
#include "buffer.h"
#include "rpc.h"

/* Configuration directives. */
_CONFIG1(WDTPS_PS1 & FWPSA_PR32 & ALTVREF_ALTVREDIS & WINDIS_OFF & FWDTEN_OFF & ICS_PGx1 & GWRP_OFF & GCP_OFF & JTAGEN_OFF);
_CONFIG2(POSCMOD_HS & IOL1WAY_OFF & OSCIOFNC_ON & FCKSM_CSDCMD & FNOSC_PRI & PLL96MHZ_OFF & PLLDIV_DIV2 & IESO_OFF);
_CONFIG3(WPFP_WPFP255 & SOSCSEL_LPSOSC & WUTSEL_FST & ALTPMP_ALPMPDIS & WPDIS_WPDIS & WPCFG_WPCFGDIS & WPEND_WPSTARTMEM);

static xQueueHandle mainQueue;
static xSemaphoreHandle mainLock;
static enum buttonState bState[5];

static void bHandler(enum buttonState *state) {
	xSemaphoreTake(mainLock, portMAX_DELAY);
	memcpy(bState, state, sizeof(bState));
	xQueueSend(mainQueue, NULL, 0);
	xSemaphoreGive(mainLock);
}

static bool writeDebugMessage(char *message, unsigned int len) {
    struct rpcDataBuffer buffer;
    if (!allocRPCBuffer(&buffer))
        return false;

    memcpy(buffer.data, message, len);
    buffer.len = len;

    return doRPCCall(&buffer, NULL, 0, 3, 0, 0);
}

static bool testEcho(char *message, unsigned int len) {
    struct rpcDataBuffer in;
    struct rpcDataBuffer out;

    if(!allocRPCBuffer(&in))
        return false;
    
    memcpy(in.data, message, len);
    in.len = len;

    if(!doRPCCall(&in, &out, 0, 1, 3, 1000))
        return false;

    bool correct = out.len == len && memcmp(message, out.data, len) == 0;
    freeRPCBuffer(&out);
    return correct;
}

static void mainTaskLoop(void *parameters) {
	static enum lightState lState[4];
	static enum buttonState localBState[5];
	int i;

	for(i = 0; i < 4; i++)
		lState[i] = LIGHT_OFF;

	setLights(lState);
	LCDSetCursorType (CURSOR_BOTH);

	while(1) {
		xQueueReceive(mainQueue, NULL, portMAX_DELAY);
		xSemaphoreTake(mainLock, portMAX_DELAY);
		memcpy(localBState, bState, sizeof(localBState));
		xSemaphoreGive(mainLock);

		memset(lState, 0, sizeof(lState));
		for(i = 0; i < 5; i++) {
			if(localBState[i] == BUTTON_RELEASED) {
				lState[i % 4] = LIGHT_TOGGLE;
				printf ("%d rel!\n", i);
                                if(testEcho("echo...\n", 8))
                                    printf("worked\n");
			} else if (localBState[i] == BUTTON_PRESSED) {
				printf ("%d pressed... ", i);
                                writeDebugMessage("worked!", 7);
			}
		}
		setLights(lState);
		//LCDWrite(1, 7, "worked!");
	}
}

static void mainTaskInit(void) {
	mainQueue = xQueueCreate(1, 0);
	mainLock = xSemaphoreCreateMutex();

	registerButtonHandler(bHandler);

	xTaskCreate(mainTaskLoop, (signed char *) "main", configMINIMAL_STACK_SIZE + 100, NULL, 1, NULL);
}

void initHardware(void) {
    __builtin_write_OSCCONL(OSCCON & 0xBF);
    // Configure RS485 UART pins
    RPINR18bits.U1RXR = 10;
    RPOR7bits.RP14R = 3;

    // Configure RS232 UART pins
    RPINR19bits.U2RXR = 17;
    RPOR8bits.RP16R = 5;

    __builtin_write_OSCCONL(OSCCON | 0x40);

    // Disable analog inputs and set TRIS
    ANSB = ANSC = ANSD = ANSF = ANSG = 0;

    LATB = 0x4;
    TRISB = 0;

    LATC = 0;
    TRISC = 0;

    LATD = 0x3E;
    TRISD = 0x200;

    LATE = 0;
    TRISE = 0;

    LATF = 0;
    TRISF = 0x30;

    LATG = 0x200;
    TRISG = 0x80;
}

bool printToScreen(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    static char buf[81];
    int validLen = inLen > 80 ? 80 : inLen;
    memcpy(buf, inData, validLen);
    buf[validLen] = 0;

    printf("%s\n", buf);

    return false;
}

bool echo(unsigned short from, unsigned short inLen, void *inData, unsigned short *outLen, void *outData) {
    *outLen = inLen;

    memcpy(outData, inData, inLen);
    return true;
}

int main(void) {

    initHardware();
    initBufferQueues();

    controlsInit();
    LCDInit();

    mainTaskInit();

    startBusReceiver();
    startWirelessReceiverTransmitter();
    startRPC();
    registerRPCHandler(printToScreen, false, 1);
    registerRPCHandler(echo, true, 2);

    vTaskStartScheduler();

    return 0;
}

void vApplicationIdleHook(void) {
	vCoRoutineSchedule();
}
