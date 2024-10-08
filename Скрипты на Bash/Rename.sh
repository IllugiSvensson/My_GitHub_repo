﻿#!/bin/bash
#Скрипт для переименовывания файлов изображений по шаблону
#Удобно переименовывать кучу случайно-названных файлов под единый шаблон с порядковым номером

if [ $# -lt 2 ]					#Если меньше двух аргументов, то запускаем правила
then								
	echo Usage:								
	echo $0 newprefix file1 file2 …		#Формат использования скрипта					 
	exit 1
fi       
							
prefix=$1        				#Сохраняем префикс и сдвигаем аргументы
shift        							
count=0     					#Отмечаем порядковый номер

for file in $*     							
do   
	count=$[count + 1]				#Приращение порядкового номера
	mv -n "${file}" "${prefix}${count}.jpg"		#Циклом переименовываем файлы
done
exit 0


