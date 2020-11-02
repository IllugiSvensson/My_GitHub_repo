#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include "ui_WidgetBin.h"
//Подключим созданную в Дизайнере форму

class Widget : public QWidget
{
   Q_OBJECT

public:
   Widget(QWidget *parent = 0);
   ~Widget();
private:
   Ui_Form *uiForm;
private slots:
    void openXMLForm(); //Слот для открытия другой формы
};

#endif // WIDGET_H
