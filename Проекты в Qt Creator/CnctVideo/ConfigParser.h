#pragma once

#include <string>
#include <vector>

#include "Connections.h"

class ConfigParser
{
public:
    explicit ConfigParser(const std::string &s_strPathCfg);

    const std::string &getNdiagName() const;
    const std::vector<std::string> &getServerIps() const;
    const std::vector<Connections> &getConnections() const;
    const int &getTimeout() const;

private:
    void readConfig(const std::string &s_strPathCfg);

    std::string m_sNdiagName;
    std::vector<std::string> m_vServerIps;
    std::vector<Connections> m_vConnections;
    int m_iTimeout;

};
