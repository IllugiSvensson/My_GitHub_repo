#!/bin/bash

#Справка
[ "$1" == "--help" ] && {

	echo ""
	echo "Скрипт предназначен для зипования удаленных компьютеров"
	echo "Для нормальной работы нужно выполнить несколько действий:"
	echo "	1. Отредактировать ZIP.xml. Добавить в NetConf продукт"
	echo "	   	и необходимые наборы адресов. Первый адрес - хост,"
	echo "     	который пингуем, Второй адрес - с которого пингуем."
	echo "	2. Занести приложение в launch.xml, указав в параметрах"
	echo "     	продукт, который описан в ZIP.xml"
	echo "	3. В объектовом launch.xml привязать автозапуск приложения"
	echo "     	к хосту ZIP"
	echo "	4. По необходимости добавляем запуск приложения в"
	echo "	   	Executables.xml ЗИПа и продукта."
	echo "	5. Распространить настройки на все компьютеры стенда."
	echo ""
	exit 0

}



#Пути, переменные окружения
DATA="/data/tmp/CWR"		#Путь к промежуточным файлам
mkdir $DATA
VER=`uname -r`				#Определяем версию ОСи
VER=${VER:0:1}
if [ $VER -lt 5 ]			#Если ядро меньше 5
then

	REGTOOL="/system/scripts/regtool.sh"		#Путь до regtool
	ETC="/system/etc"
	GenerateConf="/system/scripts/system.sh"	#Путь до системного скрипта
	CONFIG=`$REGTOOL -r $ETC/system.xml / Config`
	confXML="$ETC/$CONFIG"

else

	REGTOOL="/usr/local/nita/scripts/regtool"
	GenerateConf="system.sh"
	ETC="/soft/etc"
	CONFIG=`$REGTOOL -r $ETC/system.xml / Config`
	confXML="$ETC/$CONFIG/hardware"

fi


function MakeDialogWindow {		#Создание диалогового окна

	#Собираем окно из отдельных элементов
	ListItem="zenity --title=\"Система управления ЗИП\" --height=350 --width=350 --list --text=\"$1\" $2 --ok-label=\"Применить\" --cancel-label=\"Выход\""
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
	./kdialog.sh > $4			#Фиксируем вывод окна
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
		zenity --warning --ellipsize --text="Нажата отмена или\nне выбран компьютер!" --title="Предупреждение" --timeout=2
		exit 1

	fi

}

function PingHosts {			#Проверка хостов в сети

	if [ "$1" == "$confXML/ZIP.xml" ]				#XML зипа отличается, пингуем по другому
	then

		for i in `$REGTOOL -l $confXML/ZIP.xml /Hosts/ZIP/NetConf/$2`
		do
			#Перебираем сетки
			addr=`$REGTOOL -r $confXML/ZIP.xml /Hosts/ZIP/NetConf/$2 $i`
			addr=${addr::-3}		#Отсеиваем маску
			flag=0
			ping -c 2 -W 1 $addr >/dev/null 2>&1
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

			ADDRESSES=`$REGTOOL -l $1 /Hosts/$HOSTprod/Network/Addresses`	#Список адресов хоста
			flag=0
			for ADDRES in $ADDRESSES	#Пингуем адреса отдельного хоста
			do

				ping -c 2 -W 1 $ADDRES >/dev/null 2>&1
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

	fi | zenity --progress --title="Проверка сети" --text="Ищем компьютеры.." --pulsate --no-cancel --auto-close
	[ -z `cat $DATA/CWR_address.txt` ] || { XMLaddr=`cat $DATA/CWR_address.txt`; }
	#Из-за прогрессбара нельзя вывести переменную, так что добавляем еще одно условие для зип адресов

}



#Блок отключения других экземпляров программы при повторном запуске
FindPIDs=`pgrep -f "remote_changews.sh"`	#Ищем PID процесса(ов)
for RunPID in $FindPIDs
do

	if [ "$RunPID" != "$$" ]	#Перебираем PID'ы и если есть не текущий
	then

		kill $RunPID		#Убиваем его вместе со
		killall zenity		#всеми активными окнами
		DeleteTmpFile		#Очищаем рабочую область

	fi

done



#Блок назначения адреса для ЗИП компьютера
[ -z "$1" ] && {		#Проверяем аргумент продукта

	zenity --warning --ellipsize --text="Не указан продукт в конфигурации." --title="Предупреждение" --timeout=2
	exit 1

}

for i in `$REGTOOL -n $confXML/ZIP.xml /Hosts/ZIP/NetConf` endline
do
	#Проверяем правильность аргумента
	if [ $i == $1 ]		#Если продукт найден
	then

		break			#Пропускаем проверки

	elif [ $i == "endline" ]	#Если продукт не найден
	then

		zenity --warning --ellipsize --text="Продукт не найден в\nконфигурации." --title="Предупреждение" --timeout=2
		exit					#Предупреждаем

	else 				#Продолжаем искать

		continue

	fi

done

[ `cat /soft/PRODUCT` == "ZIP" ] && {		#Если продукт ЗИП

	while :			#Пытаемся назначить адрес
	do

		for intf in /sys/class/net/*		#Перебираем отключенные интерфейсы
		do

			eth=`basename $intf`
			[ $eth == "lo" ] && { continue; }	#Локальный хост пропускаем
			ifconfig $eth up					#Поднимаем отключенный интерфейс без адреса
			Taddr=$($REGTOOL -l $confXML/ZIP.xml /Hosts/ZIP/NetConf/$1)
			for i in $Taddr						#Перебираем целевые адреса (компы с мониторами)
			do

				TMPaddr=$($REGTOOL -r $confXML/ZIP.xml /Hosts/ZIP/NetConf/$1 $i)
				ifconfig $eth $TMPaddr			#Назначаем временный адрес
				ping -c 8 -W 1 $i >/dev/null 2>&1	#Если пинганули, адрес оставляем
				[ "$?" == "0" ] && {

					break 4		#выходим из циклов

				}

			done

			ifconfig $eth down		#Если адреса не подошли, отключаем интерфейс

		done

	done

}



#Блок расчета количества продуктов
cd $confXML
for xml in *.xml			#Перебираем xmlки
do

	v=`$REGTOOL -r $xml /Config /UseGenConf`
	if [ "$v" == "1" ]		#Выделяем только те, которые используются в списках
	then

		Xml=`echo $Xml $xml`

	fi

done
Xml=`echo $Xml ZIP.xml | sed 's/.xml//g'`	#Список доступных продуктов

#Диалог с пользователем
while :
do

	#Выбор продукта и хоста
	while :
	do

		#Выбираем первый продукт
		DeleteTmpFile
		MakeDialogWindow "Выберите дейсвующий продукт." "--column=Продукт" "$Xml" $DATA/CWR_product.txt		#Диалог выбора хоста
		PRODUCT=`cat $DATA/CWR_product.txt`	#Записали результат диалога
		CancelButtonClicked $PRODUCT				#Если нажали Выход

		#Пингуем хосты выбранного продукта
		PingHosts $confXML/$PRODUCT.xml $1
		echo `cat $DATA/CWR_online.txt` >$DATA/CWR_online.txt		#Транспонируем таблицу в список
		HostsOnline=`cat $DATA/CWR_online.txt`								#Cохраняем списки хостов

		#Выбираем хост
		MakeDialogWindow "Выберите доступный компьютер." "--column=\"Имя\" --column=\"Описание\"" "$HostsOnline" $DATA/CWR_online.txt --extra-button="Назад"
		HOST=`cat $DATA/CWR_online.txt`
		CancelButtonClicked $HOST
		[ $HOST == "Назад" ] && { continue; }		#Возвращаемся назад в пункт меню
		break

	done

	#Выбор продукта и роли
	while :
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

		zenity --question --width=200 --title="Система управления ЗИП" --text="Применить роль $ROLE\nдля компьютера $HOST?\nПроцесс не обратим." --ok-label="Применить" --cancel-label="Назад"
		if [ $? == 0 ]			#Если нажали да, то задаем роль
		then

			if [ $HOSTNAME == $HOST ]		#Если выбрали локальный компьютер
			then

				(
				echo $ROLE> /$NITAROOT/HOSTNAME		#Генерируем выбранную роль, задаем хостнейм
				echo $PRODUCT> /$NITAROOT/PRODUCT	#Генерируем продукт
				$REGTOOL -w /$NITAROOT/etc/system.xml / Product $PRODUCT

				remount rw
				$GenerateConf GenerateConfig	#Генерируем конфигурацию для восьмерки
				$GenerateConf $PRODUCT GenerateConfig	#Генерируем конфигурацию для остальных
				) | zenity --progress --title="Выполнение" --text="Задаем роль $ROLE.." --pulsate --no-cancel --auto-close

				zenity --info --title="Завершение работы" --text="Изменения вступят в силу\nпосле перезагрузки компьютера.\nПерезагрузка через 3 сек." --ellipsize --timeout=3
				DeleteTmpFile

				reboot

			else

				#Здесь нужно разделить адреса и хостнейм(ZIP хостнейм неизвестен)
				if [ "$HOST" == ZIP ]
				then

					HOSTtext=$HOST
					HOST=$XMLaddr

				else

					HOSTtext=$HOST

				fi
				[ "$ROLE" == ZIP ] && { ROLEtext="ZIP"; }

				#Проверяем версию программы выбранного хоста
				ver1=`cat /soft/version | sed 's/\.//g'`
				ver2=`ssh $HOST cat /soft/version | sed 's/\.//g'`
				[ $ver1 -gt $ver2 ] && {	#Сравниваем файл версии

					zenity --question --title="Информация" --text="Версия ПО отличается от локальной версии.\nОбновить удаленный компьютер?" --ellipsize --ok-label="Да" --cancel-label="Нет"
					[ $? == 0 ] && {
						#Передаем софт
						rsync -av --delete --exclude HOSTNAME --exclude etc/system.xml --exclude PRODUCT /soft/ $HOST:/soft/

					} | zenity --progress --title="Обновление ПО" --text="Передача файлов.." --pulsate --no-cancel --auto-close

				}

				(
				echo $ROLE> /$NITAROOT/scripts/HOSTNAME		#Генерируем выбранную роль, задаем хостнейм
				echo $PRODUCT> /$NITAROOT/scripts/PRODUCT	#Генерируем продукт
				scp /$NITAROOT/scripts/HOSTNAME root@$HOST:/soft
				scp /$NITAROOT/scripts/PRODUCT root@$HOST:/soft
				ssh $HOST $REGTOOL -w /$NITAROOT/etc/system.xml / Product $PRODUCT

				ssh $HOST remount rw
				ssh $HOST $GenerateConf GenerateConfig	#Генерируем конфигурацию для восьмерки
				ssh $HOST $GenerateConf $PRODUCT GenerateConfig	#Генерируем конфигурацию для остальных
				) | zenity --progress --title="Выполнение" --text="Задаем роль $ROLEtext.." --pulsate --no-cancel --auto-close

				zenity --info --title="Завершение работы" --text="Изменения вступят в силу\nпосле перезагрузки компьютера.\nПерезагрузка через 3 сек." --ellipsize --timeout=3
				DeleteTmpFile

				ssh $HOST reboot

					(
					TIME=0		#Наблюдаем за компом
					while [ $TIME -lt 150 ]		#Если в течении 5 минут загрузится
					do

						if [ $ROLE == ZIP ]		#Если роль ЗИП, то нет конкретного адреса
						then

							for o in $XMLaddr	#Перебираем все возможные адреса
							do

								ping -c 1 -W 1 $o
								[ $? == 0 ] && { ok=0; break; }

							done

						else

							ping -c 1 -W 1 $ROLE
							[ $? == 0 ] && { ok=0; }

						fi
						[ "$ok" == 0 ] && { 	#Если пинганули, то все хорошо

							zenity --info --title=Успех --ellipsize --text="Компьютер $HOSTtext принял роль $ROLE." --timeout=3
							exit 0

						}
						sleep 1			#счетчик времени
						TIME=$(( $TIME + 1 ))

					done
					#Если не ответит, выход с предупреждением
					zenity --error --title=Внимание --ellipsize --text="Компьютер $HOSTtext в роли $ROLEtext не загрузился\nПроверьте подключение." --timeout=3
					) | zenity --progress --title="Выполнение" --text="Ищем компьютер $ROLE" --pulsate --no-cancel --auto-close
					exit 0

			fi

		else

			continue	#Если нажали отмена, повторяем цикл

		fi

	}

done