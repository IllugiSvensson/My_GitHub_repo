QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = demo
TEMPLATE = app
FORMS += WidgetBin.ui
DEFINES += QT_DEPRECATED_WARNINGS
CONFIG += c++11 uitools
SOURCES += \
       main.cpp \
       widget.cpp

HEADERS += \
       widget.h

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
