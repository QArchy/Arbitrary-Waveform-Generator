#ifndef UARTTRANSMITTER_H
#define UARTTRANSMITTER_H

#include <QBitArray>
#include <QSerialport>
#include <QSerialportInfo>

class UartTransmitter: public QSerialPort {
    Q_OBJECT

public:
    bool configurePort(
        QString portName = "COM4",
        QIODevice::OpenModeFlag openMode = QIODevice::OpenModeFlag::ReadWrite,
        quint32 baudRate = 115200,
        QSerialPort::DataBits dataBits = QSerialPort::DataBits::Data8,
        QSerialPort::Parity parity = QSerialPort::Parity::NoParity,
        QSerialPort::StopBits stopBits = QSerialPort::StopBits::OneStop,
        QSerialPort::FlowControl flowControl = QSerialPort::FlowControl::NoFlowControl,
        quint64 readBufferSize = 1024) {
        if (this->isOpen())
            this->close();
        this->setPortName(portName);
        this->setBaudRate(baudRate);
        this->setDataBits(dataBits);
        this->setParity(parity);
        this->setStopBits(stopBits);
        this->setFlowControl(flowControl);
        this->setReadBufferSize(readBufferSize);
        return this->open(openMode);
    }
};

#endif // UARTTRANSMITTER_H
