#!/bin/bash



if [ -n "`cat /etc/redhat-release | grep 8.*`" ]
then

    cp /home/tst/httpN/Setup_Linux /home/tst/GetStand/Install/Setup_Linux_el8.sh
	sed -i 's/Setup_Linux/Setup_Linux_el8.bin/' /home/tst/GetStand/Install/Setup_Linux_el8.sh
	sed -i 's/httpN_Linux/httpN_Linux_el8.bin/' /home/tst/GetStand/Install/Setup_Linux_el8.sh
	shc -f /home/tst/GetStand/Install/Setup_Linux_el8.sh -o /home/tst/GetStand/Install/Setup_Linux_el8.bin
	rm /home/tst/GetStand/Install/Setup_Linux_el8.sh /home/tst/GetStand/Install/Setup_Linux_el8.sh.x.c

    cp /home/tst/httpN/httpN_Linux /home/tst/GetStand/App/httpN/httpN_Linux_el8.sh
	sed -i 's/httpN_Linux/httpN_Linux_el8.bin/' /home/tst/GetStand/App/httpN/httpN_Linux_el8.sh
	shc -f /home/tst/GetStand/App/httpN/httpN_Linux_el8.sh -o /home/tst/GetStand/App/httpN/httpN_Linux_el8.bin
	rm /home/tst/GetStand/App/httpN/httpN_Linux_el8.sh /home/tst/GetStand/App/httpN/httpN_Linux_el8.sh.x.c

elif [ -n "`cat /etc/redhat-release | grep 7.*`" ]
then

    cp /home/tst/httpN/Setup_Linux /home/tst/GetStand/Install/Setup_Linux_el7.sh
	sed -i 's/Setup_Linux/Setup_Linux_el7.bin/' /home/tst/GetStand/Install/Setup_Linux_el7.sh
	sed -i 's/httpN_Linux/httpN_Linux_el7.bin/' /home/tst/GetStand/Install/Setup_Linux_el7.sh
	shc -f /home/tst/GetStand/Install/Setup_Linux_el7.sh -o /home/tst/GetStand/Install/Setup_Linux_el7.bin
	rm /home/tst/GetStand/Install/Setup_Linux_el7.sh /home/tst/GetStand/Install/Setup_Linux_el7.sh.x.c

    cp /home/tst/httpN/httpN_Linux /home/tst/GetStand/App/httpN/httpN_Linux_el7.sh
	sed -i 's/httpN_Linux/httpN_Linux_el7.bin/' /home/tst/GetStand/App/httpN/httpN_Linux_el7.sh
	shc -f /home/tst/GetStand/App/httpN/httpN_Linux_el7.sh -o /home/tst/GetStand/App/httpN/httpN_Linux_el7.bin
	rm /home/tst/GetStand/App/httpN/httpN_Linux_el7.sh /home/tst/GetStand/App/httpN/httpN_Linux_el7.sh.x.c

else

    echo "other"

fi
