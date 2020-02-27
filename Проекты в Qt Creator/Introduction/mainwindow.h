#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtMath>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_calcButton_clicked();

    void on_AngleButton_clicked();

    void on_fixed_string_clicked();

    void on_simple_text_clicked();

    void on_transform_clicked();

private:
    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H
