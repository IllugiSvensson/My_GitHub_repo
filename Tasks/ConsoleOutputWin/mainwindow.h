#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QProcess>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
   Q_OBJECT

public:
   explicit MainWindow(QWidget *parent = nullptr);
   ~MainWindow();

private slots:
   void on_pushButton_clicked();
   void procCMD();
private:
   Ui::MainWindow *ui;
   QProcess *proc;
};

#endif // MAINWINDOW_H
