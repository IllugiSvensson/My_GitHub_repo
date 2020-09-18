#!/bin/bash
#Проброс видеотрафика с серверов на рабочие места

remount rw
sed -i "s/.net.ipv4.ip_forward=./net.ipv4.ip_forward=1/g" /etc/sysctl.conf	#Включаем поддержку форвардинга
remount ro

iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE #Маскируем рабочую 
iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -j MASQUERADE #дублированнанную сеть

#Задаем адреса в зависимости от сервера
if [[ $HOSTNAME == "SRV1" ]]
then

    EXT_IP1="192.168.100.218"		#Сеть и интерфейс, который нужно пробросить
    EXT_IP2="192.168.199.1"

    INT_IP1="192.168.10.72"		#Сети и интерфейсы, в которые будет направлен трафик
    INT_IP2="192.168.11.72"		#Интерфейсы определим в цикле

    LAN_IP1="192.168.10.12"		#Целевые сети
    LAN_IP2="192.168.11.13"

    sed -i "s/192.168.199.2./192.168.199.25/g" /soft/etc/K23800/Granite/cctv.xml

elif [[ $HOSTNAME == "SRV2" ]]
then

    EXT_IP1="192.168.100.222" 
    EXT_IP2="192.168.199.3"

    INT_IP1="192.168.10.74" 
    INT_IP2="192.168.11.74" 

    LAN_IP1="192.168.10.13"
    LAN_IP2="192.168.11.12"

    sed -i "s/192.168.199.2./192.168.199.26/g" /soft/etc/K23800/Granite/cctv.xml

fi

#Задаем маршруты сетей
for i in $LAN_IP1 $LAN_IP2		#Перебираем рабочие места
do

    for j in $INT_IP1 $INT_IP2		#Перебираем сети
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

    INT_IP1="192.168.100.0"
    INT_IP2="192.168.199.0"

if [[ $HOSTNAME == "KRP1" ]]
then

    LAN_IP1="192.168.10.72"
    LAN_IP2="192.168.11.74"

    sed -i "s/192.168.199.2./192.168.199.26/g" /soft/etc/K23800/Granite/cctv.xml

	for i in $INT_IP1 $INT_IP2
	do

	    for j in $LAN_IP1 $LAN_IP2
	    do

		a=`echo ${j:0:10}`
		EXT_ETH=`ip addr show | egrep $a | egrep -o 'eth[0-9]'`
		route add -net $i netmask 255.255.255.0 gateway $j $EXT_ETH

	    done

	done

elif [[ $HOSTNAME == "KRP2" ]]
then

    sed -i "s/192.168.199.2./192.168.199.25/g" /soft/etc/K23800/Granite/cctv.xml

    LAN_IP1="192.168.10.74"
    LAN_IP2="192.168.11.72"

	for i in $INT_IP1 $INT_IP2
	do

	    for j in $LAN_IP1 $LAN_IP2
	    do

		a=`echo ${j:0:10}`
		EXT_ETH=`ip addr show | egrep $a | egrep -o 'eth[0-9]'`
		route add -net $i netmask 255.255.255.0 gateway $j $EXT_ETH

	    done

	done

fi