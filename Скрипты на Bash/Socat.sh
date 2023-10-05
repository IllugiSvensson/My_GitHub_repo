#!/bin/bash

function CLIENTPORT {	#Функция открытия порта клиента для приема сообщений

	ssh $1 socat TCP-LISTEN:141$2,fork,reuseaddr pty,raw,waitslave,unlink-close=0,echo=0,link=/dev/tty$3 &

}

function SERVERPORT {	#Функция открытия порта для передачи сообщений

	socat -u -u pty,raw,echo=0,link=/dev/tty$3 TCP:$1:141$2 &

}

function CHANGEXML {	#Функция настройки дексрипторов у приемников

	ssh $4 sed -i "s/tty./tty$1/g" /soft/etc/K23800/Ship/Connections/cnct_nmea_kama.xml
	ssh $4 sed -i "s/tty./tty$2/g" /soft/etc/K23800/Ship/Connections/cnct_nmea_sev.xml
	ssh $4 sed -i "s/tty./tty$3/g" /soft/etc/K23800/Ship/Connections/cnct_nmea_harakter.xml

}

function PINGHOST {	#Функция проверки наличия клиента в сети

	ping -c 1 -w 10 $1 >/dev/null 2>&1

	case $? in
		0)	#Если хост есть, то сигнализируем об этом
			echo "Host online"
		;;
		*)	#Если хоста нет, перезапускаем скрипт (автозапуск через лаунч)
			exit
		;;
	esac

}

function TRACKING { #Функция установки соединения и слежение за хостом

	flag=0
	while :		#Следим за клиентом посредством цикла
	do		#На первой итерации создаем подключение

		if [ "$flag" == "0" ]	#Устанавливаем соединение
		then

			sleep 2s
			CLIENTPORT $4 $1 $5
			CLIENTPORT $4 $2 $6
			CLIENTPORT $4 $3 $7
			sleep 5s
			SERVERPORT $4 $1 $5
			SERVERPORT $4 $2 $6
			SERVERPORT $4 $3 $7
			flag=1		#Фиксируем соединения
			ssh $4 killall cnct_nmea.bin	#Сбрасываем приложения приемники
			ssh $4 killall StartServer.bin

		fi

		PINGHOST $4	#Держим подключение бесконечным циклом, пока хост в сети

	done

}

function STARTSOCAT {	#Запускаем сокат на хостах

	PINGHOST $1		#Пингуем хост
	APP=`ssh $1 ps aux | egrep -m 1 -o $2`	#Если хост в сети, проверяем приложение
	if [ "$APP" == "$2" ]			#Если запущено приложение, меняем конфигурацию
	then

		CHANGEXML $3 $4 $5 $1
		TRACKING $6 $7 $8 $1 $3 $4 $5	#Создаем соединение под наблюдением

	fi

}

case $1 in
	srv1)
		STARTSOCAT 192.168.111.52 cnct_nmea.bin 1 2 3 01 02 03
	;;
	srv2)
		STARTSOCAT 192.168.121.52 cnct_nmea.bin 4 5 6 04 05 06
	;;
	azn1)
		STARTSOCAT 192.168.10.71 StartServer.bin 7 8 9 07 08 09
	;;
	azn2)
		STARTSOCAT 192.168.10.73 StartServer.bin 10 11 12 10 11 12
	;;
esac