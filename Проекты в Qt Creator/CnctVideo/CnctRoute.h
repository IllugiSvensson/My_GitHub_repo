#pragma once

#include <iostream>
#include <sstream>
#include <regex>

#include <Transport/IcmpCheck.h>

class CnctRoute
{
public:
    explicit CnctRoute();

    void routeDel(const std::string strTargetNet, const std::string strNetwork, const std::string strNetMask, const std::string strGateway);
    void routeAdd(const std::string strTargetNet, const std::string strNetwork, const std::string strNetMask, const std::string strGateway);
    bool pingRoute(const std::string strNetwork, const int iTimeout);

    void setPingCount(short cnt);
    const short &getPingCount() const;

private:
    std::string m_strCurRoute;
    short pingCount = 0;

};
