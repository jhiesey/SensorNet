#include <p24FJ64GB002.h>
#include <uart.h>
#include <ports.h>

#include "busIO.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

struct busDataElem {
    char data;
    char signal;
};

static xQueueHandle busRxQueue;
static xQueueHandle busTxQueue;
static BOOL transmitting = 0;

void initializeBusIO() {
    // Open the port for the computer connection
    OpenUART1(UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE & UART_MODE_SIMPLEX & UART_UEN_00 & UART_DIS_WAKE & UART_DIS_LOOPBACK & UART_DIS_ABAUD & UART_NO_PAR_8BIT & UART_UXRX_IDLE_ONE & UART_BRGH_SIXTEEN & UART_1STOPBIT,
        UART_INT_TX & UART_IrDA_POL_INV_ZERO & UART_SYNC_BREAK_DISABLED & UART_TX_ENABLE & UART_INT_RX_CHAR & UART_ADR_DETECT_DIS, 25);

    busRxQueue = xQueueCreate( 4, sizeof (struct busDataElem));
    busTxQueue = xQueueCreate( 4, sizeof (struct busDataElem));

    // Turn on the UART interrupts
    EnableIntU1RX;
    EnableIntU1TX;
    IEC4bits.U1ERIE = 1;
}

static void switchTransmitter(BOOL transmit) {
    if(transmit) {
        DisableIntU1RX;
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

void switchDirection(BOOL transmit) {
    if(transmit == transmitting)
        return;

    if(transmit) {
        switchTransmitter(TRUE);
        struct busDataElem e;
        while(xQueueReceive(busRxQueue, &e, 0) == pdPASS);
    } else {
        struct busDataElem e;
        e.signal = 1;
        xQueueSendToBack(busTxQueue, &e, portMAX_DELAY);
        IFS0bits.U1TXIF = 1;
        xQueueReceive(busRxQueue, &e, portMAX_DELAY);
    }
}

void sendByteBus(char data) {
    switchDirection(TRUE);
    struct busDataElem e;
    e.data = data;
    e.signal = 0;
    xQueueSendToBack(busTxQueue, &data, portMAX_DELAY);
    IFS0bits.U1TXIF = 1;
}

char receiveByteBus(portTickType ticksToWait) {
    switchDirection(FALSE);
    struct busDataElem e;
    xQueueReceive(busRxQueue, &e, ticksToWait);
    return e.data;
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

    if(U1STAbits.UTXISEL0 && U1STAbits.TRMT == 1) {
        switchTransmitter(FALSE);
        U1STAbits.UTXISEL0 = 0;
        e.signal = 1;
        xQueueSendToBackFromISR(busRxQueue, &e, &higherPriorityTaskWoken);
    } else {
        while(!(U1STAbits.UTXBF)) {
            if (xQueueReceiveFromISR(busTxQueue, &e, &higherPriorityTaskWoken)) {
                if(e.signal == 1) {
                    U1STAbits.UTXISEL0 = 1;
                    break;
                } else {
                    WriteUART1(e.data);
                }
            } else {
                break;
            }
        }
    }

    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}
