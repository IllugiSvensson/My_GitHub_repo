#!/bin/bash

function DeleteTmpFile {

	rm -f /soft/scripts/kdialogtr.sh		#Удаляем временные файлы
	rm -f /soft/scripts/answer.txt

}

function CancelButtonClicked {		#Выход из окна при нажании на Отмена или х

	if [ -z "$1" ]
	then

		DeleteTmpFile
		zenity --warning --ellipsize --text="Нажата отмена или\nне выбран компьютер!" --title="Предупреждение" --timeout=2
		exit 1

	fi

}


#Блок отключения других экземпляров программы при повторном запуске
FindPIDs=`pgrep -f "remoteTroll.sh"`	#Ищем PID процесса(ов)
for RunPID in $FindPIDs
do

	if [ "$RunPID" != "$$" ]	#Перебираем PID'ы и если есть не текущий
	then

		kill $RunPID		#Убиваем его вместе со
		killall zenity		#всеми активными окнами

	fi

done

for HOST in SRV1 SRV2			#Просматриваем сервера
do

	ping -c 1 -W 1 $HOST >/dev/null 2>&1
	if [ $? == 0 ]		#Если хоть один адрес ответил
	then

		DESCRIPTION=`/system/bin/regtool.bin -r /system/etc/K23800/Ship.xml /Hosts/$HOST Description $HOST`
		name=`echo $name $HOST \"$DESCRIPTION\"`		#Пишем сервер в список

	fi

done

[ -z $name ] && {		#На случай, если сервера не в сети

	zenity --warning --ellipsize --text="Сервера не в сети.\nПроверьте подключение." --title="Предупреждение" --timeout=3
	exit 1

}

ListItem="zenity --title=\"Настройка дисков\" --height=350 --width=350 --list --text=\"Выберите доступный компьютер.\" --column=\"Имя\" --column=\"Описание\" --ok-label=\"Применить\" --cancel-label=\"Выход\""
ListItem="$ListItem $name"

cd /soft/scripts
rm -f kdialogtr.sh		#Создаем основное диалоговое окно
echo -E "#! /bin/bash" >>kdialogtr.sh
echo -E "RESULT=\`$ListItem\`" >>kdialogtr.sh
echo -E "echo \$RESULT" >>kdialogtr.sh
chmod +x kdialogtr.sh
./kdialogtr.sh > answer.txt	#Фиксируем вывод окна
answer=`cat answer.txt`
DeleteTmpFile
CancelButtonClicked $answer

#Запускаем тролля на удаленном сервере
ssh $answer killall diskconf.bin
ssh $answer /system/scripts/diskconf.sh