#!/bin/bash

function Help {

	zenity --warning --ellipsize --text="$1" --title="Предупреждение" --timeout=5 &>/dev/null

	echo ""
	echo " Скрипт предназначен для смены роли удаленных компьютеров."
	echo " Для нормальной работы нужно выполнить несколько действий:"
	echo "	1. Проверить в /soft/etc/system.xml графу CONFIG и PRODUCT"
	echo "		Убедиться, что директории существуют по пути"
	echo "		/soft/etc/CONFIG/PRODUCT и /system/etc/CONFIG/~PRODUCT"
	echo "		Для Oracle8, есть только /soft/etc/CONFIG/PRODUCT"
	echo " "
	echo "	2. Проверить PRODUCT.xml и ZIP.xml."
	echo "		*Oracle8 - файлы лежат в /soft/etc/CONFIG/hardware."
	echo "		*Другие ОС - файлы лежат в /system/etc/CONFIG"
	echo "		В PRODUCT.xml должны быть описаны действующие хосты."
	echo "		В ZIP.xml в графе /Hosts/ZIP/NetConf добавить PRODUCT"
	echo "		и несколько пар адресов в порядке:"
	echo "		<n n=...... -> адрес, который всегда доступен по сети"
	echo "		v=...... /> -> адрес, который назначится ЗИПу."
	echo "		ЗИП компьютер должен пинговать ХОТЯ БЫ ОДИН адрес"
	echo "		из первой колонки, иначе ЗИП будет не в сети."
	echo " "
	echo "	3. Проверяем запуск программы через launch."
	echo "		В /soft/etc/CONFIG/launch.xml в графу Application"
	echo "		добавим changews_remote по аналогии с другими"
	echo "		программами, указав путь до скрипта и параметр"
	echo "		<n n=parameters v=PRODUCT />, чтобы при старте"
	echo "		удаленный ЗИП смог назначить себе адрес."
	echo "		В этом же файле в графе /Hosts/ZIP прописываем"
	echo "		changews_remote для автозапуска приложения."
	echo " "
	echo "	4. Обязательно распространить настройки и скрипт"
	echo "		на все компьютеры, включая идущие в поставку ЗИПы."
	echo "		*PRODUCT.xml и ZIP.xml - хосты с адресами,"
	echo "		*changews_remote.sh и launch.xml - скрипт"
	echo "			и правила запуска скрипта."
	echo " "
	echo "	5. При необходимости добавить запуск скрипта через задачи,"
	echo "		отредактировав Executables и Modes в /soft/etc/CONFIG/PRODUCT."
	echo " "
	echo " Скрипт должен настраиваться и применяться для каждого продукта"
	echo " и ОСи отдельно. В противном случаее есть вероятность сломать софт."
	echo " Чтобы в список продуктов не попадали лишние строки, нужно в"
	echo " соответствующем PRODUCT.xml в графе /Config/UseGenConf поставить 0."
	echo " "
	exit $2

}

[ -z "$1" -o "$1" == "--help" ] && {		#Проверяем аргумент продукта, вызываем справку

	Help "Не указан продукт в аргументе.\nСмотри справку в консоли" 1

}
#Пути, переменные окружения под разные ОСи
DATA="/data/tmp/CWR"		#Путь к промежуточным файлам
[ -e $DATA ] || { mkdir $DATA; }
if [ -d /system ]				#Для версий, где используется /system
then

	REGTOOL="/system/scripts/regtool.sh"
	GenerateConf="/system/scripts/system.sh"
	ETC="/system/etc"
	CONFIG=`$REGTOOL -r $ETC/system.xml / Config`
	confXML="$ETC/$CONFIG"
	DISPLAYCONF="/system/scripts/displayconf.sh"
	SOUNDCONF="/system/scripts/soundconf.sh"
	DISKCONF="/system/scripts/diskconf.sh"
	export LD_LIBRARY_PATH=/system/lib

else						#Для восьмерки

	REGTOOL="/usr/local/nita/scripts/regtool"
	GenerateConf="system.sh"
	ETC="/soft/etc"
	CONFIG=`$REGTOOL -r $ETC/system.xml / Config`
	confXML="$ETC/$CONFIG/hardware"
	DISPLAYCONF="launch displayconf"
	SOUNDCONF="launch soundconf"
	DISKCONF="launch diskconf"

fi





function MakeDialogWindow {		#Создание диалогового окна

	#Собираем окно из отдельных элементов
	ListItem="zenity --title=\"Смена роли рабочего места\" --height=350 --width=350 --list --text=\"$1\" $2 --ok-label=\"Применить\" --cancel-label=\"Выход\"" 2>/dev/null
	for item in $3				#Добавляем в список соответствующие элементы
	do

		ListItem="$ListItem \"$item\""

	done
	ListItem="$ListItem $5" 	#Добавляем доп кнопку если есть
	ListItem=`echo $ListItem | tr -d '()'`	#Убираем недопустимые символы

	cd $DATA
	rm -f kdialog.sh			#Создаем основное диалоговое окно
	echo -E "#! /bin/bash" >>kdialog.sh
	echo -E "RESULT=\`$ListItem\`" >>kdialog.sh
	echo -E "echo \$RESULT" >>kdialog.sh
	chmod +x kdialog.sh
	./kdialog.sh > "$4" 2>/dev/null		#Фиксируем вывод окна
	rm -f kdialog.sh

}

function DeleteTmpFile {		#Удаляем временные файлы

	rm -f $DATA/CWR_online.txt
	rm -f $DATA/CWR_offline.txt
	rm -f $DATA/CWR_product.txt
	rm -f $DATA/CWR_address.txt
	rm -f $DATA/kdialog.sh
	rm -f $DATA/HOSTNAME
	rm -f $DATA/PRODUCT

}

function CancelButtonClicked {	#Выход из окна при нажании на Отмена или х

	if [ -z "$1" ]	#Если код возврата пустота(в случае отмены)
	then

		DeleteTmpFile
		zenity --warning --ellipsize --text="Нажата отмена или\nне выбран компьютер!" --title="Предупреждение" --timeout=2 2>/dev/null
		exit 1

	fi

}

function PingHosts {			#Проверка хостов в сети

	if [ "$1" == "$confXML/ZIP.xml" ]		#XML зипа отличается, пингуем по другому
	then

		for i in `$REGTOOL -l $confXML/ZIP.xml /Hosts/ZIP/NetConf/$2`
		do
			#Перебираем сетки
			addr=`$REGTOOL -r $confXML/ZIP.xml /Hosts/ZIP/NetConf/$2 $i`
			addr=${addr::-3}		#Отсеиваем маску
			flag=0
			ping -c 3 -W 1 $addr >/dev/null 2>&1
			if [ $? == 0 ]			#Если пинганули
			then

				DESCRIPTION=`$REGTOOL -r $1 /Hosts/ZIP Description ZIP`
				echo ZIP \"$DESCRIPTION\">>$DATA/CWR_online.txt	#Пишем хост в список "в сети"
				flag=1
				echo $addr >$DATA/CWR_address.txt				#Запоминаем зиповый адрес рабочий
				break							#Выходим из цикла

			fi
			ZIPaddr=`echo $addr $ZIPaddr`		#Запоминаем список нерабочих адресов зипа

		done
		[ "$flag" == 1 ] || {					#Если не пинганули

			DESCRIPTION=`$REGTOOL -r $1 /Hosts/ZIP Description ZIP`
			echo ZIP \"$DESCRIPTION\">>$DATA/CWR_offline.txt	#Пишем хост "не в сети"
			echo $ZIPaddr >$DATA/CWR_address.txt				#Пишем адреса

		}

	else

		for HOSTprod in `$REGTOOL -n $1 /Hosts`	#Просматриваем адреса каждого хоста
		do

			[ `$REGTOOL -r $1 /Hosts/$HOSTprod Alien` == 1 ] && { continue; }
			ADDRESSES=`$REGTOOL -l $1 /Hosts/$HOSTprod/Network/Addresses`	#Список адресов хоста
			flag=0
			for ADDRES in $ADDRESSES	#Пингуем адреса отдельного хоста
			do

				ping -c 3 -W 1 $ADDRES >/dev/null 2>&1
				if [ $? == 0 ]			#Если хоть один адрес хоста ответил
				then

					DESCRIPTION=`$REGTOOL -r $1 /Hosts/$HOSTprod Description $HOSTprod`
					echo $HOSTprod \"$DESCRIPTION\">>$DATA/CWR_online.txt			#Пишем хост в список "в сети"
					flag=1
					break				#Выходим из итерации

				fi

			done
			[ "$flag" == 1 ] || {

				DESCRIPTION=`$REGTOOL -r $1 /Hosts/$HOSTprod Description $HOSTprod`
				echo $HOSTprod \"$DESCRIPTION\">>$DATA/CWR_offline.txt	#Если все не пингуются, пишем хост "не в сети"

			}

		done

	fi | zenity --progress --title="Выполнение" --text="Ищем компьютеры.." --pulsate --no-cancel --auto-close 2>/dev/null
	[ -z `cat $DATA/CWR_address.txt` ] || { XMLaddr=`cat $DATA/CWR_address.txt`; }
	#Из-за прогрессбара нельзя вывести переменную, так что добавляем еще одно условие для зип адресов

}

function SoftSync {				#Проверка и синхронизация софта

	ver1=`cat /soft/version | sed 's/\.//g'`		#Версия локального компа(сервера)
	ver2=`ssh $1 cat /soft/version | sed 's/\.//g'`	#Версия сервера(удаленного компа)
	[ $ver1 $2 $ver2 ] && {							#Сравниваем файл версии

		zenity --question --title="Информация" --text="Версия ПО отличается от локальной версии.\nУстановить обновление?" --ellipsize --ok-label="Да" --cancel-label="Нет" 2>/dev/null
		[ $? == 0 ] && {
			#Передаем софт
			if [ $2 == "-gt" ]
			then

				rsync -av --delete --exclude HOSTNAME --exclude etc/system.xml --exclude PRODUCT /soft/ $1:/soft/

			else

				rsync -av --delete --exclude HOSTNAME --exclude etc/system.xml --exclude PRODUCT $1:/soft/ /soft/

			fi

		} | zenity --progress --title="Выполнение" --text="Передача файлов.." --pulsate --no-cancel --auto-close 2>/dev/null

	}

}

function DevConfig {			#Настройка железа

	while true
	do

		if [ "$1" == "ssh" ]	#Если нужно настроить удаленный компьютер
		then

			MakeDialogWindow "Проведите настройку оборудования $2.\nЧтобы закончить настройку, нажмите Выход." "--column=\"Оборудование\"" "Звук Диски" $DATA/CWR_online.txt
			case `cat $DATA/CWR_online.txt` in
				"Звук")
					ssh $2 $SOUNDCONF &
					sleep 1s
					pid=`ssh $2 pgrep soundconf.bin`
					ssh $2 tail --pid=$pid -f /dev/null
					;;
				"Диски")
					ssh $2 $DISKCONF &
					sleep 1s
					pid=`ssh $2 pgrep diskconf.bin`
					ssh $2 tail --pid=$pid -f /dev/null
					;;
				*)
					break
					;;
			esac

		else

			MakeDialogWindow "Проведите настройку оборудования $2.\nЧтобы закончить настройку, нажмите Выход." "--column=\"Оборудование\"" "Мониторы Звук Диски" $DATA/CWR_online.txt
			case `cat $DATA/CWR_online.txt` in
				"Мониторы")
					$DISPLAYCONF
					;;
				"Звук")
					$SOUNDCONF
					;;
				"Диски")
					$DISKCONF
					;;
				*)
					break
					;;
			esac

		fi

	done

}





#Блок отключения других экземпляров программы при повторном запуске
FindPIDs=`pgrep -f "changews_remote.sh"`	#Ищем PID процесса(ов)
for RunPID in $FindPIDs
do

	if [ "$RunPID" != "$$" ]	#Перебираем PID'ы и если есть не текущий
	then

		kill $RunPID			#Убиваем его вместе со
		killall zenity			#всеми активными окнами
		DeleteTmpFile			#Очищаем рабочую область

	fi

done
#Блок проверки конфигурации
for i in `$REGTOOL -n $confXML/ZIP.xml /Hosts/ZIP/NetConf` endline
do
	#Проверяем правильность аргумента
	if [ $i == $1 ]		#Если продукт найден
	then

		break			#Пропускаем проверки

	elif [ $i == "endline" ]	#Если продукт не найден
	then

		Help "Продукт не найден в конфигурации ZIP.xml" 1

	else 				#Продолжаем искать

		continue

	fi

done
#Блок расчета количества продуктов
cd $confXML
for xml in *.xml		#Перебираем xmlки
do

	v=`$REGTOOL -r $xml /Config /UseGenConf`
	if [ "$v" == "1" ]	#Выделяем только те, которые используются в списках
	then

		Xml=`echo $Xml $xml`

	fi

done
Xml=`echo $Xml ZIP.xml | sed 's/.xml//g'`	#Список доступных продуктов



#Диалог с пользователем для ЗИПа и настройка сети
[ `cat /soft/PRODUCT` == "ZIP" ] && {		#Если продукт ЗИП

	flg=0
	while true								#Пытаемся назначить адрес
	do

		#Блок назначения адреса. Если назначили адрес, то можно ЗИПовать локально и удаленно
		[ $flg == 0 ] && {					#Если нашли адрес, запрещаем обработку

			Taddr=$($REGTOOL -l $confXML/ZIP.xml /Hosts/ZIP/NetConf/$1)	#Получим список адресов для пингования
			for intf in /sys/class/net/*	#Перебираем отключенные интерфейсы
			do

				eth=`basename $intf`
				[ $eth == "lo" ] && { continue; }	#Локальный хост пропускаем
				ifconfig $eth up					#Поднимаем отключенный интерфейс без адреса
				for i in $Taddr						#Перебираем целевые адреса (компы с мониторами)
				do

					(
					TMPaddr=$($REGTOOL -r $confXML/ZIP.xml /Hosts/ZIP/NetConf/$1 $i)
					ifconfig $eth $TMPaddr			#Назначаем временный адрес
					sleep 1s
					) | zenity --progress --title="Выполнение" --text="Проверяем интерфейс $eth.." --pulsate --no-cancel --auto-close 2>/dev/null
					ping -c 3 -W 1 $i >/dev/null 2>&1	#Если пинганули, адрес оставляем
					[ "$?" == "0" ] && {

						flg=1
						break 2				#выходим из циклов

					}

				done
				ifconfig $eth down			#Если адреса не подошли, отключаем интерфейс

			done

		}
		ping -c 3 -W 1 $i >/dev/null 2>&1
		[ "$?" == "0" ] || { 				#На случай, если потеряли сеть, запускаем цикл заново

			flg=0
			continue

		}

		#Блок выбора роли
		DeleteTmpFile
		PingHosts $confXML/$1.xml $1
		echo `cat $DATA/CWR_offline.txt` >$DATA/CWR_offline.txt	#Транспонируем таблицу в список
		HostsOffline=`cat $DATA/CWR_offline.txt`				#Cохраняем списки хостов
		#Окно имеет смысл, только для разворачивания локального компьютера вручную
		MakeDialogWindow "Задайте роль для этого компьютера." "--column=\"Роль\" --column=\"Описание\"" "$HostsOffline" $DATA/CWR_offline.txt
		ROLE=`cat $DATA/CWR_offline.txt`
		CancelButtonClicked $ROLE
		[ -z "$ROLE" ] || {			#Если роль выбрана спрашиваем, применить или нет

			zenity --question --width=200 --title="Смена роли рабочего места" --text="Применить роль $ROLE\nдля этого компьютера?" --ok-label="Применить" --cancel-label="Назад" 2>/dev/null
			if [ $? == 0 ]			#Если нажали да, то задаем роль
			then

				SoftSync $i "-lt"		#Проверяем, есть ли устаревший софт
				DevConfig "nossh" $ROLE	#Настраиваем железо
				(
				echo $ROLE> /$NITAROOT/HOSTNAME		#Генерируем выбранную роль, задаем хостнейм
				echo $1> /$NITAROOT/PRODUCT			#Генерируем продукт
				$REGTOOL -w /$NITAROOT/etc/system.xml / Product $1
				remount rw
				$GenerateConf GenerateConfig		#Генерируем конфигурацию для восьмерки
				$GenerateConf $1 GenerateConfig		#Генерируем конфигурацию для остальных
				) | zenity --progress --title="Выполнение" --text="Задаем роль $ROLE.." --pulsate --no-cancel --auto-close 2>/dev/null

				zenity --info --title="Завершение работы" --text="Изменения вступят в силу\nпосле перезагрузки компьютера.\nПерезагрузка через 3 сек." --ellipsize --timeout=3 2>/dev/null
				DeleteTmpFile
				reboot

			else

				continue	#Если нажали отмена, повторяем цикл

			fi

		}

	done

}



#Диалог с пользователем
while true
do

	#Выбор продукта и хоста
	while true
	do

		#Выбираем первый продукт
		DeleteTmpFile
		MakeDialogWindow "Выберите дейсвующий продукт." "--column=Продукт" "$Xml" $DATA/CWR_product.txt		#Диалог выбора хоста
		PRODUCT=`cat $DATA/CWR_product.txt`	#Записали результат диалога
		CancelButtonClicked $PRODUCT		#Если нажали Выход
		#Пингуем хосты выбранного продукта
		PingHosts $confXML/$PRODUCT.xml $1
		echo `cat $DATA/CWR_online.txt` >$DATA/CWR_online.txt
		HostsOnline=`cat $DATA/CWR_online.txt`
		#Выбираем хост
		MakeDialogWindow "Выберите доступный компьютер." "--column=\"Имя\" --column=\"Описание\"" "$HostsOnline" $DATA/CWR_online.txt --extra-button="Назад"
		HOST=`cat $DATA/CWR_online.txt`
		CancelButtonClicked $HOST
		[ $HOST == "Назад" ] && { continue; }		#Возвращаемся назад в пункт меню
		break

	done

	#Выбор продукта и роли
	while true
	do

		#Выбираем второй продукт
		DeleteTmpFile
		MakeDialogWindow "Выберите итоговый продукт." "--column=Продукт" "$Xml" $DATA/CWR_product.txt
		PRODUCT=`cat $DATA/CWR_product.txt`
		CancelButtonClicked $PRODUCT
		#Пингуем хосты выбранного продукта
		PingHosts $confXML/$PRODUCT.xml $1
		echo `cat $DATA/CWR_offline.txt` >$DATA/CWR_offline.txt
		HostsOffline=`cat $DATA/CWR_offline.txt`
		#Выбираем роль
		MakeDialogWindow "Задайте роль для компьютера $HOST." "--column=\"Роль\" --column=\"Описание\"" "$HostsOffline" $DATA/CWR_offline.txt --extra-button="Назад"
		ROLE=`cat $DATA/CWR_offline.txt`
		CancelButtonClicked $ROLE
		[ $ROLE == "Назад" ] && { continue; }
		break

	done

	#Перевод системы
	[ -z "$ROLE" ] || {			#Если роль выбрана спрашиваем, применить или нет

		zenity --question --width=200 --title="Смена роли рабочего места" --text="Применить роль $ROLE\nдля компьютера $HOST?" --ok-label="Применить" --cancel-label="Назад"  2>/dev/null
		if [ $? == 0 ]			#Если нажали да, то задаем роль
		then

			if [ $HOSTNAME == $HOST ]		#Если выбрали локальный компьютер
			then

				[ $ROLE == ZIP ] || { DevConfig "nossh" $ROLE; }
				(
				echo $ROLE> /$NITAROOT/HOSTNAME			#Генерируем выбранную роль, задаем хостнейм
				echo $PRODUCT> /$NITAROOT/PRODUCT		#Генерируем продукт
				$REGTOOL -w /$NITAROOT/etc/system.xml / Product $PRODUCT
				remount rw
				$GenerateConf GenerateConfig			#Генерируем конфигурацию для восьмерки
				$GenerateConf $PRODUCT GenerateConfig	#Генерируем конфигурацию для остальных
				) | zenity --progress --title="Выполнение" --text="Задаем роль $ROLE.." --pulsate --no-cancel --auto-close  2>/dev/null

				zenity --info --title="Завершение работы" --text="Изменения вступят в силу\nпосле перезагрузки компьютера.\nПерезагрузка через 3 сек." --ellipsize --timeout=3 2>/dev/null
				DeleteTmpFile
				reboot

			else							#Если выбрали удаленный компьютер

				#Здесь нужно разделить адреса и хостнейм(ZIP хостнейм неизвестен)
				if [ "$HOST" == ZIP ]
				then

					HOSTtext=$HOST
					HOST=$XMLaddr

				else

					HOSTtext=$HOST

				fi
				[ "$ROLE" == ZIP ] && { ROLEtext="ZIP"; }
				[ "$ROLE" == ZIP ] || {

					ROLEtext="$ROLE"
					SoftSync $HOST -gt

				}
				(
				echo $ROLE> /$DATA/HOSTNAME				#Генерируем выбранную роль, задаем хостнейм
				echo $PRODUCT> /$DATA/PRODUCT			#Генерируем продукт
				scp /$DATA/HOSTNAME root@$HOST:/soft
				scp /$DATA/PRODUCT root@$HOST:/soft
				ssh $HOST $REGTOOL -w /$NITAROOT/etc/system.xml / Product $PRODUCT
				ssh $HOST remount rw
				ssh $HOST $GenerateConf GenerateConfig	#Генерируем конфигурацию для восьмерки
				ssh $HOST $GenerateConf $PRODUCT GenerateConfig	#Генерируем конфигурацию для остальных
				) | zenity --progress --title="Выполнение" --text="Задаем роль $ROLEtext.." --pulsate --no-cancel --auto-close 2>/dev/null

				zenity --info --title="Завершение работы" --text="Изменения вступят в силу\nпосле перезагрузки компьютера.\nПерезагрузка через 3 сек." --ellipsize --timeout=3 2>/dev/null
				DeleteTmpFile
				ssh $HOST reboot

					#Блок наблюдения за компьютером и настройка оборудования после старта
					(
					TIME=0
					while true
					do

						if [ $ROLE == ZIP ]		#Если роль ЗИП, то нет конкретного адреса
						then

							for o in $XMLaddr	#Перебираем все возможные адреса
							do

								ping -c 4 -W 1 $o
								[ $? == 0 ] && { ok=0; break; }

							done

						else

							ping -c 4 -W 1 $ROLE
							[ $? == 0 ] && { ok=0; }

						fi
						if [ "$ok" == 0 ]		#Если пинганули, настраиваем оборудование
						then

							zenity --info --title="Успех" --ellipsize --text="Компьютер $HOSTtext принял роль $ROLE." --timeout=3 2>/dev/null
							break

						elif [ $TIME -gt 300 ]
						then

							zenity --error --title="Ошибка" --ellipsize --text="Компьютер $HOSTtext в роли $ROLEtext не загрузился\nПроведите диагностику." --timeout=3 2>/dev/null
							killall ${0##*/}

						else

							TIME=$(( $TIME + 6 ))	#счетчик времени

						fi

					done
					) | zenity --progress --title="Выполнение" --text="Ищем компьютер $ROLE" --pulsate --no-cancel --auto-close 2>/dev/null
					[ $ROLE == "ZIP" ] || { DevConfig "ssh" $ROLE; }	#Настраиваем удаленное оборудование
					exit 0

			fi

		else		#Если нажали отмена, повторяем цикл

			continue

		fi

	}

done