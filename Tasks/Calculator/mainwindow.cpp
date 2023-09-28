#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    calculator = new MyCalcWidget(this);
    calculator->setGeometry(0, 5, 270, 320);
}

MainWindow::~MainWindow()
{
}

