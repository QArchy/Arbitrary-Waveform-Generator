#include "dacplotter.h"

DACPlotter::DACPlotter()
{

}

qreal DACPlotter::r2rConvertion(quint32 data) {
    qreal sum = 0;
    for (int i = 0; i < 32; i++)  {
        sum += ((data & (((quint32)1) << i)) ? 1.0 : 0.0) * 1.0 / qPow(2, 32 - i);
    }
    qreal analogPlotDot = 3.3 * sum;
    return analogPlotDot;
    Q_UNUSED(analogPlotDot);
    #ifdef DEBUG_MODE
    qDebug() << "DAC byte: " << QString::number(byte, 2);
    #endif
    #ifdef DEBUG_MODE
    qDebug() << "DAC value: " << analogPlotDot;
    #endif
}
