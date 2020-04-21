#!/bin/bash

DATA="/home/sad/Projects"		#"Переменные" окружения
SOFT="/home/sad/Projects/ROOT/soft"
SYSTEM="/home/sad/Projects/ROOT/system"
exclude="(\.so|\.qm|\.bin|\.7z|\.bak|\.debug|\.png|\.bmp|\.wav|\.WAV|\.xpm|\.so(\.[0-9]){1,4})$"

[[ -d "$DATA" ]] || {

	mkdir $DATA 

}

touch $DATA/ipchanger.txt			#/data/log/ipchanger.txt
echo "`date`	Скрипт запущен" &>>$DATA/ipchanger.txt

function logger {					#Запись событий в лог

	case $1 in
		0)
			echo "`date`	Ошибка запуска скрипта" &>>$DATA/ipchanger.txt
			;;
		1)
			echo "`date`	Изменен адрес $2 на $3 в файле $4" &>>$DATA/ipchanger.txt
			;;
		2)
			echo "`date`	Изменения не произведены. Адрес(а) по шаблону $2 не найдены" &>>$DATA/ipchanger.txt
			;;
		3)
			echo "`date`	Адрес по шаблону $2 уже существует:" &>>$DATA/ipchanger.txt
			;;
		4)
			echo "`date`	ВНИМАНИЕ. Адрес $2 существует вне каталога $3" &>>$DATA/ipchanger.txt
			;;
		5)
			echo "`date`	Для лучшей работы скрипта убран пробел в имени файла $2" &>>$DATA/ipchanger.txt
			;;

	esac

}

function validator {

	echo " "
	echo "$1. Введите $0 --help для справки" 1>&2
	echo " "
	logger 0
	exit 1

}

if [ "$#" = 0 ] 					#На случай, если не введены аргументы
then

	validator "Нет аргументов"

elif [ "$1" = "--help" ] 			#Объясняем как работает скрипт
then

	echo " "
	echo "Скрипт заменяет выбранный ip-адрес во всех конфигах "
	echo "из указанного каталога и подкаталогов на новый адрес"
	echo ""
	echo "Использование:"
	echo "$0 [Существующий адрес] [Новый адрес] [/Путь/..]"
	echo "Формат аргументов:"
	echo "[xxx.xxx.xxx] - Для смены первых трех октетов. Например 10.101.31.74 на 10.102.18.74"
	echo "[xxx.xxx.xxx.xxx] - Для замены всего адреса. Например 192.168.31.74 на 10.101.21.2 "
	echo "Старый и новый адрес должны совпадать по количеству октетов"
	echo " "

elif [[ "$1" =~ -\.* ]]				#Проверка валидности ключа
then

	validator "Неверный аргумент"

elif [ "$#" = 3 ]					#Если введены все аргументы
then
									#Проверяем введенные ip-адреса и путь
	[[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\.[0-9]{1,3}){0,1}$ ]] || {

		validator "Неверный аргумент"

	}

	[[ "$2" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\.[0-9]{1,3}){0,1}$ ]] || {

		validator "Неверный аргумент"

	}

	[[ -d "$3"  ]] || [[ -f "$3" ]] || {

		echo " "
		echo "Каталог(файл) $3 не существует. Проверьте имя файла и путь" 1>&2
		echo " "
		logger 0
		exit 1

	}

		old_ip=`echo $1 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'` 
		new_ip=`echo $2 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'`

	if [ "$1" = "$old_ip" -a "$2" = "$new_ip" ]	#Проверяем количество октетов
	then

		flag=1

	elif [ "$1" != "$old_ip" -a "$2" != "$new_ip" ]
	then

		flag=1

	else 

		validator "Количество октетов не совпадает"

	fi

	[[ "$flag" = 1 ]] && {

		echo " "
		echo "Скрипт запущен. Проверка файлов..."
		echo " "

		find $3 -type d -name "* *" >$DATA/ipchanger_space_tmp.txt		#Корректируем файлы с пробелами в имени
		find $3 -type f -name "* *" >>$DATA/ipchanger_space_tmp.txt		#Это нужно для нормальной работы скрипта. 
			while read LINE
			do

				base=`echo "$LINE" | tr ' ' '_'`
				mv "$LINE" $base 
				logger 5 $base

			done <$DATA/ipchanger_space_tmp.txt	
		rm $DATA/ipchanger_space_tmp.txt								#Не стоит оставлять пробелы в файлах. Тем более в *.xml

		counter=0		#Счетчик адресов
		case $1 in		#Проверяем конфликтные ситуации

			`echo $1 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1}$'`) 
				cat `find $3 -type f | egrep -v "$exclude"` | egrep -o -I "$1\.[0-9]{1,3}" >$DATA/ipchanger_ip_tmp.txt
				;;
			`echo $1 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{2}$'`)
				cat `find $3 -type f | egrep -v "$exclude"` | egrep -o -I "$1\.[0-9]{1,3}" >$DATA/ipchanger_ip_tmp.txt
				;;
			`echo $1 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1}$'`)
				cat `find $3 -type f | egrep -v "$exclude"` | egrep -o -I "$1\b" >$DATA/ipchanger_ip_tmp.txt
				;;
			`echo $1 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{2}$'`)
				cat `find $3 -type f | egrep -v "$exclude"` | egrep -o -I "$1\b" >$DATA/ipchanger_ip_tmp.txt
				;;
			`echo $1 | egrep '^[0-9]{1,3}(\.[0-9]{1,3}){2,3}$'`)
				cat `find $3 -type f | egrep -v "$exclude"` | egrep -o -I "$1(\.[0-9]{1,3}){0,1}" >$DATA/ipchanger_ip_tmp.txt
				;;

		esac			#Выводим доступные адреса во временный файл

			find $3 -type f | egrep -v "$exclude" >$DATA/ipchanger_path_tmp.txt					#Выводим список файлов во временный файл
			sort -u $DATA/ipchanger_ip_tmp.txt --output=$DATA/ipchanger_ip_tmp.txt				#Сортируем адреса, чтобы не было повторений

		for pattern1 in `cat $DATA/ipchanger_ip_tmp.txt`	#Проверяем существующие адреса
		do

			pattern2=`echo ${pattern1/$1/$2}`	#Создаем шаблон второго адреса

			if [[ `grep -rn -I "$3" -e "$pattern2" | egrep -v "$exclude"` ]]
			then 

				logger 3 $pattern2
				grep -rn -I "$3" -e "$pattern2" &>>$DATA/ipchanger.txt
				flag=2

			elif [[ `grep -rn -I $SOFT -e $pattern2 | egrep -v "$exclude"` ]]
			then

				logger 4 $pattern2 $3
				grep -rn -I "$SOFT" -e "$pattern2" &>>$DATA/ipchanger.txt

			elif [[ `grep -rn -I $SYSTEM -e $pattern2 | egrep -v "$exclude"` ]]
			then

				logger 4 $pattern2 $3
				grep -rn -I "$SYSTEM" -e "$pattern2" &>>$DATA/ipchanger.txt

			fi

		done

		[[ "$flag" = 2 ]] && {

			echo "Адрес(а) уже существуют. Подробнее в логе $DATA/ipchanger.txt" 1>&2
			echo " "
			rm $DATA/ipchanger_ip_tmp.txt				#Удаляем временные файлы
			rm $DATA/ipchanger_path_tmp.txt
			logger 2 $old_ip
			exit 1

		}

		for pattern1 in `cat $DATA/ipchanger_ip_tmp.txt`		#Читаем из файла строки с адресами
		do

			pattern2=`echo ${pattern1/$1/$2}`					#Создаем шаблон второго адреса

			for path in `cat $DATA/ipchanger_path_tmp.txt`		#Читаем из файла строки с файлами
			do

				[[ `grep $path -o -e $pattern1` ]] && {

					sed -i "s/${pattern1}/${pattern2}/g" $path 2>>$DATA/ipchanger.txt 	#Заменяем ip адреса
					logger 1 $pattern1 $pattern2 $path
					counter=$[counter + 1]

				}

			done

		done

	}

	rm $DATA/ipchanger_ip_tmp.txt				#Удаляем временные файлы
	rm $DATA/ipchanger_path_tmp.txt

	if [ "$counter" != 0 ] 
	then

		echo "Изменено $counter адресов. Подробнее в логе $DATA/ipchanger.txt"
		echo " "

	else

		echo "Адресов не найдено. Замены не произведены" 1>&2
		echo " "
		logger 2 $old_ip
		exit 1

	fi

else								#Когда аргументов недостаточно

	validator "Недостаточно аргументов"

fi