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
    scenarioText = new QTextEdit(this);
    expectedResultText = new QTextEdit(this);
    vBox = new QVBoxLayout(this);
    lastCheckText = new QTextEdit(this);
    boxLayout = new QGridLayout(this);
    testResultBox = new QGroupBox(this);
    testNormal = new QRadioButton(this);
    testWarning = new QRadioButton(this);
    testError = new QRadioButton(this);
    testDevelop = new QRadioButton(this);
    testSkip = new QRadioButton(this);
    resultText = new QTextEdit(this);

    currentTestMap->setText("TestMap.xml");
    layout->addWidget(testMapTree, 0, 0, 5, 1);
    testMapTree->setHeaderLabel("Test List");
    layout->setHorizontalSpacing(25);
    layout->addWidget(whatToCheckEdit, 0, 1, 1, 1);
    whatToCheckEdit->setText("What to check?");
    whatToCheckEdit->setReadOnly(true);
    layout->addWidget(new QLabel("Scenario", this), 1, 1, 1, 1);
    layout->addWidget(scenarioText, 2, 1, 1, 1);
    scenarioText->setReadOnly(true);
    layout->addWidget(new QLabel("Expected Result", this), 3, 1, 1, 1);
    layout->addWidget(expectedResultText, 4, 1, 1, 1);
    expectedResultText->setReadOnly(true);
    vBox->addWidget(new QLabel("Last check result", this));
    vBox->addWidget(lastCheckText);
    lastCheckText->setReadOnly(true);
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
    vBox->addWidget(testResultBox);
    vBox->addWidget(new QLabel("Comment", this));
    vBox->addWidget(resultText);
    layout->addLayout(vBox, 0, 2, 5, 1);

    mainWidget = new QWidget(this);
    mainWidget->setLayout(layout);
    setCentralWidget(mainWidget);

    statusbar = this->statusBar();
    statusbar->addWidget(currentTestMap);

    connect(editTest, &QAction::toggled, this, &MainWindow::enableEditing);

}

void MainWindow::enableEditing()
{
    if (editTest->isChecked())
    {
        whatToCheckEdit->setReadOnly(false);
        scenarioText->setReadOnly(false);
        expectedResultText->setReadOnly(false);
    } else {
        whatToCheckEdit->setReadOnly(true);
        scenarioText->setReadOnly(true);
        expectedResultText->setReadOnly(true);
    }

}

void MainWindow::setTestStatusIcon()
{

}

MainWindow::~MainWindow()
{
}

