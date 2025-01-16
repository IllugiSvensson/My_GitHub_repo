#!/bin/bash



function DeleteTmpFile {

	rm -f /soft/scripts/kdialogtr.sh	#Удаляем временные файлы
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
FindPIDs=`pgrep -f "metrocorrector.sh"`	#Ищем PID процесса(ов)
for RunPID in $FindPIDs
do

	if [ "$RunPID" != "$$" ]	#Перебираем PID'ы и если есть не текущий
	then

		kill $RunPID		#Убиваем его вместе со
		killall zenity		#всеми активными окнами

	fi

done

for HOST in SRV1 SRV2 AZN1 AZN2 KRP1 KRP2	#Просматриваем сервера
do

	ping -c 3 -W 1 $HOST >/dev/null 2>&1
	if [ $? == 0 ]		#Если хоть один адрес ответил
	then

		DESCRIPTION=`/system/bin/regtool.bin -r /system/etc/K23800/Ship.xml /Hosts/$HOST Description $HOST`
		name=`echo $name $HOST \"$DESCRIPTION\"`		#Пишем сервер в список
		echo $name > /soft/scripts/answer.txt

	fi

done |	zenity --progress --title="Выполнение" --text="Ищем компьютеры.." --pulsate --no-cancel --auto-close
name=`cat /soft/scripts/answer.txt`

[ -z $name ] && {		#На случай, если сервера не в сети

	zenity --warning --ellipsize --text="Компьютеры не в сети.\nПроверьте подключение." --title="Предупреждение" --timeout=3
	exit 1

}

ListItem="zenity --title=\"Корректор метронома\" --height=350 --width=350 --list --text=\"Выберите доступный компьютер.\" --column=\"Имя\" --column=\"Описание\" --ok-label=\"Применить\" --cancel-label=\"Выход\""
ListItem="$ListItem $name"

cd /soft/scripts
rm -f kdialogtr.sh		#Создаем основное диалоговое окно
echo -E "#! /bin/bash" >>kdialogtr.sh
echo -E "RESULT=\`$ListItem\`" >>kdialogtr.sh
echo -E "echo \$RESULT" >>kdialogtr.sh
chmod +x kdialogtr.sh
./kdialogtr.sh > /soft/scripts/answer.txt	#Фиксируем вывод окна
answer=`cat /soft/scripts/answer.txt`
DeleteTmpFile
CancelButtonClicked $answer

#Запускаем тролля на удаленном сервере
ssh $answer killall metrocorrector.bin
ssh $answer launch metrocorrector &
sleep 1s
pid=`ssh $answer pgrep metrocorrector.bin`
ssh $answer tail --pid=$pid -f /dev/null