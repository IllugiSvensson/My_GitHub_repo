#pragma once

#include <CCTV/Diag/MainPluginComponent.h>

class CnctVideoDiag: public NDiag::CNDComponent
{
public:
    explicit CnctVideoDiag(const std::string strConnectionName, const nita::b_path& phDiagParent);
    void setCurrentServer(const std::string strCurServer);
    void setWorkTime(const std::string strWorkTime);

    std::string getCurrentServer() const;
    std::string getWorkTime() const;
    nita::scoped_time_meter getTimeMeter()const ;
    void resetTimeMeter();

private:
    enum enu_diag_params
    {
        e_work_time = 0,
        e_current_server,
        e_param_cnt
    };

    std::string m_strCurrentServer;
    std::string m_strWorkTime;
    nita::scoped_time_meter m_TimeMeter;

    int NDGetValuesCount() const final;
    void NDGetValue(NDiag::ENU_QUERY eQueryType, DWORD uParamID, std::string& strValue) final;

    std::string getParamName(enu_diag_params eParam) const;
    std::string getParamValue(enu_diag_params eParam) const;

};
