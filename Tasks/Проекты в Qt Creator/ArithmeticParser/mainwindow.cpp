#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "parsetext.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow) {

        ui->setupUi(this);

}

MainWindow::~MainWindow() {

    delete ui;

}

void MainWindow::on_plainTextEdit_textChanged() {

    QString txt = ui->plainTextEdit->toPlainText();
    qint32 pos = 0;

        while(1) {

            qint32 fnd = txt.indexOf("#@", pos); //IndexOf вернет индекс первого вхождения

                if (fnd == -1) return;

            pos = fnd + 1;
            int r = txt.indexOf("=", fnd);
            int space = txt.indexOf(" ", fnd);

                if ((r < space || space == -1) && r != -1) { //На случай 5+7 =

                    ParseText parseText(txt.mid(fnd + 2, r - fnd - 1)); //5+7=
                    double answer = parseText.parse();

                        txt.insert(r + 1, QString::number(answer)); //Пример1: #@5+7=12
                        txt.remove(fnd, 2);                         //Пример1: 5+7=12
                        ui->plainTextEdit->setPlainText(txt);

                }

        }

}
