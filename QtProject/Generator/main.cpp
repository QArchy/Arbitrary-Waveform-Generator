//#define TEST
#ifdef TEST
#include "qglobal.h"
#include "tests.h"
#else
#include "mainwindow.h"
#include <QApplication>
#endif

int main(int argc, char *argv[])
{
#ifndef TEST
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
#else
    Q_UNUSED(argc);
    Q_UNUSED(argv);
    //testAmplitudeScale();
    //testAmplitude();
    //testBitOperationsUart();
    testUartCommand();
#endif
}
