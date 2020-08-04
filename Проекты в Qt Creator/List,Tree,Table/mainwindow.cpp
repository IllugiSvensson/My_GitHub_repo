#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QFileSystemModel>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow) {

    ui->setupUi(this);

    ui->listWidget->addItem("Audi");
    ui->listWidget->addItem("Ford");
    ui->listWidget->addItem("BMW");
    ui->listWidget->addItem("Maseratti");

    ui->tableWidget->setRowCount(4);
    ui->tableWidget->setColumnCount(6);
    ui->tableWidget->setHorizontalHeaderLabels(QStringList() << "a" << "b" << "c" << "d");

        for(int i = 0; i < ui->tableWidget->rowCount(); i++) {
            for(int j = 0; j < ui->tableWidget->columnCount(); j++) {

                QString str = tr("Cell N %1, %2").arg(i).arg(j);
                QTableWidgetItem* item = new QTableWidgetItem(str);
                ui->tableWidget->setItem(i, j, item);

            }

        }

    ui->treeWidget->setHeaderLabel("Objects");
    ui->treeWidget->setColumnCount(1);

        QTreeWidgetItem* item = new QTreeWidgetItem();
        item->setText(0, "Obj 1");
        QTreeWidgetItem* child = new QTreeWidgetItem();
        child->setText(0, "Obj 1.1");
        item->addChild(child);
        QTreeWidgetItem* child2 = new QTreeWidgetItem();
        child2->setText(0, "Obj 1.2");
        item->addChild(child2);
        ui->treeWidget->addTopLevelItem(item);

    auto fileSystemModel = new QFileSystemModel(this);
    fileSystemModel->setRootPath(QDir::rootPath());
    fileSystemModel->setReadOnly(false);

        ui->listView->setModel(fileSystemModel);
        ui->listView->setRootIndex(fileSystemModel->index(QDir::homePath()));

        ui->treeView->setModel(fileSystemModel);
        ui->treeView->setSelectionModel(ui->listView->selectionModel());

        ui->tableView->setModel(fileSystemModel);
        ui->tableView->setRootIndex(fileSystemModel->index(QDir::homePath()));
}

MainWindow::~MainWindow() {

    delete ui;

}

void MainWindow::on_pushButton_clicked() {

    QMessageBox::information(this, "Info", ui->listWidget->currentItem()->text());
    //QMessageBox::information(this, "Info", ui->tableWidget->currentItem()->text());
    //QMessageBox::information(this, "Info", ui->treeWidget->currentItem()->text(1));

}
