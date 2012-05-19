#ifndef NETWORK_H
#define NETWORK_H

#include "FreeRTOS.h"


enum dataSource {
    SOURCE_BUS,
    SOURCE_WIRELESS
};

bool networkHandleMessage(short len, short (*getByteCallback)(), char csum, enum dataSource source, unsigned long long sourceAddr);

#endif
