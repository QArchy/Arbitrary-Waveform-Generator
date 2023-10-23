#ifndef DACPLOTTER_H
#define DACPLOTTER_H

#include <QObject>
//#include "qobject.h"
//#include "qobjectdefs.h"
#include <QtMath>

class DACPlotter: public QObject {
    Q_OBJECT

private:
    qreal r2rConvertion(quint32 data);

public:
    DACPlotter();
};

#endif // DACPLOTTER_H
