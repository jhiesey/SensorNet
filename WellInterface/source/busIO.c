#include <p24FJ64GB002.h>
#include <uart.h>
#include <ports.h>
#include <stdbool.h>

#include "busIO.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

struct busDataElem {
    unsigned char data;
    unsigned char signal;
};

static xQueueHandle busRxQueue;
static xQueueHandle busTxQueue;

void initializeBusIO() {
    // Open the port for the computer connection
    OpenUART1(UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE & UART_MODE_SIMPLEX & UART_UEN_00 & UART_DIS_WAKE & UART_DIS_LOOPBACK & UART_DIS_ABAUD & UART_NO_PAR_8BIT & UART_UXRX_IDLE_ONE & UART_BRGH_SIXTEEN & UART_1STOPBIT,
        UART_INT_TX & UART_IrDA_POL_INV_ZERO & UART_SYNC_BREAK_DISABLED & UART_TX_ENABLE & UART_INT_RX_CHAR & UART_ADR_DETECT_DIS, 25);

    busRxQueue = xQueueCreate( 4, sizeof (struct busDataElem));
    busTxQueue = xQueueCreate( 4, sizeof (struct busDataElem));

    // Turn on the UART interrupts
    SetPriorityIntU1RX(1);
    SetPriorityIntU1TX(1);
    EnableIntU1RX;
    EnableIntU1TX;
//    IEC4bits.U1ERIE = 1;
}

//void sendByteBus(char data) {
//    xQueueSendToBack(busTxQueue, &data, portMAX_DELAY);
//    IFS0bits.U1TXIF = 1;
//}
//
//portBASE_TYPE receiveByteBus(char *data, portTickType ticksToWait) {
//    return xQueueReceive(busRxQueue, data, ticksToWait);
//}
//
//void __attribute__((__interrupt__, auto_psv)) _U1RXInterrupt( void ) {
//    portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
//    IFS0bits.U1RXIF = 0;
//
//    while(DataRdyUART1()) {
//        char byte = ReadUART1();
//        xQueueSendToBackFromISR(busRxQueue, &byte, &higherPriorityTaskWoken);
//    }
//
//    U1STAbits.OERR = 0;
//    if(higherPriorityTaskWoken) {
//        taskYIELD();
//    }
//}
//
//void __attribute((__interrupt__, auto_psv)) _U1TXInterrupt( void ) {
//     portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
//    IFS0bits.U1TXIF = 0;
//
//    while(!(U1STAbits.UTXBF)) {
//        char byte;
//        if (xQueueReceiveFromISR(busTxQueue, &byte, &higherPriorityTaskWoken)) {
//            WriteUART1(byte);
//        } else {
//            break;
//        }
//    }
//
//    if(higherPriorityTaskWoken) {
//        taskYIELD();
//    }
//}


static void switchTransmitter(BOOL transmit) {
    if(transmit) {
        DisableIntU1RX;

        unsigned char data;
        while(xQueueReceive(busRxQueue, &data, 0) == pdPASS);

        LATBbits.LATB9 = 1;
    } else {
        LATBbits.LATB9 = 0;

        while(DataRdyUART1()) {
            ReadUART1();
        }
        U1STAbits.OERR = 0;

        EnableIntU1RX;
    }
}

void sendByteBus(unsigned char data, bool last) {
    switchTransmitter(TRUE);
    struct busDataElem e;
    e.data = data;
    e.signal = last;
    xQueueSendToBack(busTxQueue, &e, portMAX_DELAY);
    IFS0bits.U1TXIF = 1;
}

void waitForReceive() {
    struct busDataElem e;
    xQueueReceive(busRxQueue, &e, portMAX_DELAY);
    while(!e.signal); // FOR DEBUGGING
}

portBASE_TYPE receiveByteBus(unsigned char *data, portTickType ticksToWait) {
    struct busDataElem e;
    while(1) {
        portBASE_TYPE result = xQueueReceive(busRxQueue, &e, ticksToWait);
        if(result && e.signal)
            continue;
        *data = e.data;
        return result;
    }
}

void __attribute__((__interrupt__, auto_psv)) _U1RXInterrupt( void ) {
    portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS0bits.U1RXIF = 0;
    struct busDataElem e;

    while(DataRdyUART1()) {
        e.data = ReadUART1();
        e.signal = 0;
        xQueueSendToBackFromISR(busRxQueue, &e, &higherPriorityTaskWoken);
    }

    U1STAbits.OERR = 0;
    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}

void __attribute((__interrupt__, auto_psv)) _U1TXInterrupt( void ) {
     portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS0bits.U1TXIF = 0;
    struct busDataElem e;

    if(U1STAbits.UTXISEL0) {
        while(!U1STAbits.TRMT); // REALLY UGLY! Fix this!

        switchTransmitter(FALSE);
        U1STAbits.UTXISEL0 = 0;
        
        e.signal = 1;
        xQueueSendFromISR(busRxQueue, &e, &higherPriorityTaskWoken);
    } else {
        while(!(U1STAbits.UTXBF)) {
            if (xQueueReceiveFromISR(busTxQueue, &e, &higherPriorityTaskWoken)) {
                if(e.signal) {
                    U1STAbits.UTXISEL0 = 1;
                }
                WriteUART1(e.data);
            } else {
                break;
            }
        }
    }

    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}
