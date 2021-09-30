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
	tar -cf /data/tmp/backups/${Prefix}_D${Date}_T$Time.tar -g /data/tmp/backups/$d $1
	echo "Архив ${Prefix}_D${Date}_T$Time.tar создан"

}


#Проверка аргументов
frs=`echo $1 | egrep -o "[0-9]{1,}[smh]{1}"`
scd=`echo $2 | egrep -o "(\/{1}|((\/{1}\w+\/?)+([\.|\-]{1}\w+)?))"`

#Справка по запуску
if [ "$1" == "--help" ]
then

	echo " "
	echo "Скрипт для периодического создания бекапов"
	echo "при возникновении изменений в каталогах"
	echo "Формат запуска: ./Baсkupper время каталог"
	echo "	время: период проверки наличия изменений"
	echo "	    формат: ЧИСЛО[минуты] Xm или ЧИСЛО[часы] Xh"
	echo "	каталог: путь до архивируемого каталога"
	echo "	    формат: /каталог/файл или /файл или /файл.тип"
	echo "Пример: ./Backupper.sh 60m /soft"
	echo " "
	exit

elif [ "$#" -ne 2 ] || [ "$1" != "$frs" ] || [ "$2" != "$scd" ]
then

	#Подсказка в случае ошибки
	echo " "
	echo "Справка по запуску. --help"
	echo " "
	exit

fi


#Запускаем скрипт в фоновом режиме
while true
do

	#Создание первого архива, от которого пойдут проверки
	#Создаем каталог бекапов если такого нет
	mkdir /data/tmp/backups
	Prefix=`echo $2 | sed 's/\W/-/g' | cut -c2-`
	if [ -z `ls /data/tmp/backups | egrep ${Prefix}_D.*.tar` ]
	then
		#Если архива не существует, создаем новый(первый)
		touch $2/changes.txt
		ls -R -l -t -I changes.txt $2 | egrep -v inventory.txt > $2/inventory.txt
		BackUp $2 now

	fi

	#Определяем самый последний существующий бекап
	lastBackup=`ls -t /data/tmp/backups | grep ${Prefix}_D.*.tar | head -1`
	lastSnar=`ls -t /data/tmp/backups | grep ${Prefix}_D.*.snar | head -1`
	#Вынимаем список каталогов из архива и создаем новый
	str=`echo $2 | cut -c2-`
	tar -xf /data/tmp/backups/$lastBackup -C /data/tmp/backups $str/inventory.txt
	ls -R -l -t -I changes.txt $2 | egrep -v inventory.txt > $2/inventory.txt
	touch $2/changes.txt
	#Сравниваем оба списка
	diff -ru /data/tmp/backups/$str/inventory.txt $2/inventory.txt > $2/changes.txt
	if [ `echo $?` != 0 ]
	then

		#Если есть изменения, создаем новый архив
		BackUp $2 $lastSnar

	fi
	rm $2/inventory.txt $2/changes.txt

	sleep $1

done