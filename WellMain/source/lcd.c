#include <string.h>

#include "lcd.h"
#include "FreeRTOS.h"
#include "queue.h"
#include "task.h"
#include <p24FJ256GB206.h>

enum lcdMessageType {
	LCD_MESSAGE_CLEAR,
	LCD_MESSAGE_CURSOR_TYPE,
	LCD_MESSAGE_MOVE_CURSOR,
	LCD_MESSAGE_SCROLL,
	LCD_MESSAGE_WRITE
};

#define MAX_QUEUE_ELEM_SIZE 10
#define LCD_WIDTH 20
#define LCD_HEIGHT 4

struct lcdMessage {
	enum lcdMessageType type;
	int param1;
	int param2;
	union {
		int param3;
		char data[MAX_QUEUE_ELEM_SIZE];
	} d;
};

static int currLine;
static int currOff;
static char lcdBuffer[LCD_HEIGHT][LCD_WIDTH];
static enum cursorType currCursorType;

static xQueueHandle lcdQueue;

// Writes using the "8 bit" protocol.  Doesn't wait for busy.
static void LCDParWriteInit(char data) {
	LATE &= ~0x7F;
	LATE |= data & 0xF;
	portNOP();
	LATEbits.LATE6 = 1;
	portNOP();
	LATEbits.LATE6 = 0;
}

static char LCDParRead(int RS) {
	char result;

	LATE &= ~0x7F;
	LATE |= (RS ? 0x10 : 0) | 0x20;
	TRISE |= 0xF;
	LATEbits.LATE6 = 1;
	portNOP();
	result = (PORTE & 0xF) << 4;
	LATEbits.LATE6 = 0;
	portNOP();
	portNOP();
	portNOP();
	LATEbits.LATE6 = 1;
	result |= PORTE & 0xF;
	LATEbits.LATE6 = 0;
	portNOP();
	portNOP();
	TRISE &= ~0xF;

	return result;
}

static void LCDWaitBusy (void) {
	while(LCDParRead(0) & 0x80);
}

// Waits for display to be ready before writing
static void LCDParWrite(int RS, char data) {
	LCDWaitBusy();

	LATE &= ~0x7F;
	LATE |= (RS ? 0x10 : 0) | ((data >> 4) & 0xF);
	portNOP();
	LATEbits.LATE6 = 1;
	portNOP();
	LATEbits.LATE6 = 0;
	LATE &= ~0xF;
	LATE |= data & 0xF;
	portNOP();
	portNOP();
	portNOP();
	LATEbits.LATE6 = 1;
	portNOP();
	LATEbits.LATE6 = 0;
}

static int LCDComputeAddress(int line, int off) {
	if(line & 1)
		off += 0x40;
	if(line & 2)
		off += 0x14;
	return off;
}

// Adjusts buffer, but doesn't change display (or move the cursor)
static void LCDScrollBuffer(int distance) {
	// Move the current data around
	int sourceLine = distance > 0 ? distance : 0;
	int destLine = distance > 0 ? 0 : distance;
	int copyLines = distance > 0 ? LCD_HEIGHT - distance : LCD_HEIGHT + distance;
	memmove (lcdBuffer[destLine], lcdBuffer[sourceLine], copyLines * LCD_WIDTH);
	
	// Clear the rest
	memset (lcdBuffer, ' ', destLine * LCD_WIDTH);
	memset (lcdBuffer[destLine + copyLines], ' ', (LCD_HEIGHT - destLine - copyLines) * LCD_WIDTH);

	currLine -= distance;
}

// Sync the cursor in the display to the current line and offset
static void LCDCursorSync(void) {
	if (currLine >= LCD_HEIGHT)
		currLine = LCD_HEIGHT - 1;
	else if (currLine < 0)
		currLine = 0;
	
	if (currOff >= LCD_WIDTH)
		currOff = LCD_WIDTH - 1;
	LCDParWrite(0, 0x80 + LCDComputeAddress (currLine, currOff));	
}

static void LCDRefresh(void) {
	// Switch off cursor
	enum cursorType type = currCursorType;
	LCDParWrite(0, 6);

	LCDParWrite (0, 2);
	int i, j;
	for (i = 0; i < LCD_HEIGHT; i++) {
		LCDParWrite(0, 0x80 + LCDComputeAddress (i, 0));
		for (j = 0; j < LCD_WIDTH; j++) {
			LCDParWrite (1, lcdBuffer[i][j] & 0x7F);
		}
	}

	// Reset cursor
	LCDCursorSync();
	LCDParWrite(0, 0xC | (type & 3));
}

static void LCDWriteInternal (int wrap, int len, char *buffer) {
	int refresh = 0;
	int i;
	for (i = 0; i < len; i++) {
		lcdBuffer[currLine][currOff] = buffer[i];
		if (!refresh) {
			LCDParWrite(1, buffer[i] & 0x7F);
		}		
		if (++currOff >= LCD_WIDTH) {
			currOff = 0;
			if (++currLine >= LCD_HEIGHT) {
				LCDScrollBuffer(1);
				refresh = 1;
			} 
			if (!refresh) {
				LCDCursorSync();
			}
		}
	}
	if (refresh) {
		LCDRefresh();
	}
}

static void LCDMoveCursorInternal(int line, int off, enum cursorDir direction) {
	switch (direction) {
		case CURSOR_ABS:
			currOff = off;
			currLine = line;
			break;
		case CURSOR_REL_LINE:
			currOff = off;
			currLine += line;
			break;
		case CURSOR_REL_OFF:
			currOff += off;
			currLine = line;
			break;
		case CURSOR_REL_BOTH:
			currOff += off;
			currLine += line;
			break;
	}
	if (currOff >= LCD_WIDTH)
		currOff = LCD_WIDTH - 1;

	if (currLine >= LCD_HEIGHT) {
		LCDScrollBuffer (currLine - LCD_HEIGHT + 1);
		LCDRefresh();
	} else if (currLine < 0) {
		LCDScrollBuffer (currLine);
		LCDRefresh();
	} else {
		LCDCursorSync();
	}
}

static void LCDTaskLoop(void *parameters) {
	// TODO: check these tick values don't round down to zero
	vTaskDelay(20 / portTICK_RATE_MS);
	LCDParWriteInit(0x3);
	vTaskDelay(5 / portTICK_RATE_MS);
	LCDParWriteInit(0x3);
	vTaskDelay(1);
	LCDParWriteInit(0x3);
	LCDWaitBusy();
	LCDParWriteInit(0x2);
	LCDParWrite(0, 0x28);
	LCDParWrite(0, 0x8);
	LCDParWrite(0, 1);
	LCDParWrite(0, 6);
	LCDParWrite(0, 0xC);

	memset (lcdBuffer, ' ', sizeof (lcdBuffer));

	while (1) {
		static struct lcdMessage message;
		xQueueReceive (lcdQueue, &message, portMAX_DELAY);
		switch (message.type) {
			case LCD_MESSAGE_CLEAR:
				LCDParWrite(0, 1);
				currLine = 0;
				currOff = 0;
				memset (lcdBuffer, ' ', sizeof (lcdBuffer));
				break;
			case LCD_MESSAGE_CURSOR_TYPE:
				currCursorType = (enum cursorType) message.param1;
				LCDParWrite(0, 0xC | (message.param1 & 3));
				break;
			case LCD_MESSAGE_MOVE_CURSOR:
				LCDMoveCursorInternal (message.param1, message.param2, (enum cursorDir) message.d.param3);
				break;
			case LCD_MESSAGE_SCROLL:
				LCDScrollBuffer (message.param1);
				LCDRefresh();
				break;
			case LCD_MESSAGE_WRITE:
				LCDWriteInternal (message.param1, message.param2, message.d.data); 
				break;
		}
	}
}

void LCDInit(void) {
	lcdQueue = xQueueCreate (4, sizeof (struct lcdMessage));

	xTaskCreate(LCDTaskLoop, (signed char *) "lcd", configMINIMAL_STACK_SIZE, NULL, 2, NULL);
}

void LCDScroll (int distance) {
	struct lcdMessage message;
	message.type = LCD_MESSAGE_SCROLL;
	message.param1 = distance;
	xQueueSendToBack (lcdQueue, &message, portMAX_DELAY);
}

void LCDMoveCursor(int line, int off, enum cursorDir direction) {
	struct lcdMessage message;
	message.type = LCD_MESSAGE_MOVE_CURSOR;
	message.param1 = line;
	message.param2 = off;
	message.d.param3 = (int) direction;
	xQueueSendToBack (lcdQueue, &message, portMAX_DELAY);
}

void LCDSetCursorType(enum cursorType type) {
	struct lcdMessage message;
	message.type = LCD_MESSAGE_CURSOR_TYPE;
	message.param1 = (int) type;
	xQueueSendToBack (lcdQueue, &message, portMAX_DELAY);
}

void LCDClear(void) {
	struct lcdMessage message;
	message.type = LCD_MESSAGE_CLEAR;
	xQueueSendToBack (lcdQueue, &message, portMAX_DELAY);
}

void LCDWrite (int wrap, int len, char *buffer) {
	while (len > 0) {
		struct lcdMessage message;
		message.type = LCD_MESSAGE_WRITE;
		
		int partLen = len;
		if (partLen > MAX_QUEUE_ELEM_SIZE)
			partLen = MAX_QUEUE_ELEM_SIZE;

		message.param1 = wrap;
		message.param2 = partLen;
		memcpy (message.d.data, buffer, partLen);
		xQueueSendToBack (lcdQueue, &message, portMAX_DELAY);

		buffer += partLen;
		len -= partLen;
	}
}

static int memcspn (char *buffer, int len, char *find, int findLen) {
	int i, j;
	for (i = 0; i < len; i++) {
		for (j = 0; j < findLen; j++) {
			if (buffer[i] == find[j])
				return i;
		}
	}
	return len;
}

int __attribute__((__section__(".libc.write")))
write(int handle, void *buffer, unsigned int len) {
	if (handle == 1 || handle == 2) {
		int origLen = len;
		char *cBuffer = buffer;
		while (len > 0) {
			int printableLen = memcspn (cBuffer, len, "\n\r\0", 3);
			if (printableLen == 0) {
				switch (cBuffer[0]) {
					case '\n':
						LCDMoveCursor (1, 0, CURSOR_REL_BOTH);
						break;
					case '\r':
						LCDMoveCursor (0, 0, CURSOR_REL_LINE);
						break;
					default:
						break;
				}	
				cBuffer++;
				len--;
			} else {
				LCDWrite (1, printableLen, cBuffer);
				len -= printableLen;
				cBuffer += printableLen;
			}
		}	
		return origLen;
	}
	return -1;
}
