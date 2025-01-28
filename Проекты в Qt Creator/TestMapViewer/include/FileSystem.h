#pragma once

#include <QWidget>
#include <QGridLayout>
#include <QTreeView>
#include <QPushButton>
#include <QFileSystemModel>
#include <QLineEdit>

#include <inline/filesystem/expanded_path.h>

class FileSystem : public QWidget
{
    Q_OBJECT

public:
    explicit FileSystem(QWidget *parent = nullptr, bool bOnlyOpen = true);
    ~FileSystem();

private:
    QGridLayout* m_pMainLayout = nullptr;
    QTreeView* m_pFileSystemTree = nullptr;
    QLineEdit* m_pFileNameEdit = nullptr;
    QLineEdit* m_pCurrentPathLabel = nullptr;
    QPushButton* m_pApproveButton = nullptr;
    QPushButton* m_pExitButton = nullptr;

    std::string c_strPathToXML = "";

private slots:
    void initGUI() noexcept;
    void buildGUI() noexcept;
    void setGUIParameters(const bool bOnlyOpen) noexcept;
    void makeFSModel(const bool bOnlyOpen) noexcept;
    void setWidgetConnections() noexcept;

    void exitButtonClicked() noexcept;
    void fsTreeItemClicked(const QModelIndex& crIndex) noexcept;
    void approveButtonClicked() noexcept;

signals:
    void approveButtonWasClicked(const std::string);
};

nita::b_path get_path();
