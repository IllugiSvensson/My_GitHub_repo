#include <iostream>

#include <reg_12.h>
#include <regtree/SimpleProxy.h>

#include "ConfigParser.h"

ConfigParser::ConfigParser(const std::string &s_strPathCfg)
{
    readConfig(s_strPathCfg);
}

void ConfigParser::readConfig(const std::string &s_strPathCfg)
{
    registry::CXMLProxy Proxy;
    try
    {
        if (!Proxy.load(s_strPathCfg))
            throw -1;

        registry::CNode rootNode(&Proxy);
        rootNode.getValue("NdiagName", m_sNdiagName);
        rootNode.getValue("ServerIps", m_vServerIps);
        rootNode.getValue("Timeout", m_iTimeout);

        registry::CNode connections = rootNode.getSubNode("Connections");
        for (int i = 0; i < connections.getSubNodeCount(); ++i)
        {
            Connections curConnection;
            registry::CNode tmp = connections.getSubNode(i);
            tmp.getValue("Enabled", curConnection.bEnable);
            if (!curConnection.bEnable)
                continue;

            curConnection.sConnectionName = tmp.getName();
            tmp.getValue("ControlIps", curConnection.vControlIps);
            tmp.getValue("ControlMask", curConnection.sControlMask);
            tmp.getValue("TargetNet", curConnection.sTargetNet);
            m_vConnections.push_back(curConnection);
        }
    }
    catch (int CfgException)
    {
        std::cout << "Cfg not found or has error in it" << std::endl;
        std::exit(1);
    }

}

const std::string &ConfigParser::getNdiagName() const
{
    return m_sNdiagName;
}

const std::vector<std::string> &ConfigParser::getServerIps() const
{
    return m_vServerIps;
}

const std::vector<Connections> &ConfigParser::getConnections() const
{
    return m_vConnections;
}

const int &ConfigParser::getTimeout() const
{
    return m_iTimeout;
}
