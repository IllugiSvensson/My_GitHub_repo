#!/bin/bash
function validator {			#Проверка валидности выполнения скрипта

	echo " "
	echo "$1. Введите $0 --help для справки"
	echo " "
	exit 1

}

function validIp {				#Валидация введенного адреса

	#Проверяем введенный адрес регулярным выражением
	var1=`echo $1 | egrep '^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$'`
	var2=`echo $2 | egrep '^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$'`
	var3=`echo $3 | egrep '^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$'`	

	if [ -z "$var1" -o -z "$var2" -o -z "$var3" ]	#Если хотя бы один адрес неверный
	then

		validator "Ошибка в записи адреса"

	fi

}

if [ "$#" == 0 ] 				#На случай, если не введены аргументы
then

	validator "Нет аргументов"

elif [ "$1" == "--help" ]		#Вызываем справку по использованию
then

	echo " "
	echo "____СКРИПТ ПРОБРОСА ТРАФИКА ИЗ ОДНОЙ СЕТИ В ДРУГУЮ ПОСРЕДСТВОМ ТАБЛИЦЫ NAT____"
	echo " "
	echo "ВАЖНО! Перед запуском скрипта на передатчике должна быть включена поддержка"
	echo "форвардинга. Для включения пропишите sysctl -w net.ipv4.ip_forward=1"
	echo "Проверить, что уже включен: sysctl -a | grep net.ipv4.ip_forward=1"
	echo " "
	echo "  Формат запуска в режиме передачи трафика:"
	echo "  $0 -tr [ххх.ххх.ххх.ххх] [ххх.ххх.ххх.ххх] [ххх.ххх.ххх.ххх]"
	echo "  где первый адрес - адрес сети, который нужно пробросить"
	echo "      второй адрес - адрес сети, по которой пойдет трафик"
	echo "      третий адрес - адрес хоста, который принимает трафик"
	echo " "
	echo "  Формат запуска в режиме приёма трафика:"
	echo "  $0 -rs [xxx.xxx.xхх.xхх] [xxx.xxx.xxx.xxx] [xxx.xxx.xxx.xxx]"
	echo "  где первый адрес - адрес сети, который нужно принять"
	echo "      указывается с последним(и) нулевыми актетами, в соответствии с маской"
	echo "      второй адрес - адрес хоста, который осуществляет передачу"
	echo "      третий адрес - маска сети принимаемого трафика"
	echo "Последующие аргументы, выходящие за пределы формата в любом режиме игнорируются"
	echo "-------------------------------------------------------------------------------"
	exit 0

elif [ "$1" == "-tr" ]			#Режим передачи
then

	mode=1

elif [ "$1" == "-rs" ]			#Режим приёма
then

	mode=2

elif [[ "$1" =~ -\.* ]]			#Проверка валидности ключа
then

	validator "Неверный ключ"

else							#Когда не выбран режим работы

	validator "Режим работы не выбран"

fi

[ "$#" -ge 4 ] || {				#Проверка количества аргументов

	validator "Недостаточно аргументов"

}

validIp $2 $3 $4				#Проверяем введенные адреса на принадлежность к ipv4
[ $? == 0 ] && {

	if [ "$mode" == "1" ]		#Задаем маршрут для передачи
	then

		#Здесь можно добавить проверку на наличие указанных адресов в системе
		#Вычисляем интерфейсы по введенным адресам
		INT_ETH=`ip addr show | egrep $3 | egrep -o '\w+$'`
		EXT_ETH=`ip addr show | egrep $2 | egrep -o '\w+$'`
		flag=0

		while [ `ping -c 1 -w 10 $4 > /dev/null; echo $?` == "0" ]	#Пока адрес приемника доступен
		do

			if [ $flag == 0 ]
			then

				#Устанавливаем маршрут на передачу
				iptables -t nat -A PREROUTING --dst $2 -j DNAT --to-destination $4
				iptables -t nat -A POSTROUTING --dst $4 -j SNAT --to-source $3
				iptables -t nat -A OUTPUT --dst $2 -j DNAT --to-destination $4
				iptables -I FORWARD 1 -i $EXT_ETH -o $INT_ETH -d $4 -j ACCEPT
				
				#Если команды выше не обеспечивают связь, применить следующее
				#iptables -F FORWARD
				#iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
				#iptables -A FORWARD -m conntrack --ctstate NEW -i $INT_ETH -j ACCEPT
				#iptables -P FORWARD DROP
				#iptables -t nat -F POSTROUTING
				#iptables -t nat -A POSTROUTING -o $EXT_ETH -j MASQUERADE
				
					echo " "
					echo "Маршрут задан:"
					iptables -S | egrep "\-A FORWARD"
					echo "Запускаем слежение за хостом..."
					echo " "

				flag=1

			fi

			sleep 5s
			echo "Соединение установлено"
	
		done

		#Когда доступ пропадает, завершаем процесс и удаляем маршрут
		echo "Соединение разорвано. Удаление маршрута и завершение процесса"
		echo " "
		N=`iptables -S | grep "\-A FORWARD" | grep -n "$2 -o $3" | cut -d : -f 1`
		iptables -D FORWARD $N
		#Либо просто iptables -F
		exit 0

	fi

	if [ "$mode" == "2" ]		#Задаем маршрут для приёмника
	then

		ETH=`ip addr show | egrep $3 | egrep -o '\w+$'`
		flag=0

		while [ `ping -c 1 -w 10 $3 > /dev/null; echo $?` == "0" ]
		do

			if [ $flag == 0 ]
			then

				#Устанавливаем маршрут на приём
				route add -net $2 netmask $4 gateway $3 $ETH

					echo " "
					echo "Маршрут задан:"
					route -n 
					echo "Запускаем слежение за хостом..."
					echo " "

				flag=1

			fi
			
			sleep 5s
			echo "Соединение установлено"
			
		done

		#Когда доступ пропадает, завершаем процесс и удаляем маршрут
		echo "Соединение разорвано. Удаление маршрута и завершение процесса"
		echo " "
		route del -net $2 netmask $4 gateway $3 $ETH
		exit 0

	fi

}