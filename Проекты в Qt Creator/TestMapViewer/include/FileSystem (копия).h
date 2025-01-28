#pragma once

#include <QWidget>
#include <QGridLayout>
#include <QTreeView>
#include <QPushButton>
#include <QFileSystemModel>
#include <QLineEdit>

class FileSystem : public QWidget
{
    Q_OBJECT

public:
    explicit FileSystem(QWidget *parent = nullptr, bool isOnlyOpen = true);
    ~FileSystem();

private:
    QGridLayout* m_pMainLayout = nullptr;
    QTreeView* m_pFileSystemTree = nullptr;
    QLineEdit* m_pFileNameEdit = nullptr;
    QLineEdit* m_pCurrentPathLabel = nullptr;
    QPushButton* m_pApproveOpenButton = nullptr;
    QPushButton* m_pExitButton = nullptr;

    const std::string c_strPathToXML;

private slots:
    void initGUI() noexcept;
    void buildGUI() noexcept;
    void setGUIParameters(bool isOnlyOpen) noexcept;
    void makeFSModel(bool isOnlyOpen) noexcept;
    void setWidgetConnections() noexcept;

//    void buildUI(bool create) noexcept;
    void on_approve_clicked() noexcept;
//    void on_FSNO_button_clicked() noexcept;
//    void on_FStree_clicked(const QModelIndex &index) noexcept;

signals:
    void approve_clicked(std::string);

};
