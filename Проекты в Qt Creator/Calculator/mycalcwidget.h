#ifndef MYCALCWIDGET_H
#define MYCALCWIDGET_H

#include <QWidget>
#include <QLCDNumber>
#include <QStack>
#include <QPushButton>

class MyCalcWidget : public QWidget
{
    Q_OBJECT

public:
    explicit MyCalcWidget(QWidget *parent = nullptr);
    void calculate();
    QString strDisplay;

private:
    QLCDNumber *plcd;
    QStack<QString> stack;
    QPushButton *createButton(const QString &name);

signals:
    void signalResult(QString str);

public slots:
    void slotButtonClicked();

};

#endif // MYCALCWIDGET_H
