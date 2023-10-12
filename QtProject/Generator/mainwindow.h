#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#define DEBUG_MODE

#ifdef DEBUG_MODE
#include <QDebug>
#endif

#include <QMainWindow>
#include <QVector>
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
    qreal fpgaFrequency = 200000000;
    qreal outputFrequency = 1;
    bool outputAmplitudeIncrease = 1;
    qreal outputAmplitude = 1;
    qreal adder = 21.47484;
    quint32 adderInt = 21;
    WaveForm wave = WaveForm::Sin;
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
    UartTransmitter* uart;
    Dds* dds;

private slots:
    //void uartReadyRead();
    void frequencyTextChanged(const QString& str);
    void amplitudeTextChanged(const QString& str);
    void waveformCheckChanged(bool checked);
    void on_AmplIncrDecrComboBox_currentIndexChanged(int index);
    void on_fpgaFreqLineEdit_textChanged(const QString &arg1);
};
#endif // MAINWINDOW_H
