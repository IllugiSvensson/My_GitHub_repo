#!/bin/bash

#������ �������� - ����, �� ������� ������ ������, ������ 192.168.30/31.���
#������ �������� - ����, ������� ����� ��������

sysctl net.ipv4.ip_forward=1 #��������� ������� ���������� ���������� ������
iptables -F FORWARD #������� ������� ������ �������������

#��������� ��������� ������� �� ��� ������������� �����������
	iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#��������� �������� ���� �� ����������� � ���������
	iptables -A FORWARD -m conntrack --ctstate NEW -i $1 -j ACCEPT
#���� ��������� ���������� ������ ���������
	iptables -P FORWARD DROP 
#������� ������� ������ POSTROUTING ������� nat
	iptables -t nat -F POSTROUTING
#�������� ���� ���������� ������
	iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE

#��� ����, ����� ��������, ����� �������� � ����������
#��� ����� ���������� ������� � /soft/etc/{OBJ}/
#������� ���� rc.nita (������� ���� �����������) � �������/��������� ���������

# Only LOAD functions on boot
#function StartingWS()
#{
#	case "$MYHOST" in
#		HOSTNAME)								#HOSTNAME - ������ � /soft/HOSTNAME
#			/soft/scripts/GWroute.sh eth? eth?	#���������� ������ eth
#			;;

#}

#���� ���� ����������, ������� ����� � ������� ������� �������, ������ eth
#���� ���� ��� ����, ����� ���� ���� ���� � ������� ������ � ��������� eth
					#���� ��������� ���, ������� ���� case �� ����� ����������
#�� �������� ����������������� ������ :)