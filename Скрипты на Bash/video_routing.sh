#!/bin/bash
#Проброс видеотрафика с серверов на рабочие места

iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE #Маскируем рабочую
iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -j MASQUERADE #дублированнанную сеть

#Задаем адреса в зависимости от сервера
if [[ $HOSTNAME == "SRV1" ]]
then

    EXT_IP1="192.168.100.218"		#Сеть и интерфейс, который нужно пробросить
    EXT_IP2="192.168.199.72"

    INT_IP1="192.168.10.72"			#Сети и интерфейсы, в которые будет направлен трафик
    INT_IP2="192.168.11.72"			#Интерфейсы определим в цикле

elif [[ $HOSTNAME == "SRV2" ]]
then

    EXT_IP1="192.168.100.222" 
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

    for j in $INT_IP1 $INT_IP2						#Перебираем сети
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

    LAN_IP1="192.168.11.72"
    LAN_IP2="192.168.11.74"
    LAN_IP3="192.168.10.72"
    LAN_IP4="192.168.10.74"

if [ "$HOSTNAME" == "KRP1" -o "$HOSTNAME" == "KRP2" ]
then

    flag=0

    for net in $LAN_IP1 $LAN_IP2 $LAN_IP3 $LAN_IP4
    do

	ETH=`ip addr show | egrep $net | egrep -o 'eth[0-9]'`

	while [ `ping -c 1 -w 10 $net > /dev/null; echo $?` == "0" ]
	do

	    if [ $flag == 0 ]
	    then

		route add -net $INT_IP1 netmask 255.255.255.0 gateway $net $ETH
		route add -net $INT_IP2 netmask 255.255.255.0 gateway $net $ETH
		flag=1

	    fi

	done

	    flag=0
	    route del -net $INT_IP1 netmask 255.255.255.0 gateway $net $ETH
	    route del -net $INT_IP2 netmask 255.255.255.0 gateway $net $ETH

    done

fi