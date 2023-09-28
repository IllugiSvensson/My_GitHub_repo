#include "mainwindow.h"
#include<QApplication>

#define RELEASE(p) if (p) {delete p; p = NULL;}

MainWindow::MainWindow(QWidget *parent)
   : QMainWindow(parent) {

   l0 = new QLabel(this);
   bool rez = (l0 != NULL);
   l1 = new QLabel(this);
   rez &= (l1 != NULL);
   l2 = new QLabel(this);
   rez &= (l2 != NULL);
   l3 = new QLabel(this);
   rez &= (l3 != NULL);
   rusB = new QPushButton(this);
   rez &= (rusB  != NULL);
   frB = new QPushButton(this);
   rez &= (frB  != NULL);
   jaB = new QPushButton(this);
   rez &= (jaB  != NULL);
   enB = new QPushButton(this);
   rez &= (enB != NULL);
   if (!rez) // проверяем создались ли объекты
   {
       qApp->quit();
       return;
   }
   //---------------------------
   l0->move(50, 0);
   l1->move(50, 30);
   l2->move(50, 60);
   l3->move(50, 90);

   rusB->move(0, 550);
   frB->move(200, 550);
   jaB->move(400, 550);
   enB->move(600, 550);

   rusB->resize(200, 30);
   frB->resize(200, 30);
   jaB->resize(200, 30);
   enB->resize(200, 30);
   switchLanguage(QLocale::system().name()); // устанавливаем язык системы
   connect(rusB, SIGNAL(clicked()), this, SLOT(clickSwitch()));
   connect(frB, SIGNAL(clicked()), this, SLOT(clickSwitch()));
   connect(jaB, SIGNAL(clicked()), this, SLOT(clickSwitch()));
   connect(enB, SIGNAL(clicked()), this, SLOT(clickSwitch()));

}

void MainWindow::switchLanguage(QString language) {

   translater.load("switchlang_" + language);
   qApp->installTranslator(&translater);
   QString str = tr("Switch language on ");
   rusB->setText(str + "Русский");
   frB->setText(str + "Francais");
   jaB->setText(str + "日本語");
   enB->setText(str + "English");
   QLabel *labels[] = {l0, l1, l2, l3};
   QString list[] =
   {

       tr("Hello"),
       tr("What is you name?"),
       tr("I'm going to learn Qt"),
       tr("Bye-Bye!")

   };

   for (int i = 0; i < 4; i++) {

       labels[i]->setText(tr("This is l") + QString::number(i) + ": " + list[i]);
       labels[i]->resize(700, 30);

   }

}

MainWindow::~MainWindow() {

   RELEASE(l0);
   RELEASE(l1);
   RELEASE(l2);
   RELEASE(l3);
   RELEASE(rusB);
   RELEASE(frB);
   RELEASE(jaB);
   RELEASE(enB);

}

void MainWindow::clickSwitch() {

   QObject *obj = sender(); // узнаём, от какого виджета пришел сигнал
   if (obj == rusB)switchLanguage("ru");
   if (obj == frB)switchLanguage("fr");
   if (obj == jaB)switchLanguage("ja");
   if (obj == enB)switchLanguage("en");

}
