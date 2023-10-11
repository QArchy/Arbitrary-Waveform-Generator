#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent): QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);
    uart = new UartTransmitter();
    uart->configurePort("COM4");

    uartData = new QVector<qreal>(1024);

    ui->customPlot->addGraph();
    ui->customPlot->graph(0)->setPen(QPen(Qt::blue));
    ui->customPlot->graph(0)->setBrush(QBrush(QColor(0, 0, 255, 20)));

    QVector<qreal> x;
    for (int i = 0; i < 1024; i++) {
        x.append(i);
    }

    QVector<qreal> y;
    for (int i = 0; i < 1024; i++) {
        y.append(qSin(x[i]));
    }

    ui->customPlot->graph(0)->setData(x, y);
    ui->customPlot->graph(0)->rescaleAxes();

    // Signal -> Slot connections
    QObject::connect (uart, SIGNAL(readyRead()), this, SLOT(uartReadyRead()));
}

MainWindow::~MainWindow() {
    delete uart;
    delete ui;
}

enum ReadState {
    SOM = 1,
    SIGNAL_DATA_32_24 = 2,
    SIGNAL_DATA_23_16 = 3,
    SIGNAL_DATA_15_8 = 4,
    SIGNAL_DATA_7_0 = 5,
    EOM = 6,
};

void MainWindow::uartReadyRead() {
    static ReadState readState = SOM;

    QByteArray arr = uart->readAll();
    int receivedBytesCount = arr.size() / 8;

    for (int i = 0; i < receivedBytesCount; i++) {
        quint32 newByte = 0;
        switch(readState) {
            case ReadState::SOM: arr[i] == 's' ? readState = SIGNAL_DATA_32_24 : readState = SOM;
            case ReadState::SIGNAL_DATA_32_24:
                newByte &= (0x00000000 | (((quint32) arr[i]) << 24));
                ui->outputText->setText(ui->outputText->text() + 's');
                ui->outputText->setText(ui->outputText->text() + (char)newByte);
                readState = SIGNAL_DATA_23_16;
            case ReadState::SIGNAL_DATA_23_16:
                newByte &= (0xFF000000 | (((quint32) arr[i]) << 16));
                ui->outputText->setText(ui->outputText->text() + (char)newByte);
                readState = SIGNAL_DATA_15_8;
            case ReadState::SIGNAL_DATA_15_8:
                newByte &= (0xFFFF0000 | (((quint32) arr[i]) << 8));
                ui->outputText->setText(ui->outputText->text() + (char)newByte);
                readState = SIGNAL_DATA_7_0;
            case ReadState::SIGNAL_DATA_7_0:
                newByte &= (0xFFFFFF00 | ((quint32) arr[i]));
                ui->outputText->setText(ui->outputText->text() + (char)newByte);
                ui->outputText->setText(ui->outputText->text() + 'e');
                ui->outputText->setText(ui->outputText->text() + '\n');
                readState = EOM;
            case ReadState::EOM: arr[i] == 'e' ? readState = SOM : readState = SOM;
        }
        uartData->append(newByte);
    }

    if (uartData->size() == 1024) {
        ui->customPlot->graph(0)->setData(*uartData, *uartData);
        ui->customPlot->graph(0)->rescaleAxes();
    }
}
