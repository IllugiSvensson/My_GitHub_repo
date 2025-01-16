#include "CnctVideoDiag.h"


CnctVideoDiag::CnctVideoDiag(const std::string strConnectionName, const nita::b_path& phDiagParent)
{
    auto strFullDIagName = phDiagParent / strConnectionName;;
    NDSetComponentName(strFullDIagName.c_str(),strConnectionName.c_str() );
}

int CnctVideoDiag::NDGetValuesCount() const
{
    return e_param_cnt;
}

void CnctVideoDiag::NDGetValue(NDiag::ENU_QUERY eQueryType, DWORD uParamID, std::string &strValue)
{
    enu_diag_params eParamId = static_cast<enu_diag_params>(uParamID);
    if (eQueryType == NDiag::QUERY_NAME)
        strValue = getParamName(eParamId);
    else if (eQueryType == NDiag::QUERY_VALUE)
        strValue = getParamValue(eParamId);
}

std::string CnctVideoDiag::getParamName(enu_diag_params eParam) const
{
    switch(eParam)
    {
        case e_work_time:
            return "Время работы";
        case e_current_server:
            return "Текущий сервер";
        default:
            return std::string();
    }
}

std::string CnctVideoDiag::getParamValue(enu_diag_params eParam) const
{
    switch(eParam)
    {
        case e_work_time:
            return getWorkTime();
        case e_current_server:
            return getCurrentServer();
        default:
            return std::string();
    }
}

std::string CnctVideoDiag::getWorkTime() const
{
    return m_strWorkTime;
}

std::string CnctVideoDiag::getCurrentServer() const
{
    return m_strCurrentServer;
}

nita::scoped_time_meter CnctVideoDiag::getTimeMeter() const
{
    return m_TimeMeter;
}

void CnctVideoDiag::setCurrentServer(const std::string strCurServer)
{
    m_strCurrentServer = strCurServer;
}

void CnctVideoDiag::setWorkTime(const std::string strWorkTime)
{
    m_strWorkTime = strWorkTime;
}

void CnctVideoDiag::resetTimeMeter()
{
    m_TimeMeter.reset();
}
