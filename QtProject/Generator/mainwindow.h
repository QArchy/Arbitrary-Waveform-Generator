#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#define DEBUG_MODE

#ifdef DEBUG_MODE
#include <QDebug>
#endif

#include <QMainWindow>
#include <QVector>
#include "uartconfigdialog.h"
#include "uarttransmitter.h"

enum WaveForm {
    Sin = 0,
    Noise = 1,
    Triangle = 2,
    Rect = 3,
    Saw = 4,
    Ramp = 5
};

struct Dds {
    quint32 fpgaFrequency = 200000000;
    quint32 outputAmplitude = 0;
    qreal adder = 21.47484;
    quint32 adderInt = 21;
    quint8 wave = WaveForm::Sin;
};

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    Ui::MainWindow *ui;
    UartConfigDialog *uartConfigDialog;
    UartTransmitter* uart;
    Dds* dds;
    void sendCommand();

private slots:
    //void uartReadyRead();
    void frequencyTextChanged(const QString& str);
    void amplitudeTextChanged(const QString& str);
    void waveformCheckChanged(bool checked);
    void showUartConfig(bool checked = false);
    void uartGetConfig(uartConfig uartConf);
};
#endif // MAINWINDOW_H
