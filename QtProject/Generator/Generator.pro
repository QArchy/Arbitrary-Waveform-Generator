QT += core gui
QT += serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport # printsupport is needed for QCustomPlot

CONFIG += c++17

SOURCES += \
    dds.cpp \
    main.cpp \
    mainwindow.cpp \
    qcustomplot.cpp \
    uartconfigdialog.cpp \
    uarttransmitter.cpp

HEADERS += \
    dds.h \
    mainwindow.h \
    qcustomplot.h \
    uartconfigdialog.h \
    uarttransmitter.h

FORMS += \
    mainwindow.ui \
    uartconfigdialog.ui

RESOURCES = app.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
