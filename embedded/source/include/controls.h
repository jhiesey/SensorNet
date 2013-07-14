#ifndef CONTROLS_H
#define CONTROLS_H

#include "config.h"

#define NUM_LIGHTS 4
#define NUM_BUTTONS 5

enum lightState {
	LIGHT_NOCHANGE,
	LIGHT_OFF,
	LIGHT_ON,
	LIGHT_TOGGLE
};

enum buttonState {
	BUTTON_UP,
	BUTTON_DOWN,
	BUTTON_RELEASED,
	BUTTON_PRESSED
};

typedef void (*buttonHandler)(enum buttonState *state);

void controlsInit(void);
void setLights(enum lightState *state);
void getButtons(enum buttonState *state);
void registerButtonHandler(buttonHandler handler);

#endif
