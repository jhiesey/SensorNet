#include "controls.h"
#include "FreeRTOS.h"
#include "semphr.h"
#include "task.h"
#include <p24FJ256GB206.h>

#define NUM_LIGHTS 4
#define NUM_BUTTONS 5
#define BUTTON_DEBOUNCE_TIME 10

static xSemaphoreHandle controlsLock;
static unsigned int lState;
static enum buttonState bState[NUM_BUTTONS];
static buttonHandler bHandler = NULL;
static int buttonTimer;

static void buttonsDelay (void) {
	int i;
	for (i = 0; i < 10; i++)
		portNOP();
}

static void controlsTaskLoop (void *parameters) {
	portTickType lastWakeTime = xTaskGetTickCount();

	while(1) {
		int i;
		enum buttonState newButtonState[NUM_BUTTONS];
		xSemaphoreTake(controlsLock, portMAX_DELAY);	
		
		LATD |= 0b111110; // Switch off lights
		TRISD |= 0b11110; // Switch to inputs
		LATD |= 0b1000000; // Enable first bank of switches

		buttonsDelay();

		newButtonState[0] = PORTDbits.RD4;
		newButtonState[1] = PORTDbits.RD3;
		newButtonState[2] = PORTDbits.RD2;
		newButtonState[3] = PORTDbits.RD1;

		LATD &= ~0b1000000;
		LATD |= 0b10000000; // Enable second bank of switches

		buttonsDelay();

		newButtonState[4] = PORTDbits.RD4;

		LATD &= ~0b10000000;
		TRISD &= ~0b11110;

		LATD &= ~((lState & 0xF) << 1); // Clear lights that should be on

		LATD &= ~0b100000; // Switch lights back on

		for(i = 0; i < NUM_BUTTONS; i++) {
			if((bState[i] & 1) != newButtonState[i]) {
				buttonTimer = BUTTON_DEBOUNCE_TIME;
				bState[i] ^= 0b11; // Set UP to PRESSED and DOWN to RELEASED
			}
		}

		if(buttonTimer == 0) {
			if(bHandler != NULL) {
				bHandler(bState);
			}
			for(i = 0; i < NUM_BUTTONS; i++) {
				bState[i] = newButtonState[i];
			}
			buttonTimer = -1;
		} else if(buttonTimer > 0) {
			buttonTimer--;
		}

		xSemaphoreGive(controlsLock);
		vTaskDelayUntil(&lastWakeTime, 2);
	}
}

void controlsInit(void) {
	controlsLock = xSemaphoreCreateMutex();

	xTaskCreate(controlsTaskLoop, (signed char *) "controls", configMINIMAL_STACK_SIZE, NULL, configMAX_PRIORITIES - 1, NULL);
}

void setLights(enum lightState *state) {
	int i;
	xSemaphoreTake(controlsLock, portMAX_DELAY);
	for(i = 0; i < NUM_LIGHTS; i++) {
		switch(state[i]) {
			case LIGHT_OFF:
				lState &= ~(1 << i);
				break;
			case LIGHT_ON:
				lState |= 1 << i;
				break;
			case LIGHT_TOGGLE:
				lState ^= 1 << i;
				break;
			default:
				break;
		}
	}
	xSemaphoreGive(controlsLock);
}

void registerButtonHandler(buttonHandler handler) {
	xSemaphoreTake(controlsLock, portMAX_DELAY);
	bHandler = handler;
	xSemaphoreGive(controlsLock);
}

void getButtons(enum buttonState *state) {
	int i;
	xSemaphoreTake(controlsLock, portMAX_DELAY);
	for(i = 0; i < NUM_BUTTONS; i++) {
		state[i] = bState[i] & 1;
	}
	xSemaphoreGive(controlsLock);
}
