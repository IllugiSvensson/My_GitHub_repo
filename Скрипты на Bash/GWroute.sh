#!/bin/bash

#Первый аргумент - сеть, по которой пойдет трафик, обычно 192.168.30/31.ххх
#Второй аргумент - сеть, которую нужно получить

sysctl net.ipv4.ip_forward=1 #Разрешаем системе передавать транзитный трафик
iptables -F FORWARD #Очищаем цепочку правил маршрутизации

#Разрешаем проходить пакетам по уже установленным соединениям
	iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#Разрешаем передачу сети от передатчика к приемнику
	iptables -A FORWARD -m conntrack --ctstate NEW -i $1 -j ACCEPT
#Весь остальной транзитный трафик запрещаем
	iptables -P FORWARD DROP 
#Очищаем цепочку правил POSTROUTING таблицы nat
	iptables -t nat -F POSTROUTING
#Скрываем весь транзитный трафик
	iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE

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