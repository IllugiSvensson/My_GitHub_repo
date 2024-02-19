#!/bin/sh
#Скрипт предназначен для инициализации драйверов и портов MOXA модели cp 114/118
#Его выполнение нужно добавить в автозагрузку или планировщик задач

mount -n -w -o remount /

cd /data/moxa/mxser/		#Устанавливаем ПО, если его нет
    ./mxinstall

cd /data/moxa/mxser/driver/	#Устанавливаем драйвер по умолчанию
    yes '' | ./msmknod
    
cd /data/moxa/mxser/utility/conf/

    for port in {0,4}		#Задаем параметры портов
	do
	    ./muestty -i RS4854W /dev/ttyMUE$port
	    ./muestty -t NONTERM /dev/ttyMUE$port
	done

    for port in {1,2,5,6}
	do
	    ./muestty -i RS422 /dev/ttyMUE$port
	    ./muestty -t NONTERM /dev/ttyMUE$port
	done
