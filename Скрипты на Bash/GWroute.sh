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