#pragma once

#include <QMainWindow>
#include <QMenuBar>
#include <QMenu>
#include <QGridLayout>
#include <QTreeWidget>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QTextEdit>
#include <QRadioButton>
#include <QGroupBox>
#include <QStatusBar>


class MainWindow : public QMainWindow
{
    Q_OBJECT

private:
    QMenu *menu;
    QStatusBar *statusbar;
    QAction *openTest, *createTest, *editTest;
    QWidget *mainWidget;
    QGridLayout *layout, *boxLayout;
    QVBoxLayout *vBox;
    QTreeWidget *testMapTree;
    QLineEdit *whatToCheckEdit;
    QLabel *currentTestMap;
    QTextEdit *scenarioText, *expectedResultText, *lastCheckText, *resultText;
    QGroupBox *testResultBox;
    QRadioButton *testNormal, *testWarning, *testError, *testDevelop, *testSkip;

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void enableEditing();
    void setTestStatusIcon();
};

