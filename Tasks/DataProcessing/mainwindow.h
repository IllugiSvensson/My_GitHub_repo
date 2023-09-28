#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class TownInfo {
public:

    TownInfo() {}
    TownInfo(int y, int ind):year(y), index(ind) {}
    int year;
    int index;

};

class MainWindow : public QMainWindow {
    Q_OBJECT

public:

    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:


    void on_pushButton_clicked();

private:

    Ui::MainWindow *ui;

};
#endif // MAINWINDOW_H
