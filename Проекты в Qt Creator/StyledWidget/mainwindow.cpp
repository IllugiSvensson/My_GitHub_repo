#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QApplication>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow) {
    
    ui->setupUi(this);
    qApp->setStyleSheet("QPushButton { font: bold 14 px; background-color: red; }"
                        "QMainWindow {background-color: magenta }");
    //Задать стиль всему виджету                  
    b1 = new QPushButton("A", this);
    b1->setStyleSheet("QPushButton { font: bold 14 px; background-color: blue; }");
    //Задать стиль конкретной кнопке(игнорируя общий стиль)
    b2 = new QPushButton("B", this);
    b3 = new QPushButton("C", this);

    grid = new QGridLayout(this);
    grid->setMargin(100);
    grid->addWidget(b1, 0, 0, 1, 2, Qt::AlignCenter);
    grid->addWidget(b2, 1, 0);
    grid->addWidget(b3, 1, 1);

    layout = new QBoxLayout(QBoxLayout::LeftToRight);
    layout2 = new QBoxLayout(QBoxLayout::TopToBottom);
    layout->addWidget(b1);
    layout->addSpacing(40);
    layout->addLayout(layout2);
    layout2->addWidget(b2);
    layout2->addWidget(b3);
    wgt = new QWidget(this); //Устанавливаем компоновщик
    wgt->setLayout(grid); //layout
    setCentralWidget(wgt);

}

MainWindow::~MainWindow() {

    delete ui;

}

