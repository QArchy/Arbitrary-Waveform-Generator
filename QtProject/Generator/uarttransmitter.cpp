#include "uarttransmitter.h"

bool UartTransmitter::configurePort(uartConfig uartConf) {
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
