#include "include/TestMapViewer.h"

#include <QApplication>

#include <CCTV/Widget/VirtualKeyboard/VirtualKeyboard.h>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    if (!strcmp(argv[argc - 1], "--touch_mode"))
        cctv::cln::VirtualKeyboard vk;
    TestMapViewer w;
    w.resize(1280, 720);
    w.show();
    return a.exec();
}
