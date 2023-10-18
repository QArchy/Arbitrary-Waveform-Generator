#ifndef UARTTRANSMITTER_H
#define UARTTRANSMITTER_H

#include "uartconfigdialog.h"
#include <QBitArray>
#include <QSerialPort>
#include <QSerialportInfo>

class UartTransmitter: public QSerialPort {
    Q_OBJECT

public:
    bool configurePort(uartConfig uartConf);
};

#endif // UARTTRANSMITTER_H
