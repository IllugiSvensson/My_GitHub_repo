#include "include/TestMapViewer.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    initGUI();
    buildGUI();
    setGUIParameters();
    setWidgetConnections();
}

void MainWindow::initGUI() noexcept
{
    m_pMainWidget = new QWidget(this);
    m_pMainLayout = new QGridLayout();
    m_pRadioButtonLayout = new QGridLayout();
    m_pVerticalLayout = new QVBoxLayout();
    m_pToolBar = new QToolBar(this);
    m_pTestMapTrees = new QTreeWidget(this);
    m_pTestObjectLabel = new QLineEdit(this);
    m_pUsecaseText = new QTextEdit(this);
    m_pExpectionText = new QTextEdit(this);
    m_pPrevResultText = new QTextEdit(this);
    m_pResultText = new QTextEdit(this);
    m_pRadioAndIconBox = new QGroupBox(this);
    m_pRadioButtonNormal = new QRadioButton(this);
    m_pRadioButtonBug = new QRadioButton(this);
    m_pRadioButtonFault = new QRadioButton(this);
    m_pRadioButtonDevelop = new QRadioButton(this);
    m_pRadioButtonSkip = new QRadioButton(this);
    m_pIconRadioNormal = new QLabel(this);
    m_pIconRadioBug = new QLabel(this);
    m_pIconRadioFault = new QLabel(this);
    m_pIconRadioDevelop = new QLabel(this);
    m_pIconRadioSkip = new QLabel(this);
    m_pSaveTestButton = new QPushButton(this);
}

void MainWindow::buildGUI() noexcept
{
    setCentralWidget(m_pMainWidget);
    m_pMainWidget->setLayout(m_pMainLayout);

    m_pToolBar = addToolBar("MainToolBar");

    m_pMainLayout->addWidget(m_pTestMapTrees, 0, 0, 5, 1);
    m_pMainLayout->addWidget(m_pTestObjectLabel, 0, 1, 1, 1);
    m_pMainLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Сценарий проверки"), this), 1, 1, 1, 1);
    m_pMainLayout->addWidget(m_pUsecaseText, 2, 1, 1, 1);
    m_pMainLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Ожидаемый результат"), this), 3, 1, 1, 1);
    m_pMainLayout->addWidget(m_pExpectionText, 4, 1, 1, 1);

    m_pVerticalLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Предыдущий результат"), this));
    m_pVerticalLayout->addWidget(m_pPrevResultText);

    buildRadioAndIconBox();

    m_pVerticalLayout->addWidget(m_pRadioAndIconBox);
    m_pVerticalLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Результат/тикет"), this));
    m_pVerticalLayout->addWidget(m_pResultText);
    m_pVerticalLayout->addWidget(m_pSaveTestButton);

    m_pMainLayout->addLayout(m_pVerticalLayout, 0, 2, 5, 1);
}

void MainWindow::buildRadioAndIconBox() noexcept
{
    m_pRadioButtonLayout->addWidget(m_pIconRadioNormal, 0, 0, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pIconRadioBug, 0, 1, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pIconRadioFault, 0, 2, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pIconRadioDevelop, 0, 3, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pIconRadioSkip, 0, 4, 1, 1);

    m_pRadioButtonLayout->addWidget(m_pRadioButtonNormal, 1, 0, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pRadioButtonBug, 1, 1, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pRadioButtonFault, 1, 2, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pRadioButtonDevelop, 1, 3, 1, 1);
    m_pRadioButtonLayout->addWidget(m_pRadioButtonSkip, 1, 4, 1, 1);

    m_pIconRadioNormal->setPixmap(QPixmap(":/icons/resources/IconRadioNormal.png"));
    m_pIconRadioBug->setPixmap(QPixmap(":/icons/resources/IconRadioBug.png"));
    m_pIconRadioFault->setPixmap(QPixmap(":/icons/resources/IconRadioFault.png"));
    m_pIconRadioDevelop->setPixmap(QPixmap(":/icons/resources/IconRadioDevelop.png"));
    m_pIconRadioSkip->setPixmap(QPixmap(":/icons/resources/IconRadioSkip.png"));

    m_pRadioAndIconBox->setLayout(m_pRadioButtonLayout);
}

void MainWindow::setGUIParameters() noexcept
{
    m_pMainLayout->setHorizontalSpacing(25);
    m_pToolBar->setMovable(false);
    m_pOpenTestMap = m_pToolBar->addAction(nita::convert_cp1251_string_to_unicode("Открыть"));
    m_pCreateNewTestMap = m_pToolBar->addAction(nita::convert_cp1251_string_to_unicode("Создать"));

    m_pTestMapTrees->setHeaderLabel(nita::convert_cp1251_string_to_unicode("Список Карт Тестирования"));

    m_pTestObjectLabel->setText(nita::convert_cp1251_string_to_unicode("Что проверяем?"));
    m_pTestObjectLabel->setReadOnly(true);

    m_pUsecaseText->setReadOnly(true);
    m_pExpectionText->setReadOnly(true);
    m_pPrevResultText->setReadOnly(true);

    m_pRadioButtonLayout->setAlignment(Qt::AlignCenter);
    m_pRadioButtonLayout->setHorizontalSpacing(35);
    m_pRadioButtonSkip->setChecked(true);

    m_pSaveTestButton->setText(nita::convert_cp1251_string_to_unicode("Сохранить"));
    m_pSaveTestButton->setEnabled(false);
}

void MainWindow::setWidgetConnections() noexcept
{
    connect(m_pOpenTestMap, &QAction::triggered, this, &MainWindow::openTestMapButtonClicked);
    connect(m_pTestMapTrees, &QTreeWidget::itemClicked, this, &MainWindow::readPickedTest);
//    connect(createTestMap, &QAction::triggered, this, &MainWindow::createNewTestMap);

//    connect(saveTestButton, &QPushButton::clicked, this, &MainWindow::saveCurrentTest);
}

void MainWindow::openTestMapButtonClicked() noexcept
{
    FileSystem* FileSystemWindow = new FileSystem(nullptr, true);
    connect(FileSystemWindow, SIGNAL(approveButtonWasClicked(std::string)), this, SLOT(buildTestMapTree(const std::string)));
    FileSystemWindow->setAttribute(Qt::WA_DeleteOnClose);
    FileSystemWindow->setWindowModality(Qt::ApplicationModal);
    FileSystemWindow->show();
}

void MainWindow::buildTestMapTree(const std::string& c_strPathToXml)
{
    try
    {
        if (!m_XmlTree.Proxy.load(c_strPathToXml))
            throw 1;
    }
    catch (int PathException)
    {
        std::cout << "TestMap not found or has error in it" << std::endl;
        std::exit(1);
    }

    registry::CNode nodeXmlRoot(&m_XmlTree.Proxy);
    m_XmlTree.pRootElement = new QTreeWidgetItem();
    m_XmlTree.pRootElement->setText(0, QFileInfo(QString::fromStdString(c_strPathToXml)).fileName());

    m_XmlTree.nodeTestObjects = nodeXmlRoot.getSubNode("TestObjects");
    m_XmlTree.nodeTestObjects.getSubNodeNames(m_XmlTree.vTestObjects);
    readTestObjects(m_XmlTree.nodeTestObjects);

    m_pTestMapTrees->addTopLevelItem(m_XmlTree.pRootElement);
    m_pTestMapTrees->expandAll();
}

void MainWindow::readTestObjects(registry::CNode nodeTestObjects) noexcept
{
    for (int i = 0; i < nodeTestObjects.getSubNodeCount(); i++)
    {
        m_XmlTree.pCurrentTestObjectItem = new QTreeWidgetItem(m_XmlTree.pRootElement);
        m_XmlTree.pCurrentTestObjectItem->setText(0, nita::convert_cp1251_string_to_unicode(m_XmlTree.vTestObjects.at(i)));
        m_XmlTree.TestObjectItems.append(m_XmlTree.pCurrentTestObjectItem);

        m_XmlTree.nodeTestNames = m_XmlTree.nodeTestObjects.getSubNode(i);
        m_XmlTree.nodeTestNames.getSubNodeNames(m_XmlTree.vTestNames);
        readTestNames(m_XmlTree.nodeTestNames);

        m_pTestMapTrees->addTopLevelItems(m_XmlTree.TestObjectItems);
    }
}

void MainWindow::readTestNames(registry::CNode nodeTestNames) noexcept
{
    for (int i = 0; i < nodeTestNames.getSubNodeCount(); i++)
    {
        m_XmlTree.pCurrentTestNameItem = new QTreeWidgetItem(m_XmlTree.pCurrentTestObjectItem);
        m_XmlTree.pCurrentTestNameItem->setText(0, QString::fromStdString(m_XmlTree.vTestNames.at(i)));
        m_XmlTree.pCurrentTestNameItem->setBackground(0, testMapTreesPainter(nodeTestNames.getSubNode(i)));
        m_XmlTree.TestNameItems.append(m_XmlTree.pCurrentTestNameItem);

        m_pTestMapTrees->addTopLevelItems(m_XmlTree.TestNameItems);
    }
}

QBrush MainWindow::testMapTreesPainter(const registry::CNode nodeTestName) noexcept
{
    QColor Color;
    std::string strColorText;
    nodeTestName.getValue(3, strColorText);

    if (strColorText == "Normal")
        Color.setRgb(134, 218, 118);
    else if (strColorText == "Bug")
        Color.setRgb(250, 218, 94);
    else if (strColorText == "Fault")
        Color.setRgb(210, 77, 87);
    else if (strColorText == "Develop")
        Color.setRgb(134, 136, 138);
    else if (strColorText == "Skip")
        Color.setRgb(125, 186, 231);
    else
        Color.setRgb(125, 186, 231);

    QBrush Brush(Color);
    return Brush;
}

void MainWindow::readPickedTest(QTreeWidgetItem* pPickedItem) noexcept
{
    if (pPickedItem->childCount() == 0)
    {
        m_XmlTree.pCurrentTestNameItem = pPickedItem;

        std::string strTestNumber = (pPickedItem->text(0)).toStdString();
        std::string strTestName = (pPickedItem->parent())->text(0).toStdString();
        m_XmlTree.useCase = (xmlTree.Tests).getSubNode(nita::convert_unicode_to_cp1251_string(QString::fromStdString(strTestName)).c_str());
        xmlTree.useCase = xmlTree.useCase.getSubNode(strTestNumber.c_str());

        xmlTree.useCase.getValue("Usecase", testParam.Usecase);
        xmlTree.useCase.getValue("Expection", testParam.Expection);
        xmlTree.useCase.getValue("Result", testParam.Result);
        xmlTree.useCase.getValue("LastCheck", testParam.LastCheck);

        whatToCheckEdit->setText(testName.c_str());
        usecaseText->setText(nita::convert_cp1251_string_to_unicode(testParam.Usecase));
        expectedResultText->setText(nita::convert_cp1251_string_to_unicode(testParam.Expection));
        lastTestText->setText(nita::convert_cp1251_string_to_unicode(testParam.LastCheck));
        setRadioButton(testParam.Result)->setChecked(true);
        resultText->clear();
        saveTestButton->setEnabled(true);
    }
    else saveTestButton->setEnabled(false);
}

//QRadioButton* MainWindow::setRadioButton(const std::string c_strResult) noexcept
//{
//    if (c_strResult == "Normal") return testNormal;
//    else if (c_strResult == "Warning") return testWarning;
//    else if (c_strResult == "Error") return testError;
//    else if (c_strResult == "Develop") return testDevelop;
//    else if (c_strResult == "Skip") return testSkip;
//    else return nullptr;
//}

//std::string MainWindow::getRadioButton() noexcept
//{
//    int cnt = 1;
//    for (QRadioButton *i: {testNormal, testWarning, testError, testDevelop, testSkip})
//    {
//        if (i->isChecked())
//        {
//            if (cnt == 1) return "Normal";
//            else if (cnt == 2) return "Warning";
//            else if (cnt == 3) return "Error";
//            else if (cnt == 4) return "Develop";
//            else if (cnt == 5) return "Skip";
//            else return "Skip";
//        }
//        cnt++;
//    }
//    return "Skip";
//}

//void MainWindow::saveCurrentTest() noexcept
//{
//    xmlTree.useCase.setValue("LastCheck", nita::convert_unicode_to_cp1251_string(resultText->toPlainText()));
//    xmlTree.useCase.setValue("Result", getRadioButton());
//    lastTestText->setText(resultText->toPlainText());
//    resultText->clear();
//    xmlTree.child->setBackground(0, mapTreePainter(xmlTree.useCase));
//    xmlTree.Proxy.save(xmlTree.Path);
//}

//void MainWindow::createNewTestMap() noexcept
//{
//    filesystem* FSWindow = new filesystem(true);
//    connect(FSWindow, SIGNAL(approve_clicked(std::string)), this, SLOT(mapTreeBuilder(std::string)));
//    FSWindow->setAttribute(Qt::WA_DeleteOnClose);
//    FSWindow->setWindowModality(Qt::ApplicationModal);
//    FSWindow->show();
//}

MainWindow::~MainWindow()
{
}
