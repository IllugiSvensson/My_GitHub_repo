#!/bin/bash
#Проброс видеотрафика с серверов на рабочие места
#Запускается на сервере через rc.nita
#Задает таблицу маршрутизации



remount rw
sed -i "s/.net.ipv4.ip_forward=./net.ipv4.ip_forward=1/g" /etc/sysctl.conf	#Включаем поддержку форвардинга
remount ro

iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE #Маскируем рабочую
iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -j MASQUERADE #дублированнанную сеть

#Задаем адреса в зависимости от сервера
if [[ $HOSTNAME == "SRV1" ]]
then
    EXT_IP1="192.168.191.72"		#Сети, которые нужно пробросить
    EXT_IP2="192.168.199.72"
    INT_IP1="192.168.10.72"		#Сети, в которые будет направлен трафик
    INT_IP2="192.168.11.72"		#Интерфейсы определим в цикле

elif [[ $HOSTNAME == "SRV2" ]]
then
    EXT_IP1="192.168.191.74" 
    EXT_IP2="192.168.199.74"
    INT_IP1="192.168.10.74" 
    INT_IP2="192.168.11.74" 

fi

LAN_IP1="192.168.10.12"		#Целевые сети
LAN_IP2="192.168.11.12"
LAN_IP3="192.168.10.13"
LAN_IP4="192.168.11.13"

#Задаем маршруты сетей
for i in $LAN_IP1 $LAN_IP2 $LAN_IP3 $LAN_IP4		#Перебираем рабочие места
do
    for j in $INT_IP1 $INT_IP2				#Перебираем сети
    do
	if [ `echo ${i:0:10}` == `echo ${j:0:10}` ]
	then
	    for k in $EXT_IP1 $EXT_IP2
	    do
		iptables -t nat -A PREROUTING --dst $k -j DNAT --to-destination $i
		iptables -t nat -A POSTROUTING --dst $i -j SNAT --to-source $j
		iptables -t nat -A OUTPUT --dst $k -j DNAT --to-destination $i
		INT_ETH=`ip addr show | egrep $j | egrep -o 'eth[0-9]'`
		EXT_ETH=`ip addr show | egrep $k | egrep -o 'eth[0-9]'`
		iptables -I FORWARD 1 -i $EXT_ETH -o $INT_ETH -d $i -j ACCEPT

	    done
	fi
    done
done
