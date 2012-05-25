#include <uart.h>
#include <ports.h>

#include "serialIO.h"
#include "task.h"
#include "croutine.h"
#include "queue.h"

static xQueueHandle serialRxQueue;
static xQueueHandle serialTxQueue;

void initializeSerialIO(void) {
    // Open the port for the serial connection
    OpenUART2(UART_EN & UART_IDLE_CON & UART_IrDA_DISABLE & UART_MODE_SIMPLEX & UART_UEN_00 & UART_DIS_WAKE & UART_DIS_LOOPBACK & UART_DIS_ABAUD & UART_NO_PAR_8BIT & UART_UXRX_IDLE_ONE & UART_BRGH_SIXTEEN & UART_1STOPBIT,
        UART_INT_TX & UART_IrDA_POL_INV_ZERO & UART_SYNC_BREAK_DISABLED & UART_TX_ENABLE & UART_INT_RX_CHAR & UART_ADR_DETECT_DIS, 25);

    serialRxQueue = xQueueCreate( 4, 1);
    serialTxQueue = xQueueCreate( 4, 1);

    // Turn on the UART interrupts
    SetPriorityIntU2RX(1);
    SetPriorityIntU2TX(1);
    EnableIntU2RX;
    EnableIntU2TX;
}

void sendByteSerial(unsigned char data) {
    xQueueSendToBack(serialTxQueue, &data, portMAX_DELAY);
    IFS1bits.U2TXIF = 1;
}

portBASE_TYPE receiveByteSerial(unsigned char *data, portTickType ticksToWait) {
    return xQueueReceive(serialRxQueue, data, ticksToWait);
}

void __attribute__((__interrupt__, auto_psv)) _U2RXInterrupt( void ) {
    portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS1bits.U2RXIF = 0;

    while(DataRdyUART2()) {
        unsigned char byte = ReadUART2();
        xQueueSendToBackFromISR(serialRxQueue, &byte, &higherPriorityTaskWoken);
    }

    U2STAbits.OERR = 0;
    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}

void __attribute((__interrupt__, auto_psv)) _U2TXInterrupt( void ) {
     portBASE_TYPE higherPriorityTaskWoken = pdFALSE;
    IFS1bits.U2TXIF = 0;

    while(!(U2STAbits.UTXBF)) {
        unsigned char byte;
        if (xQueueReceiveFromISR(serialTxQueue, &byte, &higherPriorityTaskWoken)) {
            WriteUART2(byte);
        } else {
            break;
        }
    }

    if(higherPriorityTaskWoken) {
        taskYIELD();
    }
}
