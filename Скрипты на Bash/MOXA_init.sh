#!/bin/sh
#������ ������������ ��� ������������� ��������� � ������ MOXA ������ cp 114/118
#��� ���������� ����� �������� � ������������ ��� ����������� �����

mount -n -w -o remount /

cd /data/moxa/mxser/		#������������� ��, ���� ��� ���
    ./mxinstall

cd /data/moxa/mxser/driver/	#������������� ������� �� ���������
    yes '' | ./msmknod
    
cd /data/moxa/mxser/utility/conf/

    for port in {0,4}		#������ ��������� ������
	do
	    ./muestty -i RS4854W /dev/ttyMUE$port
	    ./muestty -t NONTERM /dev/ttyMUE$port
	done

    for port in {1,2,5,6}
	do
	    ./muestty -i RS422 /dev/ttyMUE$port
	    ./muestty -t NONTERM /dev/ttyMUE$port
	done
