#ifndef UARTTRANSMITTER_H
#define UARTTRANSMITTER_H

#include "uartconfigdialog.h"
#include <QBitArray>
#include <QSerialPort>
#include <QSerialportInfo>

class UartTransmitter: public QSerialPort {
    Q_OBJECT

public:
    bool configurePort(uartConfig uartConf) {
        if (this->isOpen())
            this->close();
        this->setPortName(uartConf.portName);
        this->setBaudRate(uartConf.baudRate);
        this->setDataBits(uartConf.dataBits);
        this->setParity(uartConf.parity);
        this->setStopBits(uartConf.stopBits);
        this->setFlowControl(uartConf.flowControl);
        this->setReadBufferSize(uartConf.readBufferSize);
        return this->open(uartConf.openMode);
    }
};

#endif // UARTTRANSMITTER_H
