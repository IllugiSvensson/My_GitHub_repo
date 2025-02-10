#include "include/FileSystem.h"

FileSystem::FileSystem(QWidget *parent, bool bOnlyOpen, const QString& crFontSize) :
    QWidget(parent)
{
    initGUI();
    buildGUI();
    setGUIParameters(bOnlyOpen, crFontSize);
    makeFSModel(bOnlyOpen);
    setWidgetConnections();
}

void FileSystem::initGUI() noexcept
{
    m_pMainLayout = new QGridLayout(this);
    m_pFileSystemTree = new QTreeView(this);
    m_pCurrentPathLabel = new QLineEdit(this);
    m_pApproveButton = new QPushButton(this);
    m_pFileNameEdit = new QLineEdit(this);
    m_pExitButton = new QPushButton(this);
}

void FileSystem::buildGUI() noexcept
{
    this->resize(1280, 720);
    m_pMainLayout->addWidget(m_pCurrentPathLabel, 0, 0, 1, 4);
    m_pMainLayout->addWidget(m_pFileSystemTree, 1, 0, 2, 4);
    m_pMainLayout->addWidget(m_pApproveButton, 3, 0, 1, 1);
    m_pMainLayout->addWidget(m_pFileNameEdit, 3, 1, 1, 2);
    m_pMainLayout->addWidget(m_pExitButton, 3, 3, 1, 1);
}

void FileSystem::setGUIParameters(const bool bOnlyOpen, const QString& crFontSize) noexcept
{
    m_pCurrentPathLabel->setText(QString::fromStdString(get_path().string()));
    m_pCurrentPathLabel->setDisabled(true);

    m_pApproveButton->setText(nita::convert_cp1251_string_to_unicode("Применить"));
    m_pExitButton->setText(nita::convert_cp1251_string_to_unicode("Выйти"));

    if (bOnlyOpen)
        m_pFileNameEdit->setHidden(true);
    else
        m_pFileNameEdit->setHidden(false);

    QFont Font;
    Font.setPointSize(crFontSize.toInt());
    this->setFont(Font);
}

void FileSystem::makeFSModel(const bool bOnlyOpen) noexcept
{
    auto* pFileSystemModel = new QFileSystemModel(this);
    pFileSystemModel->setFilter(QDir::Files | QDir::AllDirs | QDir::NoDotAndDotDot);
    pFileSystemModel->setNameFilters(QStringList()<<"*.xml");
    pFileSystemModel->setNameFilterDisables(false);
    pFileSystemModel->setReadOnly(bOnlyOpen);

    m_pFileSystemTree->setModel(pFileSystemModel);
    m_pFileSystemTree->setColumnWidth(0, 700);
    m_pFileSystemTree->setRootIndex(pFileSystemModel->setRootPath(QString::fromStdString(get_path().string())));
    m_pFileSystemTree->setSelectionMode(QAbstractItemView::ExtendedSelection);
}

void FileSystem::setWidgetConnections() noexcept
{
    connect(m_pExitButton, &QPushButton::clicked, this, &FileSystem::clickExitButton);
    connect(m_pFileSystemTree, &QTreeView::clicked, this, &FileSystem::clickFSTreeItem);
    connect(m_pApproveButton, &QPushButton::clicked, this, &FileSystem::clickApproveButton);
}

void FileSystem::clickExitButton() noexcept
{
    this->close();
}

void FileSystem::clickFSTreeItem(const QModelIndex& crIndex) noexcept
{
    QString FullPath = crIndex.data(Qt::DisplayRole).toString();
    QModelIndex StartIndex;
    QModelIndex CurrentIndex = crIndex;

    while (CurrentIndex.parent() != StartIndex)
    {
        FullPath = (CurrentIndex.parent()).data(Qt::DisplayRole).toString() + "/" + FullPath;
        CurrentIndex = CurrentIndex.parent();
    }

    if (FullPath.length() > 1)
        FullPath.remove(0, 1);

    m_pCurrentPathLabel->setText(FullPath);
    strPathToXML = FullPath.toStdString();
}

void FileSystem::clickApproveButton() noexcept
{
    //    QModelIndexList SelectedItemsList =  m_pFileSystemTree->selectionModel()->selectedIndexes();
    //    QString FullPath;
    //    std::vector<std::string> vFullPathList;
    //    QModelIndex StartIndex;
    //    QModelIndex CurrentIndex;

    //    for (int i = 0; i < SelectedItemsList.size(); i = i + 4)
    //    {
    //        CurrentIndex = SelectedItemsList.at(i);
    //        FullPath = (SelectedItemsList.at(i)).data(Qt::DisplayRole).toString();
    //        while (CurrentIndex.parent() != StartIndex)
    //        {
    //            FullPath = (CurrentIndex.parent()).data(Qt::DisplayRole).toString() + "/" + FullPath;
    //            CurrentIndex = CurrentIndex.parent();
    //        }

    //        if (FullPath.length() <= 1)
    //           vFullPathList.push_back(FullPath.toStdString());
    //        else
    //            vFullPathList.push_back((FullPath.remove(0, 1)).toStdString());
    //    }
    //    emit approveButtonWasClicked(vFullPathList);
    emit approveButtonWasClicked(strPathToXML);
    this->close();
}

FileSystem::~FileSystem()
{
    this->close();
}

nita::b_path get_path()
{
    return nita::expanded_path("%%NITAETC%%/_System/testmaps");
}
