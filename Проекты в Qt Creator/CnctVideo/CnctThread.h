#pragma once

#include <inline/thread/inline_thread.h>

#include "ConfigParser.h"

class CnctThread
{
public:
    explicit CnctThread(const ConfigParser configParser);

private:
    void threadProc(const ConfigParser &cfgParser, const std::string &s_strMask,
                    const std::vector<std::string> &s_strIps, const std::string &s_strConnectionName,
                    const std::string &s_strTargetNet, const int &s_iTimeout);

    std::vector <std::shared_ptr <nita::inline_thread>> m_thread;

};
