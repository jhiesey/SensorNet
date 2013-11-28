#include "menus.h"

#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#include "controls.h"
#include "endpoint.h"
#include "lcd.h"

#include "freeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "queue.h"

/* There are two kinds of threads here: the main thread, which is driven by
   button presses and does all the real work, and update threads which update
   data in the menus (but not the menu structure itself)
 */

#define MENU_STACK_MAX_DEPTH 4

#define BUTTON_UP 0 // TODO: these are almost certainly wrong
#define BUTTON_DOWN 1
#define BUTTON_BACK 2
#define BUTTON_FORWARD 3
#define FAKE_BUTTON_LOADMAIN 10 // Loads in mau

struct menuStackEntry {
    int address;
    int id;
    int scrollPos; // Position of top line of display in menu
    int cursorPos; // Position of cursor in menu
    char name[16];
};

#define ENUM_BUFFER_SIZE 100

struct menuValueEntry {
    union endpointVal val;
    bool valid;
    struct endpointParams params;
    char enumValueBuf[ENUM_BUFFER_SIZE];
    bool paramsValid;
};

#define MENU_DISPLAY_LINES 3

static int menuStackDepth;
static struct menuStackEntry menuStack[MENU_STACK_MAX_DEPTH];
static struct menuValue currMenu;
static struct menuValueEntry currValues[MENU_DISPLAY_LINES];

// Staging area. Only for use by main menu thread
static struct menuValue tempMenu;
static struct endpointParams tempParams;
static char tempEnumValueBuf[ENUM_BUFFER_SIZE];

static char *blankLine = "                    "; // 20 spaces


static xSemaphoreHandle menuLock;
static xSemaphoreHandle menuCursorLock;

// Macro to get top of stack
static inline struct menuStackEntry *topOfStack() {
    return menuStack + (menuStackDepth - 1);
}

static xQueueHandle buttonsQueue;
//static enum buttonState bState[5];

static void bHandler(enum buttonState *state) {
    int i;
    for(i = 0; i < NUM_BUTTONS; i++) {
        if(state[i] == BUTTON_RELEASED)
            xQueueSend(buttonsQueue, &i, 0); // Ignore extra presses
    }
}

// Just outputs the indicator (one character)
static void paintIndicator(int row) {
    if(row == 0) {
        char c = ' ';
        if(topOfStack()->scrollPos != 0)
            c = '^'; // TODO: make these work!
        LCDWrite(0, 1, &c);
        return;
    }
    if(row == 2) {
        char c = ' ';
        if(currMenu.numItems - topOfStack()->scrollPos > MENU_DISPLAY_LINES)
            c = '?'; // TODO: make these work!
        LCDWrite(0, 1, &c);
        return;
    }
    LCDWrite(0, 1, " ");
}

// BOTH locks must be held!
static void paintValue(int space, int row) {
    char buffer[LCD_WIDTH];
    if(currValues[row].valid) {
        switch(currMenu.entries[row].type) {
            case ENDPOINT_INT16: {
                int nPrinted = sprintf(buffer, "%d", currValues[row].val.int16Val);
                memmove(buffer + (LCD_WIDTH - nPrinted), buffer, nPrinted);
                memset(buffer, ' ', (LCD_WIDTH - nPrinted));
                break;
            }
            case ENDPOINT_INT32: {
                int nPrinted = sprintf(buffer, "%ld", currValues[row].val.int32Val);
                memmove(buffer + (LCD_WIDTH - nPrinted), buffer, nPrinted);
                memset(buffer, ' ', (LCD_WIDTH - nPrinted));
                break;
            }
            case ENDPOINT_ENUM:
                if(!currValues[row].paramsValid) {
                    memset(buffer, ' ', space - 1);
                    buffer[space - 1] = '?';
                } else {
                    char *message;
                    if(currValues[row].val.enumVal > currValues[row].params.typeParams.enumParams.maxVal) {
                        message = "ERROR";
                    } else {
                        message = currValues[row].enumValueBuf + *((int *) (currValues[row].enumValueBuf + currValues[row].params.typeParams.enumParams.valStringOffsetsOffset));
                    }
                    int messageLen = strlen(message);
                    memset(buffer, ' ',space - messageLen);
                    memcpy(buffer + (space - messageLen), message, messageLen);
                }
                break;
            case ENDPOINT_TIME:
                memset(buffer, ' ', space);
                break; // TODO: implement this!
            case ENDPOINT_MENU:
                memset(buffer, ' ', space);
                buffer[space - 1] = '>';
            default:
                memset(buffer, ' ', space);
                break;
        }
        LCDWrite(0, space, buffer);
    } else {
        memset(buffer, ' ', space - 1);
        buffer[space - 1] = '?';
        LCDWrite(0, space, buffer);
    }
}

// Redraws the display and sets the cursor position
static void repaintMenus(void) {
    // Need to lock to protect cursor
    xSemaphoreTake(menuCursorLock, portMAX_DELAY);
    struct menuStackEntry *tos = topOfStack();
    
    // Write first line
    LCDMoveCursor(0, 0, CURSOR_ABS);
    int nameLen = strlen(tos->name);
    LCDWrite(0, nameLen, tos->name);
    LCDWrite(0, 1, ":");
    LCDWrite(0, LCD_WIDTH - nameLen - 1, blankLine);

    int numValid = currMenu.numItems - tos->scrollPos;
    if(numValid > MENU_DISPLAY_LINES)
        numValid = MENU_DISPLAY_LINES;
    int i;
    for(i = 0; i < numValid; i++) {
        LCDMoveCursor(i + 1, 0, CURSOR_ABS);
        paintIndicator(i);
        nameLen = strlen(currMenu.entries[i].name);
        LCDWrite(0, nameLen, currMenu.entries[i].name);

        xSemaphoreTake(menuLock, portMAX_DELAY);
        paintValue(LCD_WIDTH - nameLen - 1, i);
        xSemaphoreGive(menuLock);
    }
    // Write blank lines
    for(i = numValid; i < MENU_DISPLAY_LINES; i++) {
        LCDMoveCursor(i + 1, 0, CURSOR_ABS);
        paintIndicator(i);
        LCDWrite(0, LCD_WIDTH - 1, blankLine);
    }
    LCDMoveCursor(tos->cursorPos - tos->scrollPos + 1, 1, CURSOR_ABS);
    xSemaphoreGive(menuCursorLock);
}

// Called from RPC threads
static void updateDisplayData(int address, int id, enum endpointType type, union endpointVal *value) {
    xSemaphoreTake(menuCursorLock, portMAX_DELAY); // TODO: check lock ordering!
    xSemaphoreTake(menuLock, portMAX_DELAY);
    struct menuStackEntry *tos = topOfStack();
    int numValid = currMenu.numItems - tos->scrollPos;
    if(numValid > MENU_DISPLAY_LINES)
        numValid = MENU_DISPLAY_LINES;
    int i;
    for(i = 0; i < numValid; i++) {
        struct menuEntry *entry = currMenu.entries + i;
        if(entry->address == address && entry->endpoint == id && entry->type == type) {
            currValues[i].val = *value;
            currValues[i].valid = true;

            int nameLen = strlen(currMenu.entries[i].name);
            LCDMoveCursor(i + 1, 1 + nameLen, CURSOR_ABS);
            paintValue(LCD_WIDTH - nameLen - 1, i);
        }
    }

    LCDMoveCursor(tos->cursorPos - tos->scrollPos + 1, 1, CURSOR_ABS);

    xSemaphoreGive(menuLock);
    xSemaphoreGive(menuCursorLock);
}

static void menuMoveUp(void) {
    struct menuStackEntry *tos = topOfStack();
    // Check that we aren't going off the end of the menu
    if(tos->cursorPos == 0)
        return;

    int newCursorPos = tos->cursorPos - 1;
    if(newCursorPos < tos->scrollPos) {
        // Scroll up
        int newScrollPos = tos->scrollPos - 1;
        if(readMenu(tos->address, tos->id, newScrollPos, newScrollPos + 1, &tempMenu)) {
            // Update data
            if(!removeUpdateNotification(currMenu.entries[MENU_DISPLAY_LINES - 1].address, currMenu.entries[MENU_DISPLAY_LINES - 1].endpoint, updateDisplayData, false))
                return;
            if(!addUpdateNotification(tempMenu.entries[0].address, tempMenu.entries[0].endpoint, updateDisplayData, true))
                return;

            xSemaphoreTake(menuLock, portMAX_DELAY);
            memmove(&currMenu.entries[1], &currMenu.entries[0], sizeof(struct menuEntry) * (MENU_DISPLAY_LINES - 1));
            memmove(&currValues[1], &currValues[0], sizeof(struct menuValueEntry) * (MENU_DISPLAY_LINES - 1));
            memcpy(&currMenu.entries[0], &tempMenu.entries[0], sizeof(struct menuEntry));
            currValues[0].valid = false;
            currValues[0].paramsValid = getEndpointParams(currMenu.entries[0].address, currMenu.entries[0].endpoint, &currValues[0].params, currValues[0].enumValueBuf, ENUM_BUFFER_SIZE);
            tos->cursorPos = newCursorPos;
            tos->scrollPos = newScrollPos;
            xSemaphoreGive(menuLock);

            // Scroll screen
            repaintMenus();
        } else {
            return; // Don't change anything. TODO: error?
        }
    } else {
        tos->cursorPos = newCursorPos;
        // Cursor doesn't need to be protected by a lock (yet anyway)
        // Move cursor
        xSemaphoreTake(menuCursorLock, portMAX_DELAY);
        LCDMoveCursor(tos->cursorPos - tos->scrollPos + 1, 1, CURSOR_ABS);
        xSemaphoreGive(menuCursorLock);
    }
}


static void menuMoveDown(void) {
    struct menuStackEntry *tos = topOfStack();
    // Check that we aren't going off the end of the menu
    if(tos->cursorPos >= currMenu.numItems - 1)
        return;

    int newCursorPos = tos->cursorPos + 1;
    if(newCursorPos >= tos->scrollPos + MENU_DISPLAY_LINES) {
        // Scroll down
        int newScrollPos = tos->scrollPos + 1;
        if(readMenu(tos->address, tos->id, newScrollPos, newScrollPos + 1, &tempMenu)) {
            // Update data
            if(!removeUpdateNotification(currMenu.entries[0].address, currMenu.entries[0].endpoint, updateDisplayData, false))
                return;
            if(!addUpdateNotification(tempMenu.entries[0].address, tempMenu.entries[0].endpoint, updateDisplayData, true))
                return;
            
            xSemaphoreTake(menuLock, portMAX_DELAY);
            int last = MENU_DISPLAY_LINES - 1;
            memmove(&currMenu.entries[0], &currMenu.entries[1], sizeof(struct menuEntry) * (MENU_DISPLAY_LINES - 1));
            memmove(&currValues[0], &currValues[1], sizeof(struct menuValueEntry) * (MENU_DISPLAY_LINES - 1));
            memcpy(&currMenu.entries[MENU_DISPLAY_LINES - 1], &tempMenu.entries[0], sizeof(struct menuEntry));
            currValues[last].valid = false;
            currValues[last].paramsValid = getEndpointParams(currMenu.entries[last].address, currMenu.entries[last].endpoint, &currValues[last].params, currValues[last].enumValueBuf, ENUM_BUFFER_SIZE);
            tos->cursorPos = newCursorPos;
            tos->scrollPos = newScrollPos;
            xSemaphoreGive(menuLock);

            // Scroll screen
            repaintMenus();
        } else {
            return; // Don't change anything. TODO: error?
        }
    } else {
        tos->cursorPos = newCursorPos;
        // Cursor doesn't need to be protected by a lock (yet anyway)
        // Move cursor
        xSemaphoreTake(menuCursorLock, portMAX_DELAY);
        LCDMoveCursor(tos->cursorPos - tos->scrollPos + 1, 1, CURSOR_ABS);
        xSemaphoreGive(menuCursorLock);
    }
}

static struct endpointParams tempParams;
static char tempEnumValueBuf[100];

// Also gets parameters
static void addRemoveAllNotifications(bool add) {
    struct menuStackEntry *tos = topOfStack();
    int i; // relative to scroll pos
    int numValid = currMenu.numItems - tos->scrollPos;
    if(numValid > MENU_DISPLAY_LINES)
        numValid = MENU_DISPLAY_LINES;
    for(i = 0; i < numValid; i++) {
        if(add) {
            addUpdateNotification(currMenu.entries[i].address, currMenu.entries[i].endpoint, updateDisplayData, i == numValid - 1);
            bool paramsValid = getEndpointParams(currMenu.entries[i].address, currMenu.entries[i].endpoint, &tempParams, tempEnumValueBuf, sizeof(tempEnumValueBuf));
            if(paramsValid) {
                xSemaphoreTake(menuLock, portMAX_DELAY);
                currValues[i].paramsValid = true;
                memcpy(&currValues[i].params, &tempParams, sizeof(tempParams));
                memcpy(currValues[i].enumValueBuf, &tempEnumValueBuf, ENUM_BUFFER_SIZE);
                xSemaphoreGive(menuLock);
            }
        } else {
            removeUpdateNotification(currMenu.entries[i].address, currMenu.entries[i].endpoint, updateDisplayData, i == numValid - 1);
        }
    }
}

static void menuPop(void) {
    if(menuStackDepth == 1)
        return; // Don't pop the main menu

    struct menuStackEntry *tos = topOfStack();
    struct menuStackEntry *ptos = tos - 1;

    if(!readMenu(ptos->address, ptos->id, ptos->scrollPos, ptos->scrollPos + MENU_DISPLAY_LINES, &tempMenu))
        return;

    // Remove notifications
    addRemoveAllNotifications(false);
    xSemaphoreTake(menuLock, portMAX_DELAY);
    currMenu = tempMenu;
    menuStackDepth--;
    int i;
    for(i = 0; i < MENU_DISPLAY_LINES; i++) {
        currValues[i].valid = false;
        currValues[i].paramsValid = false;
    }
    // TODO: handle menu shrinking
    xSemaphoreGive(menuLock);

    // Add notifications
    addRemoveAllNotifications(true);

    repaintMenus();
}

static bool menuLoad(int address, int endpoint, const char *name) {
    if(!readMenu(address, endpoint, 0, MENU_DISPLAY_LINES, &tempMenu))
        return false;

    xSemaphoreTake(menuLock, portMAX_DELAY);
    currMenu = tempMenu;
    strcpy(menuStack[menuStackDepth].name, name);
    menuStack[menuStackDepth].address = address;
    menuStack[menuStackDepth].id = endpoint;
    menuStack[menuStackDepth].cursorPos = 0;
    menuStack[menuStackDepth].scrollPos = 0;
    menuStackDepth++;
    int i;
    for(i = 0; i < MENU_DISPLAY_LINES; i++) {
        currValues[i].valid = false;
        currValues[i].paramsValid = false;
    }
    xSemaphoreGive(menuLock);

    addRemoveAllNotifications(true);
    repaintMenus();
    return true;
}

static void menuLoadMain(void) {
    menuLoad(0, 0, "Main Menu");
}

static void menuPushEdit(void) {
    // TODO: editing
    if(menuStackDepth + 1 >= MENU_STACK_MAX_DEPTH)
        return;

    struct menuStackEntry *tos = topOfStack();
    struct menuEntry *destEntry = currMenu.entries + (tos->cursorPos - tos->scrollPos);
    if(destEntry->type != ENDPOINT_MENU)
        return; // Only go into submenus

    addRemoveAllNotifications(false);

    menuLoad(destEntry->address, destEntry->endpoint, destEntry->name);
}

static void MenusTaskLoop(void *parameters) {
    LCDInitHardware();

    while(1) {
        // Get button presses
        int button;
        if(!xQueueReceive(buttonsQueue, &button, portMAX_DELAY))
            continue;
        switch(button) {
            case BUTTON_UP:
                menuMoveUp();
                break;
            case BUTTON_DOWN:
                menuMoveDown();
                break;
            case BUTTON_BACK:
                menuPop();
                break;
            case BUTTON_FORWARD:
                menuPushEdit();
                break;
            case FAKE_BUTTON_LOADMAIN:
                menuLoadMain();
                break;
            default:
                break;
        }
    }
}

void startMenus(void) {
    controlsInit();
    LCDInit();

    xTaskCreate(MenusTaskLoop, (signed char *) "menu", configMINIMAL_STACK_SIZE, NULL, 2, NULL);
    buttonsQueue = xQueueCreate(sizeof(int), 2); // Not so big that users get confused
    int init = FAKE_BUTTON_LOADMAIN;
    xQueueSend(buttonsQueue, &init, 0); // Guaranteed to fit

    registerButtonHandler(bHandler);

    menuLock = xSemaphoreCreateMutex();
    menuCursorLock = xSemaphoreCreateMutex();
}
