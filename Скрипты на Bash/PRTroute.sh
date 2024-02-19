#!/bin/bash

sysctl net.ipv4.ip_forward=1	#��������� ������� ���������� ���������� ������
iptables -F FORWARD 			#������� ������� ������ �������������

EXT_IP="" 		#����� ����� �������, ������ 192.168.31...
INT_IP=""		#����� ����� ����������

EXT_IF="" 		#��������� ��������� ���� ����� 
INT_IF=""		#��������� ������� ���� �����

FAKE_PORT=$1	#���� �����, � �������� ���������� �� ���
LAN_IP=$2		#����� ���������� � ����, ������� ���� ������������ � FAKE_PORT
SRV_PORT=$3		#FAKE_PORT ����� ���� ����� ���������, SRV_PORT 5900 ��� VNC, 22 ��� ����������



iptables -t nat -A PREROUTING -d $EXT_IP -p tcp -m tcp --dport $FAKE_PORT -j DNAT --to-destination $LAN_IP:$SRV_PORT

iptables -t nat -A POSTROUTING -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j SNAT --to-source $INT_IP

iptables -t nat -A OUTPUT -d $EXT_IP -p tcp -m tcp --dport $SRV_PORT -j DNAT --to-destination $LAN_IP

iptables -I FORWARD 1 -i $EXT_IF -o $INT_IF -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j ACCEPT
