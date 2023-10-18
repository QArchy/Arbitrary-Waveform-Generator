#include "dds.h"

quint32 DDS::getFpgaFrequency() const {
    return fpgaFrequency;
}

void DDS::setFpgaFrequency(quint32 newFpgaFrequency) {
    fpgaFrequency = newFpgaFrequency;
}

quint32 DDS::getOutputAmplitude() const {
    return outputAmplitude;
}

void DDS::setOutputAmplitude(quint32 amplitudePercent) {
    qreal Vmax = 3.3;
    quint32 n = 256;
    qreal step = Vmax / n;
    quint32 currentNumberOfSteps = qRound(amplitudePercent / 100 * Vmax / step);
    outputAmplitude = currentNumberOfSteps;
}

qreal DDS::getAdder() const {
    return adder;
}

void DDS::setAdder(qreal newFrequency) {
    adder = newFrequency / fpgaFrequency * 4294967296 /* 2^32 */;
    adderInt = qRound(adder);
}

quint32 DDS::getAdderInt() const {
    return adderInt;
}

quint8 DDS::getWave() const {
    return wave;
}

void DDS::setWave(quint8 newWave) {
    wave = newWave;
}

QByteArray DDS::formUartCommand() {
    QByteArray command;
    command.append('s');

    command.append((char)(wave));
#ifdef DEBUG_MODE
    qDebug() << "Transmitting Output wave: " << (quint8)command[1];
#endif
    command.append((char*)(&adderInt), 4);
#ifdef DEBUG_MODE
    qDebug() << "Transmitting Adder: " << (quint8)command[2] << ' ' << (quint8)command[3] << ' ' << (quint8)command[4] << ' ' << (quint8)command[5] << ' ';
#endif
    command.append((char*)(&outputAmplitude), 4);
#ifdef DEBUG_MODE
    qDebug() << "Transmitting Output amplitude: " << (quint8)command[6] << ' ' << (quint8)command[7] << ' ' << (quint8)command[8] << ' ' << (quint8)command[9] << ' ';
#endif

    command.append('e');
    return command;
}

DDS::DDS() {
    fpgaFrequency = 200000000;
    outputAmplitude = 0;
    adder = 21.47484;
    adderInt = 21;
    wave = WaveForm::Sin;
}
