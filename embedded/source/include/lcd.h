#ifndef LCD_H
#define LCD_H

#include "config.h"

#define LCD_WIDTH 20
#define LCD_HEIGHT 4

enum cursorType {
	CURSOR_OFF,
	CURSOR_BLINK,
	CURSOR_UNDERLINE,
	CURSOR_BOTH
};

enum cursorDir {
	CURSOR_ABS,
	CURSOR_REL_LINE,
	CURSOR_REL_OFF,
	CURSOR_REL_BOTH
};

void LCDInit(void);
void LCDWrite(int wrap, int len, char *buffer);
void LCDScroll (int distance);
void LCDMoveCursor(int line, int off, enum cursorDir direction);
void LCDSetCursorType(enum cursorType type);
void LCDClear(void);

#endif
