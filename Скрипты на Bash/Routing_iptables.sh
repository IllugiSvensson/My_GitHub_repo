#!/bin/bash
#Проброс видеотрафика с серверов на рабочие места
#Скрипт запускать на серверах

iptables -t nat -A POSTROUTING -s  192.168.10.0/24 -j MASQUERADE	#Маскируем рабочую 
iptables -t nat -A POSTROUTING -s  192.168.11.0/24 -j MASQUERADE	#дублированнанную сеть

#Задаем адреса в зависимости от сервера
if [[ $HOSTNAME == "SRV1" ]]
then

    EXT_IP="192.168.199.42"		#Сеть и интерфейс, который нужно пробросить
    EXT_IF=eth5

    INT_IP1="192.168.10.72"		#Сети и интерфейсы, по которым будет направлен трафик
    INT_IP2="192.168.11.72"		#Интерфейсы определим в цикле

    LAN_IP1="192.168.10.12"		#Целевые сети
    LAN_IP2="192.168.10.13"		#(адреса рабочих мест)

elif [[ $HOSTNAME == "SRV2" ]]
then

    EXT_IP="192.168.199.41" 
    EXT_IF=eth5 

    INT_IP1="192.168.10.74" 
    INT_IP2="192.168.11.74" 

    LAN_IP1="192.168.10.12"
    LAN_IP2="192.168.10.13"

fi

#Задаем маршруты сетей
for i in $LAN_IP1 $LAN_IP2		#Перебираем рабочие места
do

    for j in $INT_IP1 $INT_IP2		#Перебираем сети
    do

		iptables -t nat -A PREROUTING --dst $EXT_IP -j DNAT --to-destination $i
		iptables -t nat -A POSTROUTING --dst $i -j SNAT --to-source $j
		iptables -t nat -A OUTPUT --dst $EXT_IP -j DNAT --to-destination $i
		ETH=`ip addr show | egrep $j | egrep -o 'eth[0-9]'`				#Определяем требуемый ethernet
		iptables -I FORWARD 1 -i $EXT_IF -o $ETH -d $i -j ACCEPT

    done

done

