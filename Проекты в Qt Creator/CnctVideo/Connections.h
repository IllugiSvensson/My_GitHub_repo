#pragma once

#include <vector>
#include <string>

struct Connections
{
    std::string sConnectionName;
    bool bEnable = true;
    std::vector<std::string> vControlIps;
    std::string sControlMask;
    std::string sTargetNet;
    int iTimeout;
};
