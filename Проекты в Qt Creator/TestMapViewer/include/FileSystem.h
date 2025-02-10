#pragma once

#include <QWidget>
#include <QGridLayout>
#include <QTreeView>
#include <QPushButton>
#include <QFileSystemModel>
#include <QLineEdit>

#include <inline/filesystem/expanded_path.h>
#include <inline/translation/cp1251_conversions.h>

class FileSystem : public QWidget
{
    Q_OBJECT

public:
    explicit FileSystem(QWidget *parent = nullptr, bool bOnlyOpen = true, const QString& crFontSize = "11");
    ~FileSystem();

private:
    QGridLayout* m_pMainLayout = nullptr;
    QTreeView* m_pFileSystemTree = nullptr;
    QLineEdit* m_pCurrentPathLabel = nullptr;
    QPushButton* m_pApproveButton = nullptr;
    QLineEdit* m_pFileNameEdit = nullptr;
    QPushButton* m_pExitButton = nullptr;

    std::string strPathToXML = "";

private slots:
    void initGUI() noexcept;
    void buildGUI() noexcept;
    void setGUIParameters(const bool bOnlyOpen, const QString& crFontSize) noexcept;
    void makeFSModel(const bool bOnlyOpen) noexcept;
    void setWidgetConnections() noexcept;

    void clickExitButton() noexcept;
    void clickFSTreeItem(const QModelIndex& crIndex) noexcept;
    void clickApproveButton() noexcept;

signals:
    void approveButtonWasClicked(const std::string);
    //void approveButtonWasClicked(const std::vector<std::string> vFullPathList);
};

nita::b_path get_path();
