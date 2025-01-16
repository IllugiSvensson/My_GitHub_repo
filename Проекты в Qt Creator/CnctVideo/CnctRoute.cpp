#include "CnctRoute.h"

CnctRoute::CnctRoute()
{

}

bool CnctRoute::pingRoute(std::string strNetwork, int iTimeout)
{
    char c_pingCount = 0;
    do
    {
        if (CheckAddressIsOn(strNetwork.c_str(), iTimeout))
            return true;
        c_pingCount++;
    } while (c_pingCount < 3);
    return false;
}

void CnctRoute::routeAdd(std::string strTargetNet, std::string strNetwork, std::string strNetMask, std::string strGateway)
{
    std::ostringstream ossRes;
    ossRes << "route add -net " << strTargetNet << " netmask " << strNetMask << " gateway " << strGateway;
    m_strCurRoute = ossRes.str();
    system(m_strCurRoute.c_str());
}

void CnctRoute::routeDel(std::string strTargetNet, std::string strNetwork, std::string strNetMask, std::string strGateway)
{
    std::ostringstream ossRes;
    ossRes << "route del -net " << strTargetNet << " netmask " << strNetMask << " gateway " << strGateway;
    m_strCurRoute = ossRes.str();
    system(m_strCurRoute.c_str());
}

void CnctRoute::setPingCount(short cnt)
{
    pingCount = cnt;
}

const short &CnctRoute::getPingCount() const
{
    return pingCount;
}
