#include "computerProtocol.h"

#include "task.h"

#include "computerIO.h"


static void computerTaskLoop(void *parameters) {

    initializeComputerIO();

    while(1) {
        char data;
        receiveByteComputer(&data, portMAX_DELAY);
        sendByteComputer(data);
    }
}

void startComputerReceiver() {
    xTaskCreate(computerTaskLoop, (signed char *) "cmp", configMINIMAL_STACK_SIZE + 200, NULL, 1, NULL);
}
