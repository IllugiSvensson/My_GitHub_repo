#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QFileDialog>
#include <QFileSystemModel>
#include <QMessageBox>
#include <QRandomGenerator>
#include <algorithm>
#include <QFileInfo>
#include <QDir>
#include <QFile>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow {
    Q_OBJECT

public:

    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:

    void on_Input_Folder_clicked();
    void on_Output_Folder_clicked();
    void on_Move_Pics_clicked();

    void on_Random_clicked();

private:

    Ui::MainWindow *ui;

};

#endif // MAINWINDOW_H
