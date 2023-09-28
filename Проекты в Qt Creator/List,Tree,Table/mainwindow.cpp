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



    QListWidgetItem *itemL = new QListWidgetItem(QIcon("D:/QtCreator/Project/untitled2/C++.png"), QString("C++"));
    itemL->setFlags(itemL->flags() | Qt::ItemIsEditable);
    ui->listWidgetHW->addItem(itemL);
    itemL = new QListWidgetItem(QIcon("D:/QtCreator/Project/untitled2/python.png"), QString("Python"));
    itemL->setFlags(itemL->flags() | Qt::ItemIsEditable);
    ui->listWidgetHW->addItem(itemL);
    itemL = new QListWidgetItem(QIcon("D:/QtCreator/Project/untitled2/java.png"), QString("Java"));
    itemL->setFlags(itemL->flags() | Qt::ItemIsEditable);
    ui->listWidgetHW->addItem(itemL);
    itemL = new QListWidgetItem(QIcon("D:/QtCreator/Project/untitled2/C#.png"), QString("C#"));
    itemL->setFlags(itemL->flags() | Qt::ItemIsEditable);
    ui->listWidgetHW->addItem(itemL);
    itemL = new QListWidgetItem(QIcon("D:/QtCreator/Project/untitled2/PHP.png"), QString("PHP"));
    itemL->setFlags(itemL->flags() | Qt::ItemIsEditable);
    ui->listWidgetHW->addItem(itemL);
    itemL = new QListWidgetItem(QIcon("D:/QtCreator/Project/untitled2/JS.png"), QString("JavaScript"));
    itemL->setFlags(itemL->flags() | Qt::ItemIsEditable);
    ui->listWidgetHW->addItem(itemL);

    ui->tableWidget_2->setRowCount(3);
    ui->tableWidget_2->setColumnCount(4);
    ui->tableWidget_2->setHorizontalHeaderLabels(QStringList() << "№" << "name" << "IP" << "MAC");
    Comp comp1("1", "Dell", "192.168.15.16","22:32:f2:3e:1d");
    Comp comp2("2", "Lenovo", "192.168.15.117","2a:32:a2:3e:6d");
    Comp comp3("3", "HP", "192.168.15.217","2a:39:a2:3f:6d");
        ui->tableWidget_2->setItem(0, 0, new QTableWidgetItem(comp1.number));
        ui->tableWidget_2->setItem(0, 1, new QTableWidgetItem(comp1.name));
        ui->tableWidget_2->setItem(0, 2, new QTableWidgetItem(comp1.ipaddr));
        ui->tableWidget_2->setItem(0, 3, new QTableWidgetItem(comp1.mac));
        ui->tableWidget_2->setItem(1, 0, new QTableWidgetItem(comp2.number));
        ui->tableWidget_2->setItem(1, 1, new QTableWidgetItem(comp2.name));
        ui->tableWidget_2->setItem(1, 2, new QTableWidgetItem(comp2.ipaddr));
        ui->tableWidget_2->setItem(1, 3, new QTableWidgetItem(comp2.mac));
        ui->tableWidget_2->setItem(2, 0, new QTableWidgetItem(comp3.number));
        ui->tableWidget_2->setItem(2, 1, new QTableWidgetItem(comp3.name));
        ui->tableWidget_2->setItem(2, 2, new QTableWidgetItem(comp3.ipaddr));
        ui->tableWidget_2->setItem(2, 3, new QTableWidgetItem(comp3.mac));

}

MainWindow::~MainWindow() {

    delete ui;

}

void MainWindow::on_pushButton_clicked() {

    QMessageBox::information(this, "Info", ui->listWidget->currentItem()->text());
    //QMessageBox::information(this, "Info", ui->tableWidget->currentItem()->text());
    //QMessageBox::information(this, "Info", ui->treeWidget->currentItem()->text(1));

}

void MainWindow::on_pushButton_2_clicked()
{
    QListWidgetItem *item = new QListWidgetItem(QIcon("D:/QtCreator/Project/untitled2/C.png"), QString("language"));
    item->setFlags(item->flags() | Qt::ItemIsEditable);
    ui->listWidgetHW->addItem(item);
}

void MainWindow::on_pushButton_3_clicked()
{
    int row = ui->listWidgetHW->currentRow();
    delete ui->listWidgetHW->takeItem(row);
}

void MainWindow::on_checkBox_stateChanged(int arg1)
{
    if (ui->checkBox->isChecked() == 1)
    {
        ui->listWidgetHW->setViewMode(QListWidget::IconMode);
        ui->listWidgetHW->setResizeMode(QListView::Adjust);
    } else
    {
        ui->listWidgetHW->setViewMode(QListWidget::ListMode);
    }
}

void MainWindow::on_pushButton_4_clicked()
{
    QList<QTableWidgetItem *> List = ui->tableWidget_2->selectedItems();
    foreach (QTableWidgetItem *value, List)
    {
        for (int i = 0; i < ui->tableWidget_2->columnCount(); i++)
            ui->tableWidget_2->item(value->row(), i)->setBackground(Qt::red);
    }

}
