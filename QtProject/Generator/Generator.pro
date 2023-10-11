QT += core gui
QT += serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport # printsupport is needed for QCustomPlot

CONFIG += c++17

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    qcustomplot/qcustomplot.cpp \
    uarttransmitter.cpp

HEADERS += \
    mainwindow.h \
    qcustomplot/qcustomplot.h \
    uarttransmitter.h

FORMS += \
    mainwindow.ui

RESOURCES = app.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
