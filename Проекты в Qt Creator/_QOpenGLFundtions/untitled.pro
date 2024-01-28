#-------------------------------------------------
#
# Project created by QtCreator 2019-06-23T15:47:34
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = OpenGLTest
TEMPLATE = app

DEFINES += QT_DEPRECATED_WARNINGS

CONFIG += c++11

SOURCES += \
       main.cpp \
       mainwindow.cpp

HEADERS += \
       mainwindow.h

LIBS +=-lOpenGL32   #Подключаем библиотеку (для ВИН10)

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
