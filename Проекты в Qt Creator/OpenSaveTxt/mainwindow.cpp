#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QTextStream>
#include <QDataStream>
#include <QHash>
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    filter = trUtf8("Текстовый файл(*.txt);;Двоичный файл(*.original)");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_saveButton_clicked()
{
    QString s = QFileDialog::getSaveFileName(this, "Заголовок окна",
    QDir::current().path(), filter);
    if (s.length() > 0)
    {
        int index = s.indexOf(".txt"); // определяем, есть ли в названии
                                        // строка ".txt"
        QFile file(s);
        if (file.open(QFile::WriteOnly))
        {
            if (index != -1) // если текстовый файл (выполняются
                            // 2 условия)
            {
                QTextStream stream(&file);
                stream << ui->plainTextEdit->toPlainText();

            } else {
                QDataStream stream(&file);
                QByteArray b = QString("GB_Qt_STUDY").toUtf8();
                stream.writeRawData(b.data(), b.length());
                QHash<QChar, int>symbamount;
                symbamount.clear();
                QString str = ui->plainTextEdit->toPlainText();
                int amount = str.length();
                QString usedS = "";
                for (int i = 0; i < amount; ++i)
                {
                    QChar ch = str.at(i);
                    int index = usedS.indexOf(ch);
                    if (index == -1)
                    {
                        symbamount[ch] = 0;
                        usedS += ch;
                    } else {
                        symbamount[ch]++;
                    }
                }

//********************************
                for (int i = 0; i < amount; ++i)
                {
                    QChar chi = usedS[i];
                    for (int j = i + 1; j < amount; ++j)
                    {
                        QChar chj = usedS[j];
                        if (symbamount[chi] < symbamount[chj])
                        {
                            usedS[i] = chj;
                            usedS[j] = chi;
                            chi = chj;
                        }
                    }
                }
                symbamount.clear(); // больше не понадобится
//**********************************************

                b = usedS.toUtf8();
                amount = b.length();
                stream.writeRawData(reinterpret_cast<char*>(&amount), sizeof amount);
                stream.writeRawData(b.data(), amount);
//***********************************************
                amount = str.length();
                for (int i = 0; i < amount; i++)
                {
                    int index = usedS.indexOf(str.at(i));
                    for (bool w = true; w;)
                    {
                        char wr = index % 128;
                        index /= 128;
                        if (index)
                        {
                            wr |= 0x80;
                            stream.writeRawData(&wr, 1); // старший бит
                                                        // сообщает, что
                                                        // значение состоит
                                                        // еще из 1 байта
                        } else {
                            stream.writeRawData(&wr, 1);
                            w = false;
                        }
                    }
                }
            }
            file.close();
        }
    }
}

void MainWindow::on_openButton_clicked()
{
    QString s = QFileDialog::getOpenFileName(this, "Заголовок окна",
    QDir::current().path(), filter);
    if (s.length() > 0)
    {
        int index = s.indexOf(".txt");
        QFile file(s);
        if (file.open(QFile::ReadOnly | QFile::ExistingOnly))
        {
            if (index != -1 && s.length() - 4 == index) // если текстовый файл
                                                        // (выполняются 2
                                                        // условия)
            {
                QTextStream stream(&file);
                ui->plainTextEdit->setPlainText(stream.readAll());
            } else {
                QDataStream stream(&file);
                QByteArray b = QString("GB_Qt_STUDY").toUtf8();
                char mH[15];
                stream.readRawData(mH, b.length());
                if (memcmp(mH, b.data(), b.length())) // если не совпадает
                                                    // заголовок, то открытие
                                                    // недопустимо, так как
                                                    // формат у файла другой
                {
                file.close();
                return;
                }
                uint amount = 0;
                stream.readRawData(reinterpret_cast<char*>(&amount), sizeof amount);
                b.resize(amount);
                stream.readRawData(b.data(), amount);
                QString usedS = trUtf8(b.data());
                QString str = "";
                uint pos = 0;
                uint mm = 1;
                for (;!stream.atEnd();)
                {
                   char ch;
                   stream.readRawData(&ch, 1);
                   bool bl = (ch & 0x80) ? false : true;
                   int rValue = (ch & 0x7F);
                    pos += mm * rValue;
                    mm *= 128;
                    if (bl)
                    {
                        mm = 1;
                        str += usedS.at(pos);
                        pos = 0;
                    }
                }
                ui->plainTextEdit->setPlainText(str);
            }
        }
        file.seek(0);
        auto pp = file.readAll();
        file.close();
    }
}
