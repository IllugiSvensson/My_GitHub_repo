#include "include/FileSystem.h"

FileSystem::FileSystem(QWidget *parent, bool bOnlyOpen) :
    QWidget(parent)
{
    initGUI();
    buildGUI();
    setGUIParameters(bOnlyOpen);
    makeFSModel(bOnlyOpen);
    setWidgetConnections();
}

void FileSystem::initGUI() noexcept
{
    m_pMainLayout = new QGridLayout(this);
    m_pFileSystemTree = new QTreeView(this);
    m_pFileNameEdit = new QLineEdit(this);
    m_pCurrentPathLabel = new QLineEdit(this);
    m_pApproveButton = new QPushButton(this);
    m_pExitButton = new QPushButton(this);
}

void FileSystem::buildGUI() noexcept
{
    this->resize(600, 500);
    m_pMainLayout->addWidget(m_pCurrentPathLabel, 0, 0, 1, 4);
    m_pMainLayout->addWidget(m_pFileSystemTree, 1, 0, 2, 4);
    m_pMainLayout->addWidget(m_pApproveButton, 3, 0, 1, 1);
    m_pMainLayout->addWidget(m_pFileNameEdit, 3, 1, 1, 2);
    m_pMainLayout->addWidget(m_pExitButton, 3, 3, 1, 1);
}

void FileSystem::setGUIParameters(bool bOnlyOpen) noexcept
{
    m_pCurrentPathLabel->setText(QString::fromStdString(get_path().string()));
    m_pCurrentPathLabel->setDisabled(true);

    m_pApproveButton->setText("\342\234\205");
    m_pExitButton->setText("\342\235\214");

    if (bOnlyOpen)
        m_pFileNameEdit->setHidden(true);
    else
        m_pFileNameEdit->setHidden(false);
}

void FileSystem::makeFSModel(bool bOnlyOpen) noexcept
{
    auto FileSystemModel = new QFileSystemModel(this);
    FileSystemModel->setFilter(QDir::Files | QDir::AllDirs | QDir::NoDotAndDotDot);
    FileSystemModel->setNameFilters(QStringList()<<"*.xml");
    FileSystemModel->setNameFilterDisables(false);
    FileSystemModel->setReadOnly(bOnlyOpen);

    m_pFileSystemTree->setModel(FileSystemModel);
    m_pFileSystemTree->setColumnWidth(0, 250);
    m_pFileSystemTree->setRootIndex(FileSystemModel->setRootPath(QString::fromStdString(get_path().string())));
}

void FileSystem::setWidgetConnections() noexcept
{
    connect(m_pExitButton, &QPushButton::clicked, this, &FileSystem::exitButtonClicked);
    connect(m_pFileSystemTree, &QTreeView::clicked, this, &FileSystem::fsTreeItemClicked);
    connect(m_pApproveButton, &QPushButton::clicked, this, &FileSystem::approveButtonClicked);
}

void FileSystem::exitButtonClicked() noexcept
{
    this->close();
}

void FileSystem::fsTreeItemClicked(const QModelIndex& crIndex) noexcept
{
    QString FullPath = crIndex.data(Qt::DisplayRole).toString();
    QModelIndex StartIndex;
    QModelIndex CurrentIndex = crIndex;

    while(CurrentIndex.parent() != StartIndex)
    {
        FullPath = (CurrentIndex.parent()).data(Qt::DisplayRole).toString() + "/" + FullPath;
        CurrentIndex = CurrentIndex.parent();
    }

    if (FullPath.length() <= 1)
        c_strPathToXML = FullPath.toStdString();
    else
        c_strPathToXML = (FullPath.remove(0, 1)).toStdString();

    m_pCurrentPathLabel->setText(QString::fromStdString(c_strPathToXML));
}

void FileSystem::approveButtonClicked() noexcept
{
    emit approveButtonWasClicked(c_strPathToXML);
    this->close();
}

FileSystem::~FileSystem()
{
    this->close();
}

nita::b_path get_path()
{
    return nita::expanded_path("%%NITADATA%%/updates/testmaps");
}
