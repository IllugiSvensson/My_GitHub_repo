#!/bin/bash

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
	tar -cf /data/tmp/backups/$1/${Prefix}_D${Date}_T$Time.tar -g /data/tmp/backups/$1/$d $1
	echo "Архив ${Prefix}_D${Date}_T$Time.tar создан"

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
	[ -e "/data/tmp/backups/$scd" ] || { mkdir -p /data/tmp/backups/$scd; }

	#Префикс имени это название каталога, который резервируется
	Prefix=`echo $2 | sed 's/\W/-/g' | cut -c2-`
	if [ -z `ls /data/tmp/backups/$scd | egrep ${Prefix}_D.*.snar` ]
	then
		#Если архива не существует, создаем новый(первый)
		touch $scd/changes.txt	#Проводим инвентаризацию ПО
		ls -R -l -t -I changes.txt $2 | egrep -v inventory.txt > $scd/inventory.txt
		BackUp $scd now

	else

		#Определяем самый последний существующий бекап
		lastBackup=`ls -t /data/tmp/backups/$scd | grep ${Prefix}_D.*.tar | head -1`
		lastSnar=`ls -t /data/tmp/backups/$scd | grep ${Prefix}_D.*.snar | head -1`
		#Вынимаем список каталогов из архива и создаем новый
		str=`echo $2 | cut -c2-`
		tar -xf /data/tmp/backups/$scd/$lastBackup -C /data/tmp/backups $str/inventory.txt
		tar -xf /data/tmp/backups/$scd/$lastBackup -C /data/tmp/backups $str/changes.txt
		ls -R -l -t -I changes.txt $2 | egrep -v inventory.txt > $scd/inventory.txt
		#Сравниваем оба списка
		echo " " >> $2/changes.txt
		echo " " >> $2/changes.txt
		date >> $2/changes.txt
		diff -r -u1 /data/tmp/backups/$str/inventory.txt $2/inventory.txt >> $2/changes.txt
		if [ `echo $?` != 0 ]
		then

			#Если есть изменения, создаем новый архив
			cat /data/tmp/backups/$str/changes.txt >> $2/changes.txt
			BackUp $2 $lastSnar

		fi

	fi

	#Спрашиваем, чистить ли последовательность бекапов
	#Когда заканчивается место
	freespace=`df -hm /data/ | egrep -o "[0-9]{1,}\s" | tail -1`
	backupsusage=`du -shm /data/tmp/backups | egrep -o "[0-9]{1,}"`
	if [ $freespace -lt 500 ]
	then

		killall -9 zenity
		zenity --question --text="Удалить созданные бекапы?\nБекапов сделано на $backupsusage Mb\nМеста в /data осталось $freespace Mb\n\nНажмите \'Нет\' чтобы бекапить дальше" --ellipsize --ok-label=Да --cancel-label=Нет
		[ $? == "0" ] && { rm -rf /data/tmp/backups/$str; }

	fi
	#Когда прошла неделя
	if [ `date +%a` == "Вс" -a $Flag == "0" ]
	then

		killall -9 zenity
		zenity --question --text="Удалить созданные бекапы?\nБекапов сделано на $backupsusage Mb\nМеста в /data осталось $freespace Mb\n\nНажмите \'Нет\' чтобы бекапить дальше" --ellipsize --ok-label=Да --cancel-label=Нет
		[ $? == "0" ] && { rm -rf /data/tmp/backups/$str; }
		Flag=1

	fi

	[ `date +%a` == "Пн" ] && { Flag=0; }
	rm $2/inventory.txt $2/changes.txt
	sleep $frs

done