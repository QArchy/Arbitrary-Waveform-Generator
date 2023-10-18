#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#define DEBUG_MODE

#ifdef DEBUG_MODE
#include <QDebug>
#endif

#include <QMainWindow>
#include <QVector>
#include <QtMath>
#include "uartconfigdialog.h"
#include "uarttransmitter.h"
#include "dds.h"

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
    // ui windows
    Ui::MainWindow *ui;
    UartConfigDialog *uartConfigDialog;
    // class instances
    UartTransmitter* uart;
    DDS* dds;
    // private functions
    void sendCommand();
    void plotNewData(quint32 byte);

private slots:
    void slot_uartReadyRead();
    void slot_frequencyTextChanged(const QString& str);
    void slot_amplitudeTextChanged(const QString& str);
    void slot_waveformCheckChanged(bool checked);
    void slot_showUartConfig(bool checked = false);
    void slot_uartGetConfig(uartConfig uartConf);
};
#endif // MAINWINDOW_H
