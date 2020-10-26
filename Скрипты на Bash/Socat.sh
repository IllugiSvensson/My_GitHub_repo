#!/bin/bash

if [ "$HOSTNAME" == "SRV1" ]
then
	#На хостах открываем порты для прослушивания
	#Прослушка идет в фоновом режиме
	socat TCP-LISTEN:14141,fork,reuseaddr pty,raw,echo=0,link=/dev/tty1 &
	socat TCP-LISTEN:14142,fork,reuseaddr pty,raw,echo=0,link=/dev/tty2 &
	socat TCP-LISTEN:14143,fork,reuseaddr pty,raw,echo=0,link=/dev/tty3 &
	wait

elif [ "$HOSTNAME" == "AZN1" ]
then

	socat TCP-LISTEN:14144,fork,reuseaddr pty,raw,echo=0,link=/dev/tty4 &
	wait

elif  [ "$HOSTNAME" == "Emul" ]
then

	if [ "$1" == "srv" ]		#Соединение для сервера
	then
		#Проверяем, работает ли сервер
		ping -c 1 -w 10 192.168.10.72 >/dev/null 2>&1 && Host1="SRV1"
		ping -c 1 -w 10 192.168.11.72 >/dev/null 2>&1 && Host2="SRV1"

		if [ "$Host1" == "$Host2" ]
		then
			#Если работает, то создаем соединение
			socat -u -u pty,raw,echo=0,link=/dev/tty1 TCP:192.168.111.52:14141 &	#Kama
			socat -u -u pty,raw,echo=0,link=/dev/tty2 TCP:192.168.111.52:14142 &	#Sev
			socat -u -u pty,raw,echo=0,link=/dev/tty3 TCP:192.168.111.52:14143 &	#Harakter

			#Перезапускаем приемопередатчик данных
			ssh $Host1 killall -9 cnct_nmea.bin
			killall -9 stand_control_panel.bin
			wait

		fi

	elif [ "$1" == "azn" ]		#Соединение для АЗН
	then

		ping -c 1 -w 10 192.168.10.71 >/dev/null 2>&1 && Host1="AZN1"
		ping -c 1 -w 10 192.168.11.71 >/dev/null 2>&1 && Host2="AZN1"

		if [ "$Host1" == "$Host2" ]
		then

			socat -u -u pty,raw,echo=0,link=/dev/tty4 TCP:192.168.11.71:14144 &	#AZN

			ssh $Host1 killall -9 StartServer.bin
			killall -9 stand_control_panel.bin
			wait

		fi

	fi

fi





