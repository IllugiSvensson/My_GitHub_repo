#include "mycalcwidget.h"
#include <QGridLayout>

MyCalcWidget::MyCalcWidget(QWidget *parent) : QWidget(parent)
{
    plcd = new QLCDNumber(12, this);
    plcd->setSegmentStyle(QLCDNumber::Flat);
    plcd->setMinimumSize(150, 50);

    QChar abutton[4][4] = {
        {'7', '8', '9' , '/'},
        {'4', '5', '6' , '*'},
        {'1', '2', '3' , '-'},
        {'0', '.', '=' , '+'}
    };

    QGridLayout *topLayout = new QGridLayout(this);
    topLayout->addWidget(plcd, 0, 0, 1, 4);
    topLayout->addWidget(createButton("CE"), 1, 3);

        for(int i = 0; i < 4; i++) {
            for(int j = 0; j < 4; j++) {

                topLayout->addWidget(createButton(abutton[i][j]), i + 2, j);
            }
        }
    setLayout(topLayout);
}

QPushButton *MyCalcWidget::createButton(const QString &name) {

    QPushButton *b = new QPushButton(name, this);
    b->setMinimumSize(40, 40);
    connect(b, SIGNAL(clicked()), this, SLOT(slotButtonClicked()));
    return b;

}

void MyCalcWidget::calculate() {

    double operand2 = stack.pop().toDouble();
    QString operation = stack.pop();
    double operand1 = stack.pop().toDouble();
    double result = 0;

        if (operation == "+") {

            result = operand1 + operand2;

        } else if (operation == "-") {

            result = operand1 - operand2;

        } else if (operation == "*") {

            result = operand1 * operand2;

        } else if(operation == "/") {

            result = operand1 / operand2;

        }

        plcd->display(result);
        emit signalResult(QString::number(result));

}

void MyCalcWidget::slotButtonClicked() {

    QString str = ((QPushButton*)sender())->text();

        if(str == "CE") {

            stack.clear();
            strDisplay = "";
            plcd->display("0");
            return;

        }

    if (str.contains(QRegExp("[0-9]"))) {

        strDisplay += str;
        plcd->display(strDisplay.toDouble());

    } else if (str == ".") {

        strDisplay +=str;
        plcd->display(strDisplay.toDouble());

    } else {

        if (stack.count() >= 2) {

            stack.push(QString().setNum(plcd->value()));
            calculate();
            stack.clear();
            stack.push(QString().setNum(plcd->value()));

            if(str != "=") {

                stack.push(str);

            }

        } else {

            stack.push(QString().setNum(plcd->value()));
            stack.push(str);
            strDisplay = "";
            plcd->display("0");

        }

    }

}
