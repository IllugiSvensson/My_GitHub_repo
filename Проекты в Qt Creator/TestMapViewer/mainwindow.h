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

class MainWindow : public QMainWindow
{
    Q_OBJECT

private:
    QMenu *menu;
    QAction *openTest, *createTest, *editTest;
    QWidget *mainWidget;
    QGridLayout *layout, *boxLayout;
    QTreeWidget *testMapTree;
    QLineEdit *whatToCheckEdit;
    QLabel *currentTestMap, *scenarioLabel, *expectedResultLabel, *resultLabel;
    QTextEdit *scenarioText, *expectedResultText, *resultText;
    QGroupBox *testResultBox;
    QRadioButton *testNormal, *testWarning, *testError, *testDevelop, *testSkip;

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void enableEditing();
};

