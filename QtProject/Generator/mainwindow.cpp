#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent): QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);
    uart = new UartTransmitter();
    uart->configurePort("COM4");

    // Signal -> Slot connections
    QObject::connect (uart, SIGNAL(readyRead()), this, SLOT(uartReadyRead()));
}

MainWindow::~MainWindow() {
    delete uart;
    delete ui;
}

enum ReadState {
    READY_READ = 0,
    SOM = 1,
    SIGNAL_32_24 = 2,
    SIGNAL_23_16 = 3,
    SIGNAL_15_8 = 4,
    SIGNAL_7_0 = 5,
    EOM = 6,
};

void MainWindow::uartReadyRead() {
    static ReadState readState = READY_READ;

    QByteArray arr = uart->readAll();
    int receivedBytesCount = arr.size() / 8;

    quint32* dots = new quint32[arr.size() / 8];
    for (int i = 0; i < receivedBytesCount; i++)
    for (int i = 0; i < arr.size(); i++) {
        quint32 newByte = ((quint32) arr[i]);
        dots[i] = 0;
        dots[i] |= (newByte << 8);
    }

    delete dots;
}
