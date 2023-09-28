#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QTextCodec>
#include <QSysInfo>

MainWindow::MainWindow(QWidget *parent) :
   QMainWindow(parent),
   ui(new Ui::MainWindow) {

   ui->setupUi(this);
   proc = new QProcess(this);
   connect(proc, SIGNAL(readyReadStandardOutput()), this, SLOT(procCMD()));

}

MainWindow::~MainWindow() {

   delete ui;

}

void MainWindow::on_pushButton_clicked() {

   QString cmd = "";
    if (QSysInfo::productType() == "windows") {

        cmd = "cmd /C ";

    }
   cmd += ui->lineEdit->text();
   proc->start(cmd);

}

void MainWindow::procCMD() {

   QTextCodec *codec = QTextCodec::codecForName("IBM866");
   ui->plainTextEdit->appendPlainText(codec->toUnicode(proc->readAllStandardOutput()));

}
