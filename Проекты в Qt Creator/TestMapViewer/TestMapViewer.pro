QT       += core gui widgets

CONFIG += c++11
NITA_LIBS += -lreg_12

linux* {
LIBS += -ldl \
    -lboost_filesystem-mt \
    -lboost_system-mt \
}

SOURCES += \
    $$PWD/src/FileSystem.cpp \
    $$PWD/src/main.cpp \
    $$PWD/src/TestMapViewer.cpp


HEADERS += \
    $$PWD/include/FileSystem.h \
    $$PWD/include/TestMapViewer.h \
    $$PWD/include/XmlTree.h


RESOURCES += \
    Icons.qrc

DISTFILES += \
    PV+PDC.xml \
    description.txt
