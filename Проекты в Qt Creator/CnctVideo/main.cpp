#include "ConfigParser.h"
#include "CnctThread.h"

#include <CCTV/Diag/ScopedDiagMain.h>
#include <inline/functional/expand_path.h>

IMPLEMENT_NDIAG_MAIN()

int main()
{
    ConfigParser cfgPath("/soft/etc/" + nita::get_current_config_from_system_xml() + "/Ship/Connections/cnct_video.xml");
    cctv::ScopedDiagMain DiagMain("CnctVideo",cfgPath.getNdiagName(), false);
    CnctThread connection(cfgPath);

    while(true)
    {
        boost::this_thread::sleep(boost::posix_time::seconds(500));
    }

    return 0;
}
