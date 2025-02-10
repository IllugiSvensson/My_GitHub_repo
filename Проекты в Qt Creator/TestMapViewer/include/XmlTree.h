#pragma once

#include <QTreeWidget>

#include <reg_12.h>
#include <regtree/SimpleProxy.h>

struct TestParams
{
    std::string strTestlevel = "";
    std::string strUsecase = "";
    std::string strExpection = "";
    std::string strPrevresult = "";
    std::string strResult = "";
};

struct XmlTree
{
    std::string strPathToXml;
    registry::CXMLProxy Proxy;
    QTreeWidgetItem* pRootElement = nullptr;
    registry::CNode nodeTestObjects;
    std::vector<std::string> vTestObjects;
    QList<QTreeWidgetItem*> TestObjectItems;
    registry::CNode nodeTestNames;
    std::vector<std::string> vTestNames;
    QList<QTreeWidgetItem*> TestNameItems;
    TestParams TstParams;
    QTreeWidgetItem* pCurrentTestObjectItem;
    QTreeWidgetItem* pCurrentTestNameItem;
};
