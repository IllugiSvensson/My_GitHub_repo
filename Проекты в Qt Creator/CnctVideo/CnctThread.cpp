#include "CnctThread.h"
#include "CnctRoute.h"
#include "CnctVideoDiag.h"


CnctThread::CnctThread(const ConfigParser configParser)
{
    try
    {
        for (int i = 0; i < configParser.getConnections().size(); ++i)
        {
            auto aCurConnection = configParser.getConnections().at(i);
            m_thread.push_back(std::make_shared <nita::inline_thread> ([this, configParser, aCurConnection]()
            {
                threadProc(configParser, aCurConnection.sControlMask, aCurConnection.vControlIps,
                           aCurConnection.sConnectionName, aCurConnection.sTargetNet, configParser.getTimeout());
            }, aCurConnection.sConnectionName));
        }
    }
    catch (std::out_of_range ThreadException)
    {
        std::cout << "No connection find. Check the cfg file" << std::endl;
        std::exit(2);
    }
 }

void CnctThread::threadProc(const ConfigParser &cfgParser, const std::string &s_strMask,
                            const std::vector<std::string> &s_strIps, const std::string &s_strConnectionName,
                            const std::string &s_strTargetNet, const int &s_iTimeout)
{
    CnctRoute route;
    int flag = 0;
    CnctVideoDiag VideoDiag(s_strConnectionName, "Подключение");
    std::string strIp;
    std::string strServerIp;
    while (!boost::this_thread::interruption_requested())
    {
        for (int i = 0; i < cfgParser.getServerIps().size(); ++i)
        {
            for (int j= 0; j < s_strIps.size(); ++j)
            {
                strIp = s_strIps.at(j);
                strServerIp = cfgParser.getServerIps().at(i);
                route.routeAdd(s_strTargetNet, strIp, s_strMask, strServerIp);
                while (flag != -1)
                {
                    if (!route.pingRoute(strIp, s_iTimeout))
                    {
                        route.routeDel(s_strTargetNet, strIp, s_strMask, strServerIp);
                        std::string message = "Удален маршрут через сервер ";
                        VideoDiag.NDLogMessageInf((message + strServerIp).c_str());
                        VideoDiag.resetTimeMeter();
                        route.setPingCount(route.getPingCount() + 1);
                        flag = -1;
                    }
                    else if (flag == 0)
                    {
                        VideoDiag.setCurrentServer(strServerIp);
                        flag = 1;
                        VideoDiag.NDSetStatusGood();
                        std::string message = "Установлен маршрут через сервер ";
                        VideoDiag.NDLogMessageInf((message + strServerIp).c_str());
                        route.setPingCount(0);
                    }
                    if (route.getPingCount() == 10)
                    {
                        VideoDiag.NDSetStatusError("Превышено количество попыток установить маршрут");
                    }
                    else if (route.getPingCount() == 5)
                    {
                        VideoDiag.NDSetStatusWrong("Не удается установить маршрут");
                    }

                    VideoDiag.setWorkTime(nita::time_to_str(VideoDiag.getTimeMeter().duration()));
                    boost::this_thread::sleep(boost::posix_time::milliseconds(1000));
                }
                flag = 0;
            }
        }
    }
    route.routeDel(s_strTargetNet, strIp, s_strMask, strServerIp);
    std::string message = "Удален маршрут через сервер ";
    VideoDiag.NDLogMessageInf((message + strServerIp).c_str());
}

