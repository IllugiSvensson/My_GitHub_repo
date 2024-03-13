#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMdiArea>
#include <QGridLayout>
#include <QTextEdit>
#include <QPushButton>
#include <QMdiSubWindow>
#include <QEvent>
#include <QToolBar>
#include <QLabel>
#include <QProgressBar>
#include <QStatusBar>
#include <QMenu>
#include <QMenuBar>
#include <QApplication>
#include "ruscontext.h"
#include <QMessageBox>
#include "finddialog.h"
#include <QSharedPointer>
#include <QPrintDialog>
#include <QPrinter>

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow() override;
private:
    QMdiArea *mdiArea;
    QTextEdit *curEdit;
    QLabel *xlab, *ylab;
    QProgressBar* progrBar;
    QSharedPointer<finddialog>findDialog;

private slots:
    void printToField();
    void findText();
    void setNewPosition(int, int, int);

protected:
    void closeEvent(QCloseEvent* event) override;
};
#endif // MAINWINDOW_H
