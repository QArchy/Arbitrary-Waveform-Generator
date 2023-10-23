#ifndef TESTS_H
#define TESTS_H

#include "qglobal.h"
#include <QVector>
#include <QDebug>
#include <QtMath>

void testAmplitudeScale() {
    const quint64 MAX_VALUE = 256;

    QVector<quint8> sin_vec(MAX_VALUE);
    for (quint64 i = 0; i < MAX_VALUE; i++) {
        sin_vec[i] = qRound(qSin(i * (2 * 3.14) / 256) * 127) + 128;
        //qDebug() << "sin[i]: " << sin_vec[i];
    }

    quint8 amplitude = 1; // unsigned (amplitude coef)

    for (quint64 i = 0; i < MAX_VALUE - 1; i++) {
        for (quint64 j = 0; j < MAX_VALUE; j++) {
            quint16 data_out = sin_vec[j] * amplitude; // new amplitude
            qDebug() << "Data: " << sin_vec[j] << " Amplitude: " << amplitude;
            qDebug() << "data_out 16-bit: " << data_out;
            qDebug() << "data_out msb 8-bit: " << (data_out >> 8);
            qDebug() << "data_out/sin_vec" << (data_out >> 8) * 1.0 / sin_vec[j] << '\n';
        }
        amplitude++;
    }

    // qDebug() << "Unsigned data_out " << ~(data_out - 1) << '\n';
    // qDebug() << "Unsigned data_out " << QString::number(data_out & 0x7FFF, 2).right(16) << '\n';
}

void testAmplitude() {
    quint16 test = 255;
    qDebug() << "Unsigned test " << QString::number(test, 2).right(16) << '\n';
    qDebug() << "Unsigned test / (2^8) " << QString::number(test / 256, 2).right(16) << '\n';
    qDebug() << "Unsigned test >> 8 " << QString::number(test >> 8, 2).right(16) << '\n';
}

void testBitOperationsUart() {
    QVector<char> byteArray = {'a', 'b', 'c', 'd'};
    quint32 newByte = 0;
    for (int i = 0; i < 4; i++) {
        qDebug() << "Array[" << QString::number(i, 10) << "]: " << byteArray[i];
        quint32 byteArray_i_32 = ((quint32) byteArray[i]);
        qDebug() << "Array[" << QString::number(i, 10) << "] in quint32 format: " << QString::number(((quint32) byteArray_i_32), 2);
        quint32 byteArray_i_32_shift = (((quint32) byteArray[i]) << 24);
        qDebug() << "Array[" << QString::number(i, 10) << "] in shift 24: " << QString::number(((quint32) byteArray_i_32_shift), 2);
        quint32 byteArray_i_32_shift_or = 0x00000000 | (((quint32) byteArray[i]) << 24);
        qDebug() << "Array[" << QString::number(i, 10) << "] in or: " << QString::number(((quint32) byteArray_i_32_shift_or), 2);
        newByte |= 0x00000000 | (((quint32) byteArray[i]) << 24);
        qDebug() << "Array[" << QString::number(i, 10) << "] in newByte: " << QString::number(((quint32) newByte), 2);
    }
}

void testUartCommand() {
    quint8 wave = 0b00000001;
    quint32 adder = 0b00000001000000010000000100000001;
    QByteArray arr;
    arr.append((char)wave);

    char tmp[4] = {*((char*)(&adder) + 3), *((char*)(&adder) + 2), *((char*)(&adder) + 1), *((char*)(&adder) + 3)};

    arr.append(tmp, 4);
    for (quint8 i = 0; i < arr.size(); i++) {
        qDebug() << QString::number((quint8)arr[i], 2).right(32);
    }
}

#endif // TESTS_H
