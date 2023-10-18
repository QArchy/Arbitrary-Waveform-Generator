#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent): QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);

    // ------------------------------ Varivable allocations ------------------------------
    uart = new UartTransmitter();
    dds = new DDS();
    uartConfigDialog = new UartConfigDialog();

    // ------------------------------ Signal -> Slot connections ------------------------------
    // window uartConfig
    QObject::connect(ui->actionComPortConfig, SIGNAL(triggered(bool)), this, SLOT(slot_showUartConfig(bool)));
    QObject::connect(uartConfigDialog, SIGNAL(sig_uartConfig(uartConfig)), this, SLOT(slot_uartGetConfig(uartConfig)));

    // uart signals
    QObject::connect (uart, SIGNAL(readyRead()), this, SLOT(slot_uartReadyRead()));

    // Frequency slots
    QObject::connect (ui->Freq_1Hz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_10Hz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_100Hz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_1KHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_10KHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_100KHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_1MHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_10MHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_frequencyTextChanged(const QString&)));

    // Amplitude slots
    QObject::connect (ui->VPercentSpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(slot_amplitudeTextChanged(const QString&)));

    // Wafeform slots
    QObject::connect (ui->SinRadioBtn, SIGNAL(clicked(bool)), this, SLOT(slot_waveformCheckChanged(bool)));
    QObject::connect (ui->NoiseRadioBtn, SIGNAL(clicked(bool)), this, SLOT(slot_waveformCheckChanged(bool)));
    QObject::connect (ui->TriangleRadioBtn, SIGNAL(clicked(bool)), this, SLOT(slot_waveformCheckChanged(bool)));
    QObject::connect (ui->RectangleRadioBtn, SIGNAL(clicked(bool)), this, SLOT(slot_waveformCheckChanged(bool)));
    QObject::connect (ui->SawRadioBtn, SIGNAL(clicked(bool)), this, SLOT(slot_waveformCheckChanged(bool)));
    QObject::connect (ui->RampRadioBtn, SIGNAL(clicked(bool)), this, SLOT(slot_waveformCheckChanged(bool)));
}

MainWindow::~MainWindow() {
    delete uart;
    delete dds;
    delete ui;
}

void MainWindow::sendCommand() {
    uart->write(dds->formUartCommand());
}

void MainWindow::plotNewData(quint32 byte) {
    qreal sum = 0;
    for (int i = 0; i < 32; i++)  {
        sum += ((byte & (((quint32)1) << i)) ? 1.0 : 0.0) * 1.0 / qPow(2, 32 - i);
    }
    qreal analogPlotDot = 3.3 * sum;
    Q_UNUSED(analogPlotDot);
#ifdef DEBUG_MODE
    qDebug() << "DAC byte: " << QString::number(byte, 2);
#endif
#ifdef DEBUG_MODE
    qDebug() << "DAC value: " << analogPlotDot;
#endif
}

void MainWindow::slot_frequencyTextChanged(const QString& str) {
    Q_UNUSED(str);
    QString newFrequencyStr =
        ui->Freq_10MHz_SpinBox->text() + ui->Freq_1MHz_SpinBox->text() +
        ui->Freq_100KHz_SpinBox->text() + ui->Freq_10KHz_SpinBox->text() + ui->Freq_1KHz_SpinBox->text() +
        ui->Freq_100Hz_SpinBox->text() + ui->Freq_10Hz_SpinBox->text() + ui->Freq_1Hz_SpinBox->text();
    dds->setAdder(newFrequencyStr.toDouble());
    ui->adderLineEdit->setText(QString::number(dds->getAdder()));
    ui->adderIntLineEdit->setText(QString::number(dds->getAdderInt()));
    sendCommand();
}

void MainWindow::slot_amplitudeTextChanged(const QString& str) {
    Q_UNUSED(str);
    dds->setOutputAmplitude(ui->VPercentSpinBox->text().toDouble());
    sendCommand();
#ifdef DEBUG_MODE
    qDebug() << "Output amplitude: " << dds->getOutputAmplitude();
#endif
}

void MainWindow::slot_waveformCheckChanged(bool checked) {
    Q_UNUSED(checked);
    if (ui->SinRadioBtn->isChecked()) {
        dds->setWave(WaveForm::Sin);
    } else if (ui->NoiseRadioBtn->isChecked()) {
        dds->setWave(WaveForm::Noise);
    } else if (ui->TriangleRadioBtn->isChecked()) {
        dds->setWave(WaveForm::Triangle);
    } else if (ui->RectangleRadioBtn->isChecked()) {
        dds->setWave(WaveForm::Rect);
    } else if (ui->SawRadioBtn->isChecked()) {
        dds->setWave(WaveForm::Saw);
    } else if (ui->RampRadioBtn->isChecked()) {
        dds->setWave(WaveForm::Ramp);
    }
    sendCommand();
#ifdef DEBUG_MODE
    qDebug() << "Dds wave: " << dds->getWave();
#endif
}

void MainWindow::slot_showUartConfig(bool checked) {
    Q_UNUSED(checked);
    uartConfigDialog->updatePortNames();
    uartConfigDialog->open();
}

void MainWindow::slot_uartGetConfig(uartConfig uartConf) {
    bool portOpened = uart->configurePort(uartConf);
    Q_UNUSED(portOpened);
#ifdef DEBUG_MODE
    qDebug() << "Port opened: " << portOpened;
#endif
}

void MainWindow::slot_uartReadyRead() {
    static ReadState readState = SOM;

    QByteArray arr = uart->readAll();

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
            ui->outputText->appendPlainText("s" + QString::number(newByte, 2) + "e");
            plotNewData(newByte);
            newByte = 0;
        } else if (readState == ReadState::EOM) {
            arr[i] == 'e' ? readState = SOM : readState = SOM;
        } // else {}
    }
}
