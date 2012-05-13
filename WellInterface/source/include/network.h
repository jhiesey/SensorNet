#ifndef NETWORK_H
#define NETWORK_H

#include "FreeRTOS.h"


enum dataSource {
    SOURCE_BUS,
    SOURCE_COMPUTER
};

void networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, char sourceAddr);

#endif
