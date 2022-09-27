#!/bin/bash

function builder {

    cp /home/tst/NitaGit/httpN/Setup_Linux /home/tst/GetStand/Install/Setup_Linux_$1.sh
	sed -i "s/Setup_Linux/Setup_Linux_$1.bin/" /home/tst/GetStand/Install/Setup_Linux_$1.sh
	sed -i "s/httpN_Linux/httpN_Linux_$1.bin/" /home/tst/GetStand/Install/Setup_Linux_$1.sh
	shc -f /home/tst/GetStand/Install/Setup_Linux_$1.sh -r -e 01/01/2050 -o /home/tst/GetStand/Install/Setup_Linux_$1.bin
	rm /home/tst/GetStand/Install/Setup_Linux_$1.sh /home/tst/GetStand/Install/Setup_Linux_$1.sh.x.c

    cp /home/tst/NitaGit/httpN/httpN_Linux /home/tst/GetStand/App/httpN/httpN_Linux_$1.sh
	sed -i "s/httpN_Linux/httpN_Linux_$1.bin/" /home/tst/GetStand/App/httpN/httpN_Linux_$1.sh
	shc -f /home/tst/GetStand/App/httpN/httpN_Linux_$1.sh -r -e 01/01/2050  -o /home/tst/GetStand/App/httpN/httpN_Linux_$1.bin
	rm /home/tst/GetStand/App/httpN/httpN_Linux_$1.sh /home/tst/GetStand/App/httpN/httpN_Linux_$1.sh.x.c

    cp /home/tst/NitaGit/httpN/httpN_linux_lib /home/tst/GetStand/App/httpN/system/httpN_linux_lib
	cp /home/tst/NitaGit/httpN/httpN_linux_module.py /home/tst/GetStand/App/httpN/system/python/httpN_linux_module.py

}


if [ -n "`cat /etc/redhat-release 2>/dev/null | grep 8.*`" ]
then

	builder "el8"

elif [ -n "`cat /etc/redhat-release 2>/dev/null | grep 7.*`" ]
then

	builder "el7"

elif [ -n "`cat /etc/astra_version 2>/dev/null | grep 1.6`" ]
then

	builder "a16"

else

    echo "other"

fi
