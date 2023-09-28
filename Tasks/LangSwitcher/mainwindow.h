#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTranslator>
#include <QLabel>
#include <QPushButton>

class MainWindow : public QMainWindow {
   Q_OBJECT

public:

   MainWindow(QWidget *parent = 0);
   ~MainWindow();

private:

   QLabel *l0;
   QLabel *l1;
   QLabel *l2;
   QLabel *l3;
   QPushButton *rusB, *frB, *jaB, *enB;
   QTranslator translater; // Нужно именно здесь, иначе динамическое
                           // переключение не будет работать
private:

   void switchLanguage(QString language);

private slots:

   void clickSwitch();

};

#endif // MAINWINDOW_H
