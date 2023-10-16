#ifndef UARTCONFIGDIALOG_H
#define UARTCONFIGDIALOG_H

#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDialog>

struct uartConfig {
        QString portName = "COM4";
        QIODevice::OpenModeFlag openMode = QIODevice::OpenModeFlag::ReadWrite;
        quint32 baudRate = 115200;
        QSerialPort::DataBits dataBits = QSerialPort::DataBits::Data8;
        QSerialPort::Parity parity = QSerialPort::Parity::NoParity;
        QSerialPort::StopBits stopBits = QSerialPort::StopBits::OneStop;
        QSerialPort::FlowControl flowControl = QSerialPort::FlowControl::NoFlowControl;
        quint64 readBufferSize = 1024;
};

namespace Ui {
class UartConfigDialog;
}

class UartConfigDialog : public QDialog
{
    Q_OBJECT

public:
    explicit UartConfigDialog(QWidget *parent = nullptr);
    ~UartConfigDialog();
    void updatePortNames();

private slots:
    void on_buttonBox_accepted();

    void on_buttonBox_rejected();

private:
    Ui::UartConfigDialog *ui;

signals:
    void sig_uartConfig(uartConfig uartConf);
};

#endif // UARTCONFIGDIALOG_H
