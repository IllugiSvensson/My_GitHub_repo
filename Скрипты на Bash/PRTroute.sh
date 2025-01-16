#!/bin/bash

sysctl net.ipv4.ip_forward=1	#Разрешаем системе передавать транзитный трафик
iptables -F FORWARD 			#Очищаем цепочку правил маршрутизации

EXT_IP="" 		#Адрес шлюза внешний, обычно 192.168.31...
INT_IP=""		#Адрес шлюза внутренний

EXT_IF="" 		#Интерфейс локальной сети шлюза 
INT_IF=""		#Интерфейс внешней сети шлюза

FAKE_PORT=$1	#Порт шлюза, к которому обращаемся из вне
LAN_IP=$2		#Адрес компьютера и порт, который шлюз пробрасывает к FAKE_PORT
SRV_PORT=$3		#FAKE_PORT может быть любым свободным, SRV_PORT 5900 для VNC, 22 для остального



iptables -t nat -A PREROUTING -d $EXT_IP -p tcp -m tcp --dport $FAKE_PORT -j DNAT --to-destination $LAN_IP:$SRV_PORT

iptables -t nat -A POSTROUTING -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j SNAT --to-source $INT_IP

iptables -t nat -A OUTPUT -d $EXT_IP -p tcp -m tcp --dport $SRV_PORT -j DNAT --to-destination $LAN_IP

iptables -I FORWARD 1 -i $EXT_IF -o $INT_IF -d $LAN_IP -p tcp -m tcp --dport $SRV_PORT -j ACCEPT

#Для того, чтобы работало, нужно добавить в автозапуск
#Для этого необходимо перейти в /soft/etc/{OBJ}/
#Открыть файл rc.nita (создать если отсутствует) и вписать/дополнить следующее

# Only LOAD functions on boot
#function StartingWS()
#{
#	case "$MYHOST" in
#		HOSTNAME)								#HOSTNAME - описан в /soft/HOSTNAME
#			/soft/scripts/GWroute.sh eth? eth?	#Подставить нужный eth
#			;;

#}

#Если файл отсутсвует, создать новый и вписать целиком функцию, указав eth
#Если файл уже есть, найти свой хост нейм и вписать строку с указанием eth
					#Если хостнейма нет, создать блок case со своим хостнеймом
#Не забываем раскомментировать строки :)																								  