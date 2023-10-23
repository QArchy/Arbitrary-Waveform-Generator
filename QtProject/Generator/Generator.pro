QT += core gui
QT += serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport # printsupport is needed for QCustomPlot

CONFIG += c++17

SOURCES += \
    dacplotter.cpp \
    dds.cpp \
    main.cpp \
    mainwindow.cpp \
    qcustomplot.cpp \
    serialmanager.cpp \
    uartconfigdialog.cpp

HEADERS += \
    dacplotter.h \
    dds.h \
    debug.h \
    mainwindow.h \
    qcustomplot.h \
    serialmanager.h \
    tests.h \
    uartconfigdialog.h

FORMS += \
    mainwindow.ui \
    uartconfigdialog.ui

RESOURCES = app.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
