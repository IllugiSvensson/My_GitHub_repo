#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFile>
#include <QTextStream>
#include <QFileDialog>
#include <QDir>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow) {

    ui->setupUi(this);

    QMap<QString, TownInfo> townList; //Контейнерный класс
    townList.clear();       //QMap сортирует по ключам

    TownInfo someTown;  //Присваиваем ключам структуры с данными
    someTown.year = 1147;
    someTown.index = 101000;
    townList["Moscow"] = someTown;
    townList["Spb"] = TownInfo(1703, 187021);
    townList["Novosib"] = TownInfo(1893, 630001);

    QString text;
        foreach (auto town, townList) {     //Цикл for без счетчика

            text.append(QString::number(town.year));
            text.append(" ");

        }
        ui->lineEdit->setText(text);

    QPixmap image(":/img/image1.jpg"); //Работа с изображениями
    QPalette pal;
    pal.setBrush(QPalette::Background, image);
        setPalette(pal);
        image = image.scaled(230, 170, Qt::IgnoreAspectRatio);
        ui->label->setPixmap(image);

    QString str = QFileDialog::getOpenFileName();
        if(str.length()) {

            QFile file(str); //Работа с файлами
            if (file.open(QIODevice::ReadOnly)) { //Читаем файл

                QTextStream stream(&file);
                QString str = stream.read(file.size());
                ui->lineEdit_2->setText(str);
                file.close();

            }

        }

    QDir dir;   //Работа с каталогами
    dir.setFilter((QDir::Files | QDir::Hidden | QDir::NoSymLinks | QDir::Dirs));
    QFileInfoList list = dir.entryInfoList();
    QString result = "";
        for (QFileInfoList::iterator iter = list.begin(),
         end = list.end(); iter < end; iter++) {
            //Ищем все файлы в каталоге, прошедшие фильтр
            result += (*iter).fileName() + "\n";

        }
    ui->plainTextEdit->setPlainText(result);

}

MainWindow::~MainWindow() {

    QFile file("/home/woljin1/Рабочий\ стол/test_file.txt");
    if(file.open(QIODevice::WriteOnly)) { //Записываем файл при закрыти

        QTextStream stream(&file);
        QString str = ui->lineEdit_2->text();
        stream << str;
        stream.flush();
        file.close();

    }

    delete ui;

}

void MainWindow::on_pushButton_clicked() {
    //Строка - контейнер для символьных типов
    QString str = ui->lineEdit->text();
    str.append("!!!");
    ui->lineEdit_2->setText(str);

}
