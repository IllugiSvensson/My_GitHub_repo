#include "mainwindow.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QGraphicsView(parent)
{
    scence = new QGraphicsScene(this);
    setScene(scence);
    scence->addRect(-300,0,300,300);
    scence->addText("Текст через Graphics View Framework");
    scence->addEllipse(-50, -50, 100, 100);
    srand(clock());
    bscheme = new BlockScheme(this);
    scence->addItem(bscheme);
    bscheme1 = new BlockScheme(this);
    scence->addItem(bscheme1);
    scence->addText("Hello");

    connect(bscheme, SIGNAL(reDraw()), this, SLOT(reDraw()));
    connect(bscheme1, SIGNAL(reDraw()), this, SLOT(reDraw()));
    connect(bscheme, SIGNAL(dblClick()), this, SLOT(randomColorF()));
    connect(bscheme1, SIGNAL(dblClick()), this, SLOT(randomColorAll()));

}

MainWindow::~MainWindow()
{
}

void MainWindow::reDraw()
{
    scence->update();
    update();
}

void MainWindow::randomColorF()
{
    bscheme->setBrush(QBrush(QColor(rand() %256, rand() %256, rand() %256)));
}

void MainWindow::randomColorAll()
{
    bscheme->setBrush(QBrush(QColor(rand() %256, rand() %256, rand() %256)));
    bscheme1->setBrush(QBrush(QColor(rand() %256, rand() %256, rand() %256)));
}
