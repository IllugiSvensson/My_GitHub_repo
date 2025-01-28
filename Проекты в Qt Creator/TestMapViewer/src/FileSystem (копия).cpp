#include "include/FileSystem.h"

FileSystem::FileSystem(QWidget *parent, bool isOnlyOpen) :
    QWidget(parent)
{
    initGUI();
//    buildGUI();
//    setGUIParameters(isOnlyOpen);
//    makeFSModel(isOnlyOpen);
//    setWidgetConnections();
}

void FileSystem::initGUI() noexcept
{
    m_pMainLayout = new QGridLayout(this);
    m_pFileSystemTree = new QTreeView(this);
    m_pFileNameEdit = new QLineEdit(this);
    m_pCurrentPathLabel = new QLineEdit(this);
    m_pApproveOpenButton = new QPushButton(this);
    m_pExitButton = new QPushButton(this);
}

void FileSystem::buildGUI() noexcept
{
    this->resize(600, 500);
    m_pMainLayout->addWidget(m_pCurrentPathLabel, 0, 0, 1, 4);
    m_pMainLayout->addWidget(m_pFileSystemTree, 1, 0, 2, 4);
    m_pMainLayout->addWidget(m_pApproveOpenButton, 3, 0, 1, 1);
    m_pMainLayout->addWidget(m_pFileNameEdit, 3, 1, 1, 2);
    m_pMainLayout->addWidget(m_pExitButton, 3, 3, 1, 1);
}

void FileSystem::setGUIParameters(bool isOnlyOpen) noexcept
{
    m_pCurrentPathLabel->setText("/data/updates/testmaps");
    m_pCurrentPathLabel->setDisabled(true);

    m_pApproveOpenButton->setText("\342\234\205");
    m_pExitButton->setText("\342\235\214");

    if (isOnlyOpen)
        m_pFileNameEdit->setHidden(true);
    else
        m_pFileNameEdit->setHidden(false);
}

void FileSystem::makeFSModel(bool isOnlyOpen) noexcept
{
    auto FileSystemModel = new QFileSystemModel(this);
    FileSystemModel->setFilter(QDir::Files | QDir::AllDirs | QDir::NoDotAndDotDot);
    FileSystemModel->setNameFilters(QStringList()<<"*.xml");
    FileSystemModel->setNameFilterDisables(false);
    FileSystemModel->setReadOnly(isOnlyOpen);

    m_pFileSystemTree->setModel(FileSystemModel);
    m_pFileSystemTree->setColumnWidth(0, 250);
    m_pFileSystemTree->setRootIndex(FileSystemModel->setRootPath("/data/updates/testmaps"));
}

void FileSystem::setWidgetConnections() noexcept
{
    //    connect(exitButton, &QPushButton::clicked, this, &FileSystem::on_FSNO_button_clicked);
    //    connect(approveButton, &QPushButton::clicked, this, &FileSystem::on_approve_clicked);
    //    connect(filesystemTree, &QTreeView::clicked, this, &FileSystem::on_FStree_clicked);
}









FileSystem::~FileSystem()
{
    this->close();
}



void FileSystem::on_approve_clicked() noexcept
{
    emit approve_clicked(c_strPathToXML);
    this->close();
}

//void FileSystem::on_FSNO_button_clicked() noexcept
//{
//    this->close();
//}

//void FileSystem::on_FStree_clicked(const QModelIndex &index) noexcept
//{
//    QString fullpath = index.data(Qt::DisplayRole).toString();
//    QModelIndex start, current = index;
//    while(current.parent() != start)
//    {
//        fullpath = (current.parent()).data(Qt::DisplayRole).toString() + "/" + fullpath;
//        current = current.parent();
//    }
//    if (fullpath.length() <= 1)
//        path = fullpath.toStdString();
//    else
//        path = (fullpath.remove(0, 1)).toStdString();
//    currentPath->setText(QString::fromStdString(path));
//}

