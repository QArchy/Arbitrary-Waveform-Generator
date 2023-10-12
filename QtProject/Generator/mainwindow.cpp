#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent): QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);
    uart = new UartTransmitter();
    dds = new Dds();

    // --------------- Signal -> Slot connections ---------------
    QObject::connect (uart, SIGNAL(readyRead()), this, SLOT(uartReadyRead()));

    // Frequency slots
    QObject::connect (ui->Freq_1Hz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_10Hz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_100Hz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_1KHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_10KHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_100KHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_1MHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));
    QObject::connect (ui->Freq_10MHz_SpinBox, SIGNAL(textChanged(const QString&)), this, SLOT(frequencyTextChanged(const QString&)));

    // Wafeform slots
    QObject::connect (ui->SinRadioBtn, SIGNAL(clicked(bool)), this, SLOT(waveformCheckChanged(bool)));
    QObject::connect (ui->NoiseRadioBtn, SIGNAL(clicked(bool)), this, SLOT(waveformCheckChanged(bool)));
    QObject::connect (ui->TriangleRadioBtn, SIGNAL(clicked(bool)), this, SLOT(waveformCheckChanged(bool)));
    QObject::connect (ui->RectangleRadioBtn, SIGNAL(clicked(bool)), this, SLOT(waveformCheckChanged(bool)));
    QObject::connect (ui->SawRadioBtn, SIGNAL(clicked(bool)), this, SLOT(waveformCheckChanged(bool)));
    QObject::connect (ui->RampRadioBtn, SIGNAL(clicked(bool)), this, SLOT(waveformCheckChanged(bool)));
}

MainWindow::~MainWindow() {
    delete uart;
    delete dds;
    delete ui;
}

void MainWindow::frequencyTextChanged(const QString& str) {
    QString newFrequencyStr =
        ui->Freq_10MHz_SpinBox->text() + ui->Freq_1MHz_SpinBox->text() +
        ui->Freq_100KHz_SpinBox->text() + ui->Freq_10KHz_SpinBox->text() + ui->Freq_1KHz_SpinBox->text() +
        ui->Freq_100Hz_SpinBox->text() + ui->Freq_10Hz_SpinBox->text() + ui->Freq_1Hz_SpinBox->text();
    qreal newFrequencyDouble = newFrequencyStr.toDouble();
    ui->outputFreqLineEdit->setText(QString::number(newFrequencyDouble));
}

void MainWindow::waveformCheckChanged(bool checked) {
    if (ui->SinRadioBtn->isChecked()) {
        dds->wave = WaveForm::Sin;
    } else if (ui->NoiseRadioBtn->isChecked()) {
        dds->wave = WaveForm::Noise;
    } else if (ui->TriangleRadioBtn->isChecked()) {
        dds->wave = WaveForm::Triangle;
    } else if (ui->RectangleRadioBtn->isChecked()) {
        dds->wave = WaveForm::Rect;
    } else if (ui->SawRadioBtn->isChecked()) {
        dds->wave = WaveForm::Saw;
    } else if (ui->RampRadioBtn->isChecked()) {
        dds->wave = WaveForm::Ramp;
    }
}

/*enum ReadState {
    SOM = 1,
    SIGNAL_DATA_32_24 = 2,
    SIGNAL_DATA_23_16 = 3,
    SIGNAL_DATA_15_8 = 4,
    SIGNAL_DATA_7_0 = 5,
    EOM = 6,
};*/

//void MainWindow::uartReadyRead() {
//    static ReadState readState = SOM;

//    QByteArray arr = uart->readAll();
//    int receivedBytesCount = arr.size() / 8;

//    for (int i = 0; i < receivedBytesCount; i++) {
//        quint32 newByte = 0;
//        switch(readState) {
//            case ReadState::SOM: arr[i] == 's' ? readState = SIGNAL_DATA_32_24 : readState = SOM;
//            case ReadState::SIGNAL_DATA_32_24:
//                newByte &= (0x00000000 | (((quint32) arr[i]) << 24));
//                ui->outputText->appendPlainText(QString('s'));
//                ui->outputText->appendPlainText(QString(QChar(arr[i])));
//                readState = SIGNAL_DATA_23_16;
//            case ReadState::SIGNAL_DATA_23_16:
//                newByte &= (0xFF000000 | (((quint32) arr[i]) << 16));
//                ui->outputText->appendPlainText(QString(QChar(arr[i])));
//                readState = SIGNAL_DATA_15_8;
//            case ReadState::SIGNAL_DATA_15_8:
//                newByte &= (0xFFFF0000 | (((quint32) arr[i]) << 8));
//                ui->outputText->appendPlainText(QString(QChar(arr[i])));
//                readState = SIGNAL_DATA_7_0;
//            case ReadState::SIGNAL_DATA_7_0:
//                newByte &= (0xFFFFFF00 | ((quint32) arr[i]));
//                ui->outputText->appendPlainText(QString(QChar(arr[i])));
//                ui->outputText->appendPlainText(QString('e'));
//                ui->outputText->appendPlainText(QString('\n'));
//                readState = EOM;
//            case ReadState::EOM: arr[i] == 'e' ? readState = SOM : readState = SOM;
//        }
//        uartData->append(newByte);
//    }

//    if (uartData->size() == 1024) {
//        ui->customPlot->graph(0)->setData(*uartData, *uartData);
//        ui->customPlot->graph(0)->rescaleAxes();
//    }

//    this->update();
//}
