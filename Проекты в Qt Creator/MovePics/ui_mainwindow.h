/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 5.15.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QListView>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTreeView>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QPushButton *Input_Folder;
    QPushButton *Output_Folder;
    QPushButton *Move_Pics;
    QLineEdit *InputPath;
    QLineEdit *OutputPath;
    QListView *Pictures;
    QTreeView *Folders;
    QLabel *TitlePic;
    QMenuBar *menubar;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(550, 609);
        MainWindow->setTabShape(QTabWidget::Triangular);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        Input_Folder = new QPushButton(centralwidget);
        Input_Folder->setObjectName(QString::fromUtf8("Input_Folder"));
        Input_Folder->setGeometry(QRect(10, 10, 151, 61));
        Output_Folder = new QPushButton(centralwidget);
        Output_Folder->setObjectName(QString::fromUtf8("Output_Folder"));
        Output_Folder->setGeometry(QRect(380, 10, 151, 61));
        Move_Pics = new QPushButton(centralwidget);
        Move_Pics->setObjectName(QString::fromUtf8("Move_Pics"));
        Move_Pics->setGeometry(QRect(180, 470, 171, 61));
        Move_Pics->setToolTipDuration(-1);
        InputPath = new QLineEdit(centralwidget);
        InputPath->setObjectName(QString::fromUtf8("InputPath"));
        InputPath->setEnabled(false);
        InputPath->setGeometry(QRect(10, 80, 201, 21));
        OutputPath = new QLineEdit(centralwidget);
        OutputPath->setObjectName(QString::fromUtf8("OutputPath"));
        OutputPath->setEnabled(false);
        OutputPath->setGeometry(QRect(220, 80, 311, 21));
        Pictures = new QListView(centralwidget);
        Pictures->setObjectName(QString::fromUtf8("Pictures"));
        Pictures->setEnabled(true);
        Pictures->setGeometry(QRect(10, 100, 201, 361));
        Folders = new QTreeView(centralwidget);
        Folders->setObjectName(QString::fromUtf8("Folders"));
        Folders->setEnabled(true);
        Folders->setGeometry(QRect(220, 100, 311, 361));
        TitlePic = new QLabel(centralwidget);
        TitlePic->setObjectName(QString::fromUtf8("TitlePic"));
        TitlePic->setGeometry(QRect(170, 10, 190, 60));
        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName(QString::fromUtf8("menubar"));
        menubar->setGeometry(QRect(0, 0, 550, 20));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName(QString::fromUtf8("statusbar"));
        MainWindow->setStatusBar(statusbar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "MainWindow", nullptr));
#if QT_CONFIG(tooltip)
        Input_Folder->setToolTip(QCoreApplication::translate("MainWindow", "<html><head/><body><p>\320\236\321\202\320\272\321\200\321\213\321\202\321\214 \320\277\320\260\320\277\320\272\321\203, \320\262 \320\272\320\276\321\202\320\276\321\200\320\276\320\271 </p><p>\320\273\320\265\320\266\320\260\321\202 \321\204\320\276\321\202\320\276\320\263\321\200\320\260\321\204\320\270\320\270</p></body></html>", nullptr));
#endif // QT_CONFIG(tooltip)
        Input_Folder->setText(QCoreApplication::translate("MainWindow", "\320\236\321\202\320\272\321\200\321\213\321\202\321\214 \320\277\320\260\320\277\320\272\321\203, \320\262 \n"
"\320\272\320\276\321\202\320\276\321\200\320\276\320\271 \320\273\320\265\320\266\320\260\321\202 \n"
"\321\204\320\276\321\202\320\276\320\263\321\200\320\260\321\204\320\270\320\270", nullptr));
#if QT_CONFIG(tooltip)
        Output_Folder->setToolTip(QCoreApplication::translate("MainWindow", "<html><head/><body><p>\320\236\321\202\320\272\321\200\321\213\321\202\321\214 \320\277\320\260\320\277\320\272\321\203, \320\262 \320\272\320\276\321\202\320\276\321\200\320\276\320\271 \320\273\320\265\320\266\320\260\321\202 </p><p>\321\206\320\265\320\273\320\265\320\262\321\213\320\265 \320\277\320\260\320\277\320\272\320\270</p></body></html>", nullptr));
#endif // QT_CONFIG(tooltip)
        Output_Folder->setText(QCoreApplication::translate("MainWindow", "\320\236\321\202\320\272\321\200\321\213\321\202\321\214 \320\277\320\260\320\277\320\272\321\203, \320\262 \n"
"\320\272\320\276\321\202\320\276\321\200\320\276\320\271 \320\273\320\265\320\266\320\260\321\202 \n"
"\321\206\320\265\320\273\320\265\320\262\321\213\320\265 \320\277\320\260\320\277\320\272\320\270", nullptr));
#if QT_CONFIG(tooltip)
        Move_Pics->setToolTip(QCoreApplication::translate("MainWindow", "\320\240\320\260\321\201\320\277\321\200\320\265\320\264\320\265\320\273\320\270\321\202\321\214 \321\204\320\276\321\202\320\276\320\263\321\200\320\260\321\204\320\270\320\270 \320\277\320\276 \320\277\320\260\320\277\320\272\320\260\320\274", nullptr));
#endif // QT_CONFIG(tooltip)
        Move_Pics->setText(QCoreApplication::translate("MainWindow", "\320\240\320\260\321\201\320\277\321\200\320\265\320\264\320\265\320\273\320\270\321\202\321\214", nullptr));
        TitlePic->setText(QCoreApplication::translate("MainWindow", "TextLabel", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
