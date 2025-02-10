#pragma once

#include <QMainWindow>
#include <QTextEdit>
#include <QTreeWidget>
#include <QLabel>
#include <QToolBar>
#include <QComboBox>
#include <QProcess>

#include <boost/date_time.hpp>

#include "include/FileSystem.h"
#include "include/TestMapManager.h"

class TestMapViewer : public QMainWindow
{
    Q_OBJECT

public:
    explicit TestMapViewer(QWidget *parent = nullptr);
    ~TestMapViewer();

public slots:
    void initGUI() noexcept;
    void buildGUI() noexcept;
    void buildResultButtons() noexcept;
    void setGUIParameters() noexcept;
    void blockUnblockResultButtons(const bool bBlock) noexcept;
    void setWidgetConnections() noexcept;
    void switchFontSize(const QString& crPickedFontSize) noexcept;

//    void openTestMap() noexcept;
//    void recordScreen() noexcept;
//    void setTestLevel() noexcept;
//    void closeTestMap() noexcept;

//    void buildTestMapTree(const std::string& crPathToXml);
//    void readTestObjects(registry::CNode& nodeTestObjects) noexcept;
//    void readTestNames(registry::CNode& nodeTestNames) noexcept;

//    int getTestLevel(const registry::CNode& nodeTestLevel) noexcept;
//    QBrush paintTestMapTrees(const registry::CNode& nodeTestName) noexcept;

//    void readPickedTest() noexcept;
//    void saveCurrentTest() noexcept;

//    std::string getButtonText() noexcept;


    //void buildTestMapTree(const std::vector<std::string> c_vFullPathList);
    //void readTestObjects(registry::CNode nodeTestObjects, QTreeWidgetItem* pRootElement, std::vector<std::string> vTestObjects) noexcept;
    //void readTestNames(registry::CNode nodeTestNames, QTreeWidgetItem* pCurrentTestObjectItem, std::vector<std::string> vTestNames) noexcept;

private:
    QToolBar* m_pToolBar = nullptr;
    QComboBox* m_pTestLevelCombo = nullptr;
    QComboBox* m_pFontSizeCombo = nullptr;
    QAction* m_pOpenTestMap = nullptr;
    QAction* m_pCreateNewTestMap = nullptr;
    QAction* m_pRecordScreen = nullptr;

    QWidget* m_pMainWidget = nullptr;
    QGridLayout* m_pMainLayout = nullptr;
    QTreeWidget* m_pTestMapTrees = nullptr;
    QTextEdit* m_pUsecaseText = nullptr;
    QTextEdit* m_pExpectionText = nullptr;
    QTextEdit* m_pPrevResultText = nullptr;
    QTextEdit* m_pResultText = nullptr;
    QHBoxLayout* m_pResultBox = nullptr;
    QPushButton* m_pButtonNormal = nullptr;
    QPushButton* m_pButtonBug = nullptr;
    QPushButton* m_pButtonFault = nullptr;
    QPushButton* m_pButtonDevelop = nullptr;
    QPushButton* m_pButtonSkip = nullptr;
};
