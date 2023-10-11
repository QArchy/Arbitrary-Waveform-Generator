#ifndef UARTTRANSMITTER_H
#define UARTTRANSMITTER_H

#include <QBitArray>
#include <QSerialport>

class UartTransmitter: public QSerialPort {
    Q_OBJECT

public:
    void configurePort(QString portName) {
        this->setPortName(portName);
        this->setBaudRate(115200);
        this->setDataBits(QSerialPort::Data8);
        this->setParity(QSerialPort::NoParity);
        this->setStopBits(QSerialPort::OneStop);
        this->setFlowControl(QSerialPort::NoFlowControl);
    }
};

#endif // UARTTRANSMITTER_H
