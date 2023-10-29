QT += core gui
QT += serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport # printsupport is needed for QCustomPlot

CONFIG += c++17
CONFIG(release, debug|release):DEFINES += QT_NO_DEBUG_OUTPUT

SOURCES += \
    dds.cpp \
    main.cpp \
    mainwindow.cpp \
    serialmanager.cpp \
    uartconfigdialog.cpp

HEADERS += \
    dds.h \
    mainwindow.h \
    serialmanager.h \
    uartconfigdialog.h

FORMS += \
    mainwindow.ui \
    uartconfigdialog.ui

RESOURCES = app.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
