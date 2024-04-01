#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QGraphicsScene>
#include <QGraphicsView>
#include "blockscheme.h"

class MainWindow : public QGraphicsView
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    QGraphicsView *view;
    QGraphicsScene *scence;
    BlockScheme *bscheme;
    BlockScheme *bscheme1;

protected:
private slots:
    void reDraw();
    void randomColorF();
    void randomColorAll();

};
#endif // MAINWINDOW_H
