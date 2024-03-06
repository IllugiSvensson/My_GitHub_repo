#include "settings.h"
#include "ui_settings.h"
#include <iostream>


Settings::Settings(QMap<QString, QString> settings, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Settings)
{
    ui->setupUi(this);
    initialTable(settings);
}

Settings::~Settings()
{
    delete ui;
}

void Settings::initialTable(QMap<QString, QString> strL)
{
    ui->tableWidget->setColumnCount(2);
    ui->tableWidget->setRowCount(strL.size());
    ui->tableWidget->setColumnWidth(0, 140);
    ui->tableWidget->setColumnWidth(1, 101) ;
    ui->tableWidget->setHorizontalHeaderLabels(QStringList() << "Name" << "Value");

    QMap<QString, QString>::iterator it = strL.begin();
    for (int i = 0; it != strL.end(), i <ui->tableWidget->rowCount(); ++it, ++i)
    {
        QTableWidgetItem* item = new QTableWidgetItem(it.key());
        ui->tableWidget->setItem(i, 0, item);
        item->setFlags(item->flags() &  ~Qt::ItemIsEditable);
        item = new QTableWidgetItem(it.value());
        ui->tableWidget->setItem(i, 1, item);
    }
}

void Settings::on_approve_clicked()
{
    QFile file("/home/sad/Projects/Qt_Prj/untitled/config.txt");
    if (file.open(QFile::WriteOnly))
    {
        QTextStream stream(&file);
        for (int i = 0; i < ui->tableWidget->rowCount(); ++i)
        {
            stream << ui->tableWidget->item(i, 0)->text()
                   << ":" << ui->tableWidget->item(i, 1)->text() << "\n";
        }
        file.close();
    }
    emit approve_clicked();
    this->close();
}

void Settings::on_cancel_clicked()
{
    this->close();
}

void Settings::keyReleaseEvent(QKeyEvent *event)
{
    if (ui->tableWidget->currentColumn() + ui->tableWidget->currentRow() >= 0)
    {
        ui->tableWidget->item(ui->tableWidget->currentRow(), 1)->setText("");
        ui->tableWidget->item(ui->tableWidget->currentRow(), 1)
                ->setText(QString::number(event->key()));
    }
}
