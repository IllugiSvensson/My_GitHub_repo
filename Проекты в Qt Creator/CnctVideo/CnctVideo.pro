QT = core

CONFIG += c++14 cmdline boost164
NITA_LIBS += -lreg_12
LIBS += \
        -ldl \
        -lboost_system-mt \
        -lboost_thread-mt \
        -lboost_filesystem-mt \
        -lboost_date_time-mt \
        -lTransport
# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        CnctRoute.cpp \
        CnctThread.cpp \
        CnctVideoDiag.cpp \
        ConfigParser.cpp \
        main.cpp

HEADERS += \
    CnctRoute.h \
    CnctRoute.h \
    CnctVideoDiag.h \
    ConfigParser.h \
    Connections.h \
    CnctThread.h

DISTFILES += \
    ../../../../../../soft/etc/K23800/Ship/Connections/cnct_video.xml \
    ../../../../../../soft/etc/K23800/Ship/Connections/cnct_video.xml
