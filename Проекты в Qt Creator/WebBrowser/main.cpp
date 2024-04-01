#include "mainwindow.h"

#include <QApplication>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QTranslator translatot;
    translatot.load(":/browser_" + QLocale::system().name());
    a.installTranslator(&translatot);
    MainWindow w;
    w.setWindowTitle(QApplication::tr("My simple browser"));
    w.setWindowState(Qt::WindowState::WindowMaximized);
    w.show();
    return a.exec();
}
