#pragma once

#include <QMainWindow>
#include <QRadioButton>
#include <QTextEdit>
#include <QGroupBox>
#include <QLabel>
#include <QToolBar>

#include <inline/translation/cp1251_conversions.h>

#include "FileSystem.h"
#include "XmlTree.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void initGUI() noexcept;
    void buildGUI() noexcept;
    void buildRadioAndIconBox() noexcept;
    void setGUIParameters() noexcept;
    void setWidgetConnections() noexcept;

    void openTestMapButtonClicked() noexcept;
    void buildTestMapTree(const std::string& c_strPathToXml);
    void readTestObjects(registry::CNode nodeTestObjects) noexcept;
    void readTestNames(registry::CNode nodeTestNames) noexcept;

    QBrush testMapTreesPainter(const registry::CNode nodeTestName) noexcept;
    void readPickedTest(QTreeWidgetItem* pPickedItem) noexcept;

//    QRadioButton* setRadioButton(const std::string c_strResult) noexcept;
//    std::string getRadioButton() noexcept;
//    void saveCurrentTest() noexcept;
//    void createNewTestMap() noexcept;

private:
    QWidget* m_pMainWidget = nullptr;
    QGridLayout* m_pMainLayout = nullptr;
    QGridLayout* m_pRadioButtonLayout = nullptr;
    QVBoxLayout* m_pVerticalLayout = nullptr;
    QToolBar* m_pToolBar = nullptr;
    QTreeWidget* m_pTestMapTrees = nullptr;
    QLineEdit* m_pTestObjectLabel = nullptr;
    QTextEdit* m_pUsecaseText = nullptr;
    QTextEdit* m_pExpectionText = nullptr;
    QTextEdit* m_pPrevResultText = nullptr;
    QTextEdit* m_pResultText = nullptr;
    QGroupBox* m_pRadioAndIconBox = nullptr;
    QRadioButton* m_pRadioButtonNormal = nullptr;
    QRadioButton* m_pRadioButtonBug = nullptr;
    QRadioButton* m_pRadioButtonFault = nullptr;
    QRadioButton* m_pRadioButtonDevelop = nullptr;
    QRadioButton* m_pRadioButtonSkip = nullptr;
    QLabel* m_pIconRadioNormal = nullptr;
    QLabel* m_pIconRadioBug = nullptr;
    QLabel* m_pIconRadioFault = nullptr;
    QLabel* m_pIconRadioDevelop = nullptr;
    QLabel* m_pIconRadioSkip = nullptr;
    QPushButton *m_pSaveTestButton = nullptr;

    QAction* m_pOpenTestMap = nullptr;
    QAction* m_pCreateNewTestMap = nullptr;

    XmlTree m_XmlTree;
};
