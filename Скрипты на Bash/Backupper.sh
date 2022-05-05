#!/bin/bash

function FreeSpaceCheck {

	freespace1=`df -hm /data/ | egrep -o "[0-9]{1,}\s" | tail -1`
	freespace2=`df -hm $1 | egrep -o "[0-9]{1,}%" | tail -1 | egrep -o "[0-9]{1,}"`
	[ "$freespace1" -lt "2000" -o "$freespace2" -gt "95" ] && {

		zenity --warning --title="Backupper" --text="Недостаточно места в каталогах\n/data или $1\nОсвободите место!" --ellipsize --timeout=30
		exit

	}

}

function BackUp {

	#Формируем текущую дату в удобном формате
	Date=`date +%F`
	Time=`date +%X`
	Time=${Time//:/-}
	Prefix=`echo $1 | sed 's/\W/-/g' | cut -c2-`
	if [ "$2" == "now" ]
	then

		#Задаем дату для первого файла snar
		d=${Prefix}_D${Date}_T$Time.snar

	else 

		d=$2

	fi
	#Создаем архив с текущей датой
	cd /data/tmp/backups$1
	tar -cf /data/tmp/backups$1/${Prefix}_D${Date}_T$Time.tar -g /data/tmp/backups$1/$d $1 inventory.txt changes.txt
	echo "Архив ${Prefix}_D${Date}_T$Time.tar создан"
	cd /data

}





#Проверка аргументов
frs=`echo $1 | egrep -o "[0-9]{1,}[smh]{1}"`
scd=`echo $2 | egrep -o "(\/{1}|((\/{1}\w+\/?)+([\.|\-]{1}\w+)?))" | sed 's/[\/]$//'`
#Справка по запуску
if [ "$#" -ne 2 ] || [ "$1" != "$frs" ] || [ ! -e "$scd" ]
then

	echo " "
	echo " Скрипт для периодического создания бекапов"
	echo " при возникновении изменений в каталогах"
	echo " Формат запуска: ./Baсkupper время каталог"
	echo "	время: период проверки наличия изменений"
	echo "	    формат: ЧИСЛО[минуты] Xm или ЧИСЛО[часы] Xh"
	echo "	каталог: путь до архивируемого каталога"
	echo "	    формат: /каталог/файл или /файл или /файл.тип"
	echo " Пример: ./Backupper.sh 60m /soft"
	echo " "
	exit 0

fi



#Запускаем скрипт в фоновом режиме
Flag=0
while true
do

	#Создание первого архива, от которого пойдут проверки
	#Создаем каталог бекапов если такого нет
	[ -e "/data/tmp/backups$scd" ] || { mkdir -p /data/tmp/backups$scd; }

	#Префикс имени это название каталога, который резервируется
	Prefix=`echo $2 | sed 's/\W/-/g' | cut -c2-`
	if [ -z `ls /data/tmp/backups/$scd | egrep ${Prefix}_D.*.snar` ]
	then

		FreeSpaceCheck $scd
		#Если архива не существует, создаем новый(первый)
		touch /data/tmp/backups$scd/changes.txt	#Проводим инвентаризацию ПО
		ls -R -l -t $scd > /data/tmp/backups$scd/inventory.txt
		BackUp $scd now

	else

		FreeSpaceCheck $scd
		#Определяем самый последний существующий бекап
		lastBackup=`ls -t /data/tmp/backups$scd | grep ${Prefix}_D.*.tar | head -1`
		lastSnar=`ls -t /data/tmp/backups$scd | grep ${Prefix}_D.*.snar | head -1`
		#Вынимаем список каталогов из архива и создаем новый
		tar -xf /data/tmp/backups$scd/$lastBackup -C /data/tmp/backups inventory.txt	#Записи из архива
		tar -xf /data/tmp/backups$scd/$lastBackup -C /data/tmp/backups changes.txt
		ls -R -l -t $scd > /data/tmp/backups$scd/inventory.txt							#Текущая инвентаризация
		#Сравниваем оба списка
		diff -r -u1 /data/tmp/backups$scd/inventory.txt /data/tmp/backups/inventory.txt >/dev/null 2>&1
		if [ `echo $?` != 0 ]
		then

			#Если есть изменения, создаем новый архив
			date > /data/tmp/backups$scd/changes.txt
			diff -r -u1 /data/tmp/backups$scd/inventory.txt /data/tmp/backups/inventory.txt >> /data/tmp/backups$scd/changes.txt
			echo -e "\n\n" >> /data/tmp/backups$scd/changes.txt
			cat /data/tmp/backups/changes.txt >> /data/tmp/backups$scd/changes.txt
			BackUp $scd $lastSnar

		fi

	fi

	#Спрашиваем, чистить ли последовательность бекапов
	#Когда заканчивается место
	freespace1=`df -hm /data/ | egrep -o "[0-9]{1,}\s" | tail -1`
	freespace2=`df -hm $scd | egrep -o "[0-9]{1,}%" | tail -1 | egrep -o "[0-9]{1,}"`
	backupsusage=`du -shm /data/tmp/backups | egrep -o "[0-9]{1,}"`
	[ "$freespace1" -lt "4000" -o "$freespace2" -gt "90" ] && {

		killall -9 zenity
		zenity --question --text="Заканчивается место в каталогах\n/data и $scd\nУдалить созданные бекапы?\nБекапов сделано на $backupsusage Mb\nНажмите \'Нет\' чтобы бекапить дальше" --ellipsize --ok-label=Да --cancel-label=Нет
		[ $? == "0" ] && { rm -rf /data/tmp/backups$scd; }

	}
	#Когда прошла неделя
	if [ `date +%a` == "Вс" -a $Flag == "0" ]
	then

		killall -9 zenity
		zenity --question --text="Удалить созданные бекапы?\nБекапов сделано на $backupsusage Mb\nМеста в /data осталось $freespace1 Mb\nМеста в $scd осталось $((100 - freespace2)) %\nНажмите \'Нет\' чтобы бекапить дальше" --ellipsize --ok-label=Да --cancel-label=Нет
		[ $? == "0" ] && { rm -rf /data/tmp/backups$scd; }
		Flag=1

	fi

	[ `date +%a` == "Пн" ] && { Flag=0; }
	rm /data/tmp/backups/inventory.txt /data/tmp/backups/changes.txt
	sleep $frs

done