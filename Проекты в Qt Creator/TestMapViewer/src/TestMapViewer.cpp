#include "include/TestMapViewer.h"

TestMapViewer::TestMapViewer(QWidget *parent)
    : QMainWindow(parent)
{
    initGUI();
    buildGUI();
    setGUIParameters();
    setWidgetConnections();
}

void TestMapViewer::initGUI() noexcept
{
    m_pToolBar = new QToolBar(this);
    m_pTestLevelCombo = new QComboBox(this);
    m_pFontSizeCombo = new QComboBox(this);

    m_pMainWidget = new QWidget(this);
    m_pMainLayout = new QGridLayout();
    m_pTestMapTrees = new QTreeWidget(this);
    m_pUsecaseText = new QTextEdit(this);
    m_pExpectionText = new QTextEdit(this);
    m_pPrevResultText = new QTextEdit(this);
    m_pResultText = new QTextEdit(this);
    m_pResultBox = new QHBoxLayout();
    m_pButtonNormal = new QPushButton(this);
    m_pButtonBug = new QPushButton(this);
    m_pButtonFault = new QPushButton(this);
    m_pButtonDevelop = new QPushButton(this);
    m_pButtonSkip = new QPushButton(this);
}

void TestMapViewer::buildGUI() noexcept
{
    m_pToolBar = addToolBar("MainToolBar");
    m_pOpenTestMap = m_pToolBar->addAction(nita::convert_cp1251_string_to_unicode("Открыть"));
    m_pCreateNewTestMap = m_pToolBar->addAction(nita::convert_cp1251_string_to_unicode("Создать"));
    m_pRecordScreen = m_pToolBar->addAction(nita::convert_cp1251_string_to_unicode("Записать"));
    m_pToolBar->addWidget(m_pTestLevelCombo);
    m_pToolBar->addWidget(m_pFontSizeCombo);

    setCentralWidget(m_pMainWidget);
    m_pMainWidget->setLayout(m_pMainLayout);
    m_pMainLayout->addWidget(m_pTestMapTrees, 0, 0, 6, 3);

    m_pMainLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Сценарий проверки"), this), 0, 3, 1, 3);
    m_pMainLayout->addWidget(m_pUsecaseText, 1, 3, 1, 3);
    m_pMainLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Ожидаемый результат"), this), 2, 3, 1, 3);
    m_pMainLayout->addWidget(m_pExpectionText, 3, 3, 3, 3);

    m_pMainLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Предыдущий результат"), this), 0, 6, 1, 2);
    m_pMainLayout->addWidget(m_pPrevResultText, 1, 6, 1, 2);
    m_pMainLayout->addWidget(new QLabel(nita::convert_cp1251_string_to_unicode("Результат/тикет"), this), 2, 6, 1, 2);
    m_pMainLayout->addWidget(m_pResultText, 3, 6, 1, 2);

    buildResultButtons();
}

void TestMapViewer::buildResultButtons() noexcept
{
    m_pResultBox->addWidget(m_pButtonNormal);
    m_pResultBox->addWidget(m_pButtonBug);
    m_pResultBox->addWidget(m_pButtonFault);
    m_pResultBox->addWidget(m_pButtonDevelop);
    m_pResultBox->addWidget(m_pButtonSkip);

    m_pButtonNormal->setIcon(QIcon(":/icons/resources/IconRadioNormal.png"));
    m_pButtonBug->setIcon(QIcon(":/icons/resources/IconRadioBug.png"));
    m_pButtonFault->setIcon(QIcon(":/icons/resources/IconRadioFault.png"));
    m_pButtonDevelop->setIcon(QIcon(":/icons/resources/IconRadioDevelop.png"));
    m_pButtonSkip->setIcon(QIcon(":/icons/resources/IconRadioSkip.png"));

    m_pButtonNormal->setMinimumSize(50, 50);
    m_pButtonBug->setMinimumSize(50, 50);
    m_pButtonFault->setMinimumSize(50, 50);
    m_pButtonDevelop->setMinimumSize(50, 50);
    m_pButtonSkip->setMinimumSize(50, 50);

    m_pMainLayout->addLayout(m_pResultBox, 4, 6, 2, 2);
}

void TestMapViewer::setGUIParameters() noexcept
{
    m_pToolBar->setMovable(false);
    QStringList TestLevelList = {"Base", "Normal", "Full", "Advance"};
    QStringList FontSizeList = {"11", "14", "16", "18", "20"};
    m_pTestLevelCombo->addItems(TestLevelList);
    m_pFontSizeCombo->addItems(FontSizeList);

    m_pTestMapTrees->setHeaderLabel(nita::convert_cp1251_string_to_unicode("Список Карт Тестирования"));

    m_pUsecaseText->setReadOnly(true);
    m_pExpectionText->setReadOnly(true);
    m_pPrevResultText->setReadOnly(true);
    blockUnblockResultButtons(false);

    m_pResultBox->setAlignment(Qt::AlignCenter);
    m_pResultBox->setSpacing(5);
    m_pMainLayout->setHorizontalSpacing(25);
}

void TestMapViewer::blockUnblockResultButtons(const bool bBlock) noexcept
{
    m_pButtonNormal->setEnabled(bBlock);
    m_pButtonBug->setEnabled(bBlock);
    m_pButtonFault->setEnabled(bBlock);
    m_pButtonDevelop->setEnabled(bBlock);
    m_pButtonSkip->setEnabled(bBlock);
}

void TestMapViewer::setWidgetConnections() noexcept
{
    connect(m_pFontSizeCombo, &QComboBox::textActivated, this, &TestMapViewer::switchFontSize);
//    connect(m_pTestLevelCombo, &QComboBox::textActivated, this, &TestMapViewer::setTestLevel);
//    connect(m_pOpenTestMap, &QAction::triggered, this, &TestMapViewer::openTestMap);
//    connect(m_pCreateNewTestMap, &QAction::triggered, this, &TestMapViewer::closeTestMap);
//    connect(m_pRecordScreen, &QAction::triggered, this, &TestMapViewer::recordScreen);

//    connect(m_pTestMapTrees, &QTreeWidget::itemSelectionChanged, this, &TestMapViewer::readPickedTest);

//    connect(m_pButtonNormal, &QPushButton::clicked, this, &TestMapViewer::saveCurrentTest);
//    connect(m_pButtonBug, &QPushButton::clicked, this, &TestMapViewer::saveCurrentTest);
//    connect(m_pButtonFault, &QPushButton::clicked, this, &TestMapViewer::saveCurrentTest);
//    connect(m_pButtonDevelop, &QPushButton::clicked, this, &TestMapViewer::saveCurrentTest);
//    connect(m_pButtonSkip, &QPushButton::clicked, this, &TestMapViewer::saveCurrentTest);
}

void TestMapViewer::switchFontSize(const QString& crPickedFontSize) noexcept
{
    QFont FontSize;
    FontSize.setPointSize(crPickedFontSize.toInt());
    m_pToolBar->setFont(FontSize);
    m_pMainWidget->setFont(FontSize);
    QSize iSize(crPickedFontSize.toInt() * 5, crPickedFontSize.toInt() * 5);
    m_pButtonNormal->setIconSize(iSize);
    m_pButtonBug->setIconSize(iSize);
    m_pButtonFault->setIconSize(iSize);
    m_pButtonDevelop->setIconSize(iSize);
    m_pButtonSkip->setIconSize(iSize);
}

//void TestMapViewer::openTestMap() noexcept
//{
//    FileSystem* pFileSystemWindow = new FileSystem(nullptr, true, m_pFontSizeCombo->currentText());
//    connect(pFileSystemWindow, &FileSystem::approveButtonWasClicked, this, &TestMapViewer::buildTestMapTree);
//    pFileSystemWindow->setAttribute(Qt::WA_DeleteOnClose);
//    pFileSystemWindow->setWindowModality(Qt::ApplicationModal);
//    pFileSystemWindow->show();
//}

//void TestMapViewer::buildTestMapTree(const std::string& crPathToXml)
//{
//    try
//    {
//        if (!m_XmlTree.Proxy.load(crPathToXml))
//            throw 1;
//    }
//    catch (int PathException)
//    {
//        std::cout << "TestMap not found or has error in it" << std::endl;
//        std::exit(PathException);
//    }

//    m_XmlTree.strPathToXml = crPathToXml;
//    registry::CNode nodeXmlRoot(&m_XmlTree.Proxy);
//    m_XmlTree.pRootElement = new QTreeWidgetItem();
//    m_XmlTree.pRootElement->setText(0, QFileInfo(QString::fromStdString(crPathToXml)).fileName());

//    m_XmlTree.nodeTestObjects = nodeXmlRoot.getSubNode("TestObjects");
//    m_XmlTree.nodeTestObjects.getSubNodeNames(m_XmlTree.vTestObjects);
//    readTestObjects(m_XmlTree.nodeTestObjects);

//    m_pTestMapTrees->addTopLevelItem(m_XmlTree.pRootElement);
//    m_pTestMapTrees->expandAll();
//}

//void TestMapViewer::readTestObjects(registry::CNode& nodeTestObjects) noexcept
//{
//    for (int i = 0; i < nodeTestObjects.getSubNodeCount(); i++)
//    {
//        m_XmlTree.pCurrentTestObjectItem = new QTreeWidgetItem(m_XmlTree.pRootElement);
//        m_XmlTree.pCurrentTestObjectItem->setText(0, nita::convert_cp1251_string_to_unicode(m_XmlTree.vTestObjects.at(i)));
//        m_XmlTree.TestObjectItems.append(m_XmlTree.pCurrentTestObjectItem);

//        m_XmlTree.nodeTestNames = m_XmlTree.nodeTestObjects.getSubNode(i);
//        m_XmlTree.nodeTestNames.getSubNodeNames(m_XmlTree.vTestNames);
//        readTestNames(m_XmlTree.nodeTestNames);

//        m_pTestMapTrees->addTopLevelItems(m_XmlTree.TestObjectItems);
//    }
//}

//void TestMapViewer::readTestNames(registry::CNode& nodeTestNames) noexcept
//{
//    for (int i = 0; i < nodeTestNames.getSubNodeCount(); i++)
//    {
//        if (getTestLevel(nodeTestNames.getSubNode(i)) <= m_pTestLevelCombo->currentIndex())
//        {
//            m_XmlTree.pCurrentTestNameItem = new QTreeWidgetItem(m_XmlTree.pCurrentTestObjectItem);
//            m_XmlTree.pCurrentTestNameItem->setText(0, nita::convert_cp1251_string_to_unicode(m_XmlTree.vTestNames.at(i)));
//            m_XmlTree.pCurrentTestNameItem->setBackground(0, paintTestMapTrees(nodeTestNames.getSubNode(i)));
//            m_XmlTree.TestNameItems.append(m_XmlTree.pCurrentTestNameItem);

//            m_pTestMapTrees->addTopLevelItems(m_XmlTree.TestNameItems);
//        }
//        else
//            continue;
//    }
//}

//int TestMapViewer::getTestLevel(const registry::CNode& nodeTestLevel) noexcept
//{
//    std::string strTestLevel;
//    nodeTestLevel.getValue(0, strTestLevel);
//    if (strTestLevel == "Base")
//        return 0;
//    else if (strTestLevel == "Normal")
//        return 1;
//    else if (strTestLevel == "Full")
//        return 2;
//    else if (strTestLevel == "Advance")
//        return 3;
//    else
//        return 3;
//}

//QBrush TestMapViewer::paintTestMapTrees(const registry::CNode& nodeTestName) noexcept
//{
//    QColor Color;
//    std::string strColorText;
//    nodeTestName.getValue(4, strColorText);

//    if (strColorText == "Normal")
//        Color.setRgb(146, 189, 108);
//    else if (strColorText == "Bug")
//        Color.setRgb(255, 255, 85);
//    else if (strColorText == "Fault")
//        Color.setRgb(225, 127, 127);
//    else if (strColorText == "Develop")
//        Color.setRgb(170, 170, 170);
//    else if (strColorText == "Skip")
//        Color.setRgb(0, 0, 0, 0);
//    else
//        Color.setRgb(0, 0, 0, 0);

//    QBrush Brush(Color);
//    return Brush;
//}

//void TestMapViewer::readPickedTest() noexcept
//{
//    QTreeWidgetItem* pPickedItem;
//    pPickedItem = m_pTestMapTrees->currentItem();
//    if (pPickedItem->childCount() == 0)
//    {
//        m_XmlTree.pCurrentTestNameItem = pPickedItem;

//        std::string strTestNumber = (pPickedItem->text(0)).toStdString();
//        std::string strTestName = (pPickedItem->parent())->text(0).toStdString();
//        m_XmlTree.nodeTestNames = (m_XmlTree.nodeTestObjects).
//                getSubNode(nita::convert_unicode_to_cp1251_string(QString::fromStdString(strTestName)).c_str());
//        m_XmlTree.nodeTestNames = m_XmlTree.nodeTestNames.
//                getSubNode(nita::convert_unicode_to_cp1251_string(QString::fromStdString(strTestNumber)).c_str());

//        m_XmlTree.nodeTestNames.getValue("UseCase", m_XmlTree.TstParams.strUsecase);
//        m_XmlTree.nodeTestNames.getValue("Expection", m_XmlTree.TstParams.strExpection);
//        m_XmlTree.nodeTestNames.getValue("PrevResult", m_XmlTree.TstParams.strPrevresult);
//        m_XmlTree.nodeTestNames.getValue("Result", m_XmlTree.TstParams.strResult);

//        m_pUsecaseText->setText(nita::convert_cp1251_string_to_unicode(m_XmlTree.TstParams.strUsecase));
//        m_pExpectionText->setText(nita::convert_cp1251_string_to_unicode(m_XmlTree.TstParams.strExpection));
//        m_pPrevResultText->setText(nita::convert_cp1251_string_to_unicode(m_XmlTree.TstParams.strPrevresult));

//        m_pResultText->clear();
//        blockUnblockResultButtons(true);
//    }
//    else
//        blockUnblockResultButtons(false);
//}

//void TestMapViewer::saveCurrentTest() noexcept
//{
//    QString TextFromResultTextBox = m_pResultText->toPlainText();
//    std::string strButtonText = getButtonText();
//    std::string strTestTime = to_simple_string(boost::posix_time::second_clock::local_time());
//    std::string ConvertedText = "";
//    if (!TextFromResultTextBox.isEmpty())
//        ConvertedText = strTestTime + "\n" + TextFromResultTextBox.toStdString();
//    else
//        ConvertedText = strTestTime + "\n" + strButtonText;

//    m_XmlTree.nodeTestNames.setValue("PrevResult", nita::convert_utf8_to_cp1251_qt(ConvertedText));
//    m_XmlTree.nodeTestNames.setValue("Result", strButtonText);

//    m_pPrevResultText->setText(QString::fromStdString(ConvertedText));
//    m_pResultText->clear();
//    m_XmlTree.pCurrentTestNameItem->setBackground(0, paintTestMapTrees(m_XmlTree.nodeTestNames));

//    m_XmlTree.Proxy.save(m_XmlTree.strPathToXml);
//}

//std::string TestMapViewer::getButtonText() noexcept
//{
//    if (sender() == m_pButtonNormal)
//        return "Normal";
//    else if (sender() == m_pButtonBug)
//        return "Bug";
//    else if (sender() == m_pButtonFault)
//        return "Fault";
//    else if (sender() == m_pButtonDevelop)
//        return "Develop";
//    else if (sender() == m_pButtonSkip)
//        return "Skip";
//    else
//        return "Skip";
//}

//void TestMapViewer::setTestLevel() noexcept
//{
//    closeTestMap();
//    buildTestMapTree(m_XmlTree.strPathToXml);
//}

//void TestMapViewer::closeTestMap() noexcept
//{
//    m_pTestMapTrees->clear();
//    m_XmlTree.pRootElement = nullptr;
//    m_XmlTree.TestObjectItems.clear();
//    m_XmlTree.TestNameItems.clear();
//    m_XmlTree.pCurrentTestObjectItem = nullptr;
//    m_XmlTree.pCurrentTestNameItem = nullptr;
//}

//void TestMapViewer::recordScreen() noexcept
//{
//    QProcess recordScreenProc;
//    recordScreenProc.setProgram("/soft/bin/utils/videograbber.bin");
//    recordScreenProc.start(QIODevice::ExistingOnly);
//    if (!recordScreenProc.waitForStarted(6000000) || !recordScreenProc.waitForFinished(600000))
//        return;
//}

//void TestMapViewer::buildTestMapTree(const std::vector<std::string> c_vFullPathList)
//{
//    for (int i = 0; i < c_vFullPathList.size(); i++)
//    {
//        registry::CXMLProxy Proxy;
//        Proxy.load(c_vFullPathList.at(i));
//        registry::CNode nodeXmlRoot(&Proxy);
//        QTreeWidgetItem* pRootElement = new QTreeWidgetItem();
//        pRootElement->setText(0, QFileInfo(QString::fromStdString(c_vFullPathList.at(i))).fileName());
//        registry::CNode nodeTestObjects = nodeXmlRoot.getSubNode("TestObjects");
//        std::vector<std::string> vTestObjects;
//        nodeTestObjects.getSubNodeNames(vTestObjects);
//        readTestObjects(nodeTestObjects, pRootElement, vTestObjects);

//        m_pTestMapTrees->addTopLevelItem(pRootElement);
//        m_pTestMapTrees->expandAll();
//    }
//}

//void TestMapViewer::readTestObjects(registry::CNode nodeTestObjects, QTreeWidgetItem* pRootElement, std::vector<std::string> vTestObjects) noexcept
//{
//    for (int i = 0; i < nodeTestObjects.getSubNodeCount(); i++)
//    {
//        QTreeWidgetItem* pCurrentTestObjectItem = new QTreeWidgetItem(pRootElement);
//        pCurrentTestObjectItem->setText(0, nita::convert_cp1251_string_to_unicode(vTestObjects.at(i)));
//        QList<QTreeWidgetItem*> TestObjectItems;
//        TestObjectItems.append(pCurrentTestObjectItem);

//        registry::CNode nodeTestNames = nodeTestObjects.getSubNode(i);
//        std::vector<std::string> vTestNames;
//        nodeTestNames.getSubNodeNames(vTestNames);
//        readTestNames(nodeTestNames, pCurrentTestObjectItem, vTestNames);

//        m_pTestMapTrees->addTopLevelItems(TestObjectItems);
//    }
//}

//void TestMapViewer::readTestNames(registry::CNode nodeTestNames, QTreeWidgetItem* pCurrentTestObjectItem, std::vector<std::string> vTestNames) noexcept
//{
//    for (int i = 0; i < nodeTestNames.getSubNodeCount(); i++)
//    {
//        if (getTestLevel(nodeTestNames.getSubNode(i)) <= m_pTestLevelCombo->currentIndex())
//        {
//            QTreeWidgetItem* pCurrentTestNameItem = new QTreeWidgetItem(pCurrentTestObjectItem);
//            pCurrentTestNameItem->setText(0, nita::convert_cp1251_string_to_unicode(vTestNames.at(i)));
//            pCurrentTestNameItem->setBackground(0, paintTestMapTrees(nodeTestNames.getSubNode(i)));
//            QList<QTreeWidgetItem*> TestNameItems;
//                    TestNameItems.append(pCurrentTestNameItem);

//            m_pTestMapTrees->addTopLevelItems(TestNameItems);
//        }
//        else
//            continue;
//    }
//}

TestMapViewer::~TestMapViewer()
{
}
