#!/bin/bash

DATA="/data/log"		#Переменные окружения
NITAROOT="/system"
NITASOFT="/soft"
SYSTEM="/system/etc"
SOFT="/soft/etc"
exclude="(\.so|\.qm|\.bin|\.7z|\.bak|\.debug|\.png|\.bmp|\.wav|\.WAV|\.xpm|\.so(\.[0-9]){1,4})$"	#Список исключений из проверок

[[ -d "$DATA" ]] || {			#Если каталога /data/log нет, то создаем его

	mkdir $DATA 

}

touch $DATA/syseditor.txt			
echo "`date`	Скрипт запущен" &>>$DATA/syseditor.txt

function logger {				#Запись событий в лог

	case $1 in
		0)							#Возможные ошибки или неуспешное выполнение
			echo "`date`	Ошибка запуска скрипта" &>>$DATA/syseditor.txt
			;;
		1)
			echo "`date`	Изменения не произведены. Адрес(а) по шаблону $2 не найдены" &>>$DATA/syseditor.txt
			;;	
		2)
			echo "`date`	Обнаружена битая ссылка $2" &>>$DATA/syseditor.txt
			;;	
		3)							#Предупреждения
			echo "`date`	ВНИМАНИЕ. Адрес $2 существует вне каталога $3" &>>$DATA/syseditor.txt
			;;
		4)
			echo "`date`	Адрес по шаблону $2 уже существует:" &>>$DATA/syseditor.txt
			;;
		5)
			echo "`date`	Для лучшей работы скрипта заменён пробел в имени файла $2" &>>$DATA/syseditor.txt
			;;
		6)
			echo "`date`	Попытка корректировки ссылки $2" &>>$DATA/syseditor.txt
			;;
		7)							#Успешное выполнение скрипта
			echo "`date`	Изменен адрес $2 на $3 в файле $4" &>>$DATA/syseditor.txt
			;;
		8)
			echo "`date`	Изменено наименование продукта на $2 в $3" &>>$DATA/syseditor.txt
			;;
		9)
			echo "`date`	Изменено наименование конфига на $2 в $3" &>>$DATA/syseditor.txt
			;;
		10)
			echo "`date`	Переименован каталог $2/$3 в $2/$4" &>>$DATA/syseditor.txt
			;;
		11)
			echo "`date`	Создана ссылка $2 на $3" &>>$DATA/syseditor.txt
			;;

	esac

}

function validator {			#Проверка валидности выполнения скрипта

	echo " "
	echo "$1. Введите $0 --help для справки" 1>&2
	echo " "
	logger 0
	exit 1

}

if [ "$#" = 0 ] 				#На случай, если не введены аргументы
then

	validator "Нет аргументов"

elif [ "$1" = "--help" ] 		#Объясняем как работает скрипт
then

	echo " "
	echo "Скрипт предназначен для автоматического редактирования параметров системы"
	echo "Имеется два режима работы:"
	echo " "
	echo " - Режим смены конфига. Определяется ключом -cfg" 
	echo "Скрипт автоматически проверяет текущий конфиг, определенный"
	echo "в файле system.xml и преобразует систему под объект, заданный пользователем"
	echo "	Использование:"
	echo "	$0 -cfg [Новый конфиг]"
	echo " "
	echo " - Режим смены адресов. Определяется ключом -ip"
	echo "Скрипт заменяет выбранный ip-адрес во всех конфигах из указанного каталога,"
	echo "а так же подкаталогах или файлах на новый адрес"
	echo "Старый и новый адрес должны совпадать по количеству октетов"
	echo "ВНИМАНИЕ! Скрипт для своей работы может заменить пробелы в имени файлов на _"
	echo "	Использование:"
	echo "	$0 -ip [Существующий адрес] [Новый адрес] [/Путь/..]"
	echo "	Формат аргументов:"
	echo "	[xxx.xxx.xxx] - Для смены первых трех октетов. Например 10.101.31.74 на 10.101.18.74"
	echo "	При этом последний октет останется без изменений во всех подходящих адресах"
	echo "	[xxx.xxx.xxx.xxx] - Для замены конкретного адреса. Например 192.168.31.74 на 10.101.21.2 "
	echo " "
	echo "Разработан под Астра 1.6"
	echo " "

elif [ "$1" = "-cfg" ]			#Режим работы с конфигами
then

	mode=1

elif [ "$1" = "-ip" ]			#Режим работы с адресами
then

	mode=2

elif [[ "$1" =~ -\.* ]]			#Проверка валидности ключа
then

	validator "Неверный аргумент"

else							#Когда не выбран режим работы

	validator "Режим работы не выбран"

fi

if [ "$mode" = 1 ]				#Работаем в режиме смены конфига
then

	echo " "
	echo "Скрипт запущен в режиме работы с конфигами"

		base_string=`cat $SOFT/system.xml | grep Config` 2>>$DATA/syseditor.txt		#Сначала проверям какой конфиг установлен
		old_Config=`echo ${base_string:17} | egrep -o '\w{1,20}'`					#Перейдем в каталог и проверим файл system.xml

	if [ "$#" = 1 ]					#Проверим наличия конфига после ключа
	then

		validator "Не указано имя нового конфига"

	fi

		validConfig=`echo $2 | egrep -o '\w{1,20}'`				#Проверяем ввод аргументов, Создаем разрешенный шаблон

	if [ "$2" != "$validConfig" ]	#Сравниваем ввод с шаблоном
	then

		validator "Ошибка в записи аргументов"

	fi

		echo " "
		echo "Текущий конфиг: "		#Вывод информации о системе
		cat $SOFT/system.xml 2>>$DATA/syseditor.txt

	sed -i "s/${old_Config}/${2}/g" $SOFT/system.xml 2>>$DATA/syseditor.txt && logger 9 $2 $SOFT/system.xml  #Заменяем старый конфиг на новый
	length=`echo ${old_Config} | wc -c`							#Определим длину строки нового конфига

	for i in $SOFT $SYSTEM				#Перейдём в действующие каталоги
	do

		cd $i

			for m in *						#Переберём все вложенные файлы
			do

				bs=`echo ${m:(length - 1)}`
				base="${old_Config}${bs}"		#Создадим шаблон

					if [ "$m" = "$base" ]			#Если имя файла совпадает с шаблоном
					then

						[[ "$2" = "$old_Config" ]] || {

							mv $base ${2}${bs} 2>>$DATA/syseditor.txt && logger 10 $i $base ${2}${bs} #Переименовываем по шаблону

						}

					fi

				done

		done

		cd $SYSTEM/$2					#Перейдем в каталог со ссылками на софт

	for i in *							#Правим объектовые битые ссылки
	do

		[ -h "$i" ] && {

			Link=$i															#Запоминаем название ссылки
			rm $i 2>>$DATA/syseditor.txt									#Удаляем битую ссылку
			ln -s $SOFT/$2/$Link $Link 2>>$DATA/syseditor.txt && logger 11 $SYSTEM/$2/$Link $SOFT/$2/$Link	#Создаем новую ссылку

		}

	done

		echo " "
		echo "Объектовые ссылки исправлены. Новый конфиг:"		#Вывод информации о системе
		cat $SOFT/system.xml 2>>$DATA/syseditor.txt

	counter=0;		#Счетчик битых ссылок
	for i in `find $NITAROOT -type l` `find $NITASOFT -type l` #Пробуем поправить образовавшиеся битые ссылки 
	do

		[ -h "$i" -a ! -e "$i" ] && {

			broken_link=`echo $i | egrep -o "\w{1,20}\.{0,1}\w{1,20}$"` 2>>$DATA/syseditor.txt #Выделяем имя ссылки
			path=`echo ${i%$broken_link}`								2>>$DATA/syseditor.txt #и путь до неё

				cd $path												2>>$DATA/syseditor.txt
				target=`ls -l | grep $broken_link | egrep -o "/.*"`		2>>$DATA/syseditor.txt #Выделяем целевой файл
				rm $path$broken_link									2>>$DATA/syseditor.txt #Удаляем битую ссылку
				cor_path=`echo ${target/$old_Config/$2}`				2>>$DATA/syseditor.txt #Корректируем путь до цели
				ln -s $cor_path $i										2>>$DATA/syseditor.txt #Создаем новую ссылку

			logger 6 $i 

		}

	done

	for i in `find $NITAROOT -type l` `find $NITASOFT -type l` #Проверяем, остались ли битые ссылки
	do

		[ -h "$i" -a ! -e "$i" ] && {

			counter=$[counter + 1]
			logger 2 $i

		}

	done

	[[ "$counter" = 0 ]] || {

		echo " "
		echo "Обнаружено $counter битых ссылки. Подробнее в логе $DATA/syseditor.txt"
		echo " "

	}

elif [ "$mode" = 2 ]			#Работает в режиме смены адресов
then

	echo " "
	echo "Скрипт запущен в режиме работы с адресами"

	if [ "$#" = 1 ]
	then

		validator "Адреса не указаны"

	elif [ "$#" = 4 ]					#Если введены все аргументы
	then
										#Проверяем введенные ip-адреса и путь
		[[ "$2" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\.[0-9]{1,3}){0,1}$ ]] || {

			validator "Неверный аргумент"

		}

		[[ "$3" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\.[0-9]{1,3}){0,1}$ ]] || {

			validator "Неверный аргумент"

		}

		[[ -d "$4"  ]] || [[ -f "$4" ]] || {

			echo " "
			echo "Каталог(файл) $4 не существует. Проверьте имя файла и путь" 1>&2
			echo " "
			logger 0
			exit 1

		}

		old_ip=`echo $2 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'` 
		new_ip=`echo $3 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'`

		if [ "$2" = "$old_ip" -a "$3" = "$new_ip" ]		#Проверяем количество октетов
		then

			flag=1

		elif [ "$2" != "$old_ip" -a "$3" != "$new_ip" ]
		then

			flag=1

		else 

			validator "Количество октетов не совпадает"

		fi

		[[ "$flag" = 1 ]] && {

			echo " "
			echo "Проверка файлов..."
			echo " "

			find $4 -type d -name "* *" >$DATA/syseditor_space_tmp.txt		#Корректируем файлы с пробелами в имени
			find $4 -type f -name "* *" >>$DATA/syseditor_space_tmp.txt		#Это нужно для нормальной работы скрипта
				while read LINE
				do

					base=`echo "$LINE" | tr ' ' '_'`
					mv "$LINE" $base 
					logger 5 $base

				done <$DATA/syseditor_space_tmp.txt
			rm $DATA/syseditor_space_tmp.txt								#Не стоит оставлять пробелы в файлах. Тем более в *.xml

			counter=0		#Счетчик адресов
			case $2 in		#Проверяем конфликтные ситуации

				`echo $2 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1}$'`) 
					cat `find $4 -type f | egrep -v "$exclude"` | egrep -o -I "$2\.[0-9]{1,3}" >$DATA/syseditor_ip_tmp.txt
					;;
				`echo $2 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{2}$'`)
					cat `find $4 -type f | egrep -v "$exclude"` | egrep -o -I "$2\.[0-9]{1,3}" >$DATA/syseditor_ip_tmp.txt
					;;
				`echo $2 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1}$'`)
					cat `find $4 -type f | egrep -v "$exclude"` | egrep -o -I "$2\b" >$DATA/syseditor_ip_tmp.txt
					;;
				`echo $2 | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{2}$'`)
					cat `find $4 -type f | egrep -v "$exclude"` | egrep -o -I "$2\b" >$DATA/syseditor_ip_tmp.txt
					;;
				`echo $2 | egrep '^[0-9]{1,3}(\.[0-9]{1,3}){2,3}$'`)
					cat `find $4 -type f | egrep -v "$exclude"` | egrep -o -I "$2(\.[0-9]{1,3}){0,1}" >$DATA/syseditor_ip_tmp.txt
					;;

			esac			#Выводим доступные адреса во временный файл

				find $4 -type f | egrep -v "$exclude" >$DATA/syseditor_path_tmp.txt					#Выводим список файлов во временный файл
				sort -u $DATA/syseditor_ip_tmp.txt --output=$DATA/syseditor_ip_tmp.txt				#Сортируем адреса, чтобы не было повторений

			for pattern1 in `cat $DATA/syseditor_ip_tmp.txt`	#Проверяем существующие адреса
			do

				pattern2=`echo ${pattern1/$2/$3}`	#Создаем шаблон второго адреса

				if [[ `grep -rn -I "$4" -e "$pattern2" | egrep -v "$exclude"` ]]
				then 

					logger 4 $pattern2
					grep -rn -I "$4" -e "$pattern2" &>>$DATA/syseditor.txt
					flag=2

				elif [[ `grep -rn -I $NITASOFT -e $pattern2 | egrep -v "$exclude"` ]]
				then

					logger 3 $pattern2 $4
					grep -rn -I "$NITASOFT" -e "$pattern2" &>>$DATA/syseditor.txt

				elif [[ `grep -rn -I $NITAROOT -e $pattern2 | egrep -v "$exclude"` ]]
				then

					logger 3 $pattern2 $4
					grep -rn -I "$NITAROOT" -e "$pattern2" &>>$DATA/syseditor.txt

				fi

			done

				[[ "$flag" = 2 ]] && {

					echo "Адрес(а) уже существуют. Подробнее в логе $DATA/syseditor.txt" 1>&2
					echo " "
					rm $DATA/syseditor_ip_tmp.txt				#Удаляем временные файлы
					rm $DATA/syseditor_path_tmp.txt
					logger 1 $old_ip
					exit 1

				}

			for pattern1 in `cat $DATA/syseditor_ip_tmp.txt`		#Читаем из файла строки с адресами
			do

				pattern2=`echo ${pattern1/$2/$3}`					#Создаем шаблон второго адреса

				for path in `cat $DATA/syseditor_path_tmp.txt`		#Читаем из файла строки с файлами
				do

					[[ `grep $path -o -e $pattern1` ]] && {

						sed -i "s/${pattern1}/${pattern2}/g" $path 2>>$DATA/syseditor.txt 	#Заменяем ip адреса
						logger 7 $pattern1 $pattern2 $path
						counter=$[counter + 1]

					}

				done

			done

		}

		rm $DATA/syseditor_ip_tmp.txt				#Удаляем временные файлы
		rm $DATA/syseditor_path_tmp.txt

			if [ "$counter" != 0 ] 
			then

				echo "Изменено $counter адресов. Подробнее в логе $DATA/syseditor.txt"
				echo " "

			else

				echo "Адресов не найдено. Замены не произведены" 1>&2
				echo " "
				logger 1 $old_ip
				exit 1

			fi

	else

		validator "Ошибка в количестве аргументов"

	fi

fi