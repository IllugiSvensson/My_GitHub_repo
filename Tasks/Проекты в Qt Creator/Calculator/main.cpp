#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[]) {

    QApplication a(argc, argv);
    MainWindow w;
    w.resize(270, 330);
    w.show();
    return a.exec();

}
