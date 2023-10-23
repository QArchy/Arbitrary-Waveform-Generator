#include "serialmanager.h"

SerialManager::SerialManager() {
    port = new QSerialPort();
    // connect uart signals
}

bool SerialManager::configurePort(uartConfig uartConf) {
    if (port->isOpen())
        port->close();
    port->setPortName(uartConf.portName);
    port->setBaudRate(uartConf.baudRate);
    port->setDataBits(uartConf.dataBits);
    port->setParity(uartConf.parity);
    port->setStopBits(uartConf.stopBits);
    port->setFlowControl(uartConf.flowControl);
    port->setReadBufferSize(uartConf.readBufferSize);
    return port->open(uartConf.openMode);
}

quint64 SerialManager::write(QByteArray data) {
    return port->write(data);
}

SerialManager::~SerialManager() {
    delete port;
}

void slot_uartReadyRead(QByteArray arr) {
    static ReadState readState = SOM;

#ifdef DEBUG_MODE
    for (int i = 0; i < arr.size(); i++) {
        qDebug() << "Received array[" << QString::number(i) << "]: " << QString::number(arr[i], 2).right(8);
    }
#endif

    quint32 newByte = 0;
    for (int i = 0; i < arr.size(); i++) {
        if (readState == ReadState::SOM) {
            arr[i] == 's' ? readState = SIGNAL_DATA_32_24 : readState = SOM;
        } else if (readState == ReadState::SIGNAL_DATA_32_24) {
            readState = SIGNAL_DATA_23_16;
            newByte |= (0xFF000000 & (((quint32) arr[i]) << 24));
#ifdef DEBUG_MODE
            qDebug() << "newByte[31:24]: " << QString::number(newByte, 2);
#endif
        } else if (readState == ReadState::SIGNAL_DATA_23_16) {
            readState = SIGNAL_DATA_15_8;
            newByte |= (0x00FF0000 & (((quint32) arr[i]) << 16));
#ifdef DEBUG_MODE
            qDebug() << "newByte[23:16]: " << QString::number(newByte, 2);
#endif
        } else if (readState == ReadState::SIGNAL_DATA_15_8) {
            readState = SIGNAL_DATA_7_0;
            newByte |= (0x0000FF00 & (((quint32) arr[i]) << 8));
#ifdef DEBUG_MODE
            qDebug() << "newByte[15:8]: " << QString::number(newByte, 2);
#endif
        } else if (readState == ReadState::SIGNAL_DATA_7_0) {
            readState = EOM;
            newByte |= (0x000000FF & ((quint32) arr[i]));
#ifdef DEBUG_MODE
            qDebug() << "newByte[7:0]: " << QString::number(newByte, 2);
#endif
            //ui->outputText->appendPlainText("s" + QString::number(newByte, 2) + "e");
            //plotNewData(newByte);
            newByte = 0;
        } else if (readState == ReadState::EOM) {
            arr[i] == 'e' ? readState = SOM : readState = SOM;
        } // else {}
    }
}
