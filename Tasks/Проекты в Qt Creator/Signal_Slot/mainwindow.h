#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPushButton>
#include <QSharedPointer>
#include <QKeyEvent>
#include <QMouseEvent>
#include "keypressevent.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MyClass {
private:

    int value;

public:

    MyClass(int v): value(v) {}

    int getValue() const { return value; }

};

class MainWindow : public QMainWindow {
    Q_OBJECT

public:

    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    void SendSignal();

protected:

    void mousePressEvent(QMouseEvent* event) override;
    void mouseReleaseEvent(QMouseEvent* event) override;
    void keyReleaseEvent(QKeyEvent* event) override;

private:

    Ui::MainWindow *ui;
    QPushButton *nextPicButton, *prevPicButton;
    int curPicture;
    void setPicture();
    int positionX;
    const QStringList picturelist = {":/img/img1.png", ":/img/img2.png", ":/img/img3.png"};
    QSharedPointer<KeyPressEvent>replaceMouseButtons;

signals:

    void doIt(QString);
    void switchNextPicture();
    void switchPrevPicture();

public slots:

    void slot(QString);

private slots:

    void nextPicture();
    void prevPicture();
    void on_pushButton_clicked();

};
#endif // MAINWINDOW_H

