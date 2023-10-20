#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QStack>
#include <QFile>
#include <QTextStream>
#include <QMessageBox>
#include <QFileDialog>
#include <QDir>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

struct undo_redo
{
    QString value;
    qint32 index;
    bool direct;
};

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_textEdit_textChanged();
    void on_undo_button_clicked();
    void on_redo_button_clicked();
    void on_open_button_clicked();
    void on_save_button_clicked();
    void on_about_button_clicked();

private:
    Ui::MainWindow *ui;
    undo_redo U_R;
    QStack<undo_redo> undo;
    QStack<undo_redo> redo;
    qint32 previous_len;
    bool latch;
    QString previous_txt;

};
#endif // MAINWINDOW_H
