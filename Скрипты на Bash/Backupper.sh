#!/bin/bash

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
	echo "	    формат: /каталог/файл или /файл "
	echo "Пример: ./Backupper.sh 60m /soft"
	echo " "

elif [ $# -ne 2 ]
then

	#Проверка количества аргументов
	echo " "
	echo "Справка по запуску. --help"
	echo " "
	exit

fi

function BackUp {

	#Формируем текущую дату в удобном формате
	Date=`date +%F`
	Time=`date +%X`
	Time=${Time//:/-}
	Prefix=`echo $1 | sed 's/\W/-/g' | cut -c2-`
	#Создаем архив с текущей датой
	tar -cf /data/tmp/backups/${Prefix}_D${Date}_T$Time.tar

}


#Запускаем скрипт в фоновом режиме
while true
do

	#Создание первого архива, от которого пойдут проверки
	#Создаем каталог бекапов если такого нет
	mkdir /data/tmp/backups
	Prefix=`echo $2 | sed 's/\W/-/g' | cut -c2-`
	if [ -z `ls /data/tmp/backups | grep  ${Prefix}_D` ]
	then
		#Если архива не существует, создаем новый(первый)
		touch $2/changes.txt
		ls -R -l -t -I changes.txt $2 | egrep -v inventory.txt > $2/inventory.txt
		BackUp $2

	fi

	sleep $1

	#Определяем самый последний существующий бекап
	lastBackup=`ls -t /data/tmp/backups | grep ${Prefix}_D | head -1`
	#Вынимаем список каталогов из архива и создаем новый
	str=`echo $2 | cut -c2-`
	tar -xf /data/tmp/backups/$lastBackup -C /data/tmp/backups $str/inventory.txt
	ls -R -l -t -I changes.txt $2 | egrep -v inventory.txt > $2/inventory.txt
	touch $2/changes.txt
	#Сравниваем оба списка
	diff -c -2 /data/tmp/backups/$2/inventory.txt $2/inventory.txt > $2/changes.txt

	if [ `echo $?` != 0 ]
	then

		#Если есть изменения, создаем новый архив
		BackUp $2

	fi
	rm $2/inventory.txt $2/changes.txt

done