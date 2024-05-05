#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    menu = menuBar()->addMenu("Actions");
    openTest = menu->addAction("Open");
    createTest = menu->addAction("Create");
    editTest = menu->addAction("Editable");
    editTest->setCheckable(true);

    layout = new QGridLayout(this);
    currentTestMap = new QLabel(this);
    testMapTree = new QTreeWidget(this);
    whatToCheckEdit = new QLineEdit(this);
    scenarioLabel = new QLabel("Scenario", this);
    scenarioText = new QTextEdit(this);
    expectedResultLabel = new QLabel("Expected Result", this);
    expectedResultText = new QTextEdit(this);
    boxLayout = new QGridLayout(this);
    testResultBox = new QGroupBox(this);
    testNormal = new QRadioButton(this);
    testWarning = new QRadioButton(this);
    testError = new QRadioButton(this);
    testDevelop = new QRadioButton(this);
    testSkip = new QRadioButton(this);
    resultLabel = new QLabel("Comment", this);
    resultText = new QTextEdit(this);

    layout->addWidget(currentTestMap, 0, 0, 1, 1);
    currentTestMap->setText("TestMap.xml");
    layout->addWidget(testMapTree, 1, 0, 7, 1);
    testMapTree->setHeaderLabel("Test List");
    layout->setHorizontalSpacing(25);
    layout->addWidget(whatToCheckEdit, 0, 1, 1, 1);
    whatToCheckEdit->setText("What to check?");
    whatToCheckEdit->setEnabled(false);
    layout->addWidget(scenarioLabel, 1, 1, 1, 1);
    layout->addWidget(scenarioText, 2, 1, 1, 1);
    scenarioText->setEnabled(false);
    layout->addWidget(expectedResultLabel, 3, 1, 1, 1);
    layout->addWidget(expectedResultText, 4, 1, 1, 1);
    expectedResultText->setEnabled(false);
    boxLayout->setAlignment(Qt::AlignCenter);
    boxLayout->setHorizontalSpacing(35);
    boxLayout->addWidget(new QLabel("✅", this), 0, 0, 1, 1);
    boxLayout->addWidget(testNormal, 1, 0, 1, 1);
    boxLayout->addWidget(new QLabel("⚠️", this), 0, 1, 1, 1);
    boxLayout->addWidget(testWarning, 1, 1, 1, 1);
    boxLayout->addWidget(new QLabel("🐞", this), 0, 2, 1, 1);
    boxLayout->addWidget(testError, 1, 2, 1, 1);
    boxLayout->addWidget(new QLabel("🛠", this), 0, 3, 1, 1);
    boxLayout->addWidget(testDevelop, 1, 3, 1, 1);
    boxLayout->addWidget(new QLabel("🅿️", this), 0, 4, 1, 1);
    boxLayout->addWidget(testSkip, 1, 4, 1, 1);
    testSkip->setChecked(true);
    testResultBox->setLayout(boxLayout);
    layout->addWidget(testResultBox, 5, 1, 1, 1);
    layout->addWidget(resultLabel, 6, 1, 1, 1);
    layout->addWidget(resultText, 7, 1, 1, 1);

    mainWidget = new QWidget(this);
    mainWidget->setLayout(layout);
    setCentralWidget(mainWidget);

    connect(editTest, &QAction::toggled, this, &MainWindow::enableEditing);

}

void MainWindow::enableEditing()
{
    if (editTest->isChecked())
    {
        whatToCheckEdit->setEnabled(true);
        scenarioText->setEnabled(true);
        expectedResultText->setEnabled(true);
    } else {
        whatToCheckEdit->setEnabled(false);
        scenarioText->setEnabled(false);
        expectedResultText->setEnabled(false);
    }

}

MainWindow::~MainWindow()
{
}

