#include "filesystem.h"
#include "ui_filesystem.h"

filesystem::filesystem(bool a, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::filesystem)
{
    ui->setupUi(this);
    auto fileSystemModel = new QFileSystemModel(this);
    fileSystemModel->setRootPath(QDir::rootPath());
    fileSystemModel->setReadOnly(false);
    fileSystemModel->setNameFilters(QStringList()<<"*.txt");
    fileSystemModel->setFilter(QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot);
    ui->FStree->setModel(fileSystemModel);
    reg = a;
}

filesystem::~filesystem()
{
    delete ui;
}

void filesystem::on_approve_clicked()
{
    emit approve_clicked(path, reg);
    this->close();
}

void filesystem::on_FSNO_button_clicked()
{
    this->close();
}

void filesystem::on_FStree_clicked(const QModelIndex &index)
{
    QString fullpath = index.data(Qt::DisplayRole).toString();
    QModelIndex start, current = index;
    while(current.parent() != start)
    {
        fullpath = (current.parent()).data(Qt::DisplayRole).toString() + "/" + fullpath;
        current = current.parent();
    }
    if (fullpath.length() <= 1)
        path = fullpath;
    else
        path = fullpath.remove(0, 1);
    ui->path_label->setText(path);
}

