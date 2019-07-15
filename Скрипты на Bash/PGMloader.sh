#!/bin/bash
#Сделаем скрипт для загрузки нескольких изображений
#в программу categorizer Проекта на С++
#������ ������ � ������� � �������� ������ � �������������

echo "Желаете нормировать все гистограммы? [y/n]: "
read -n 1 a
echo " "

	for img in *.PGM *.pgm
	do

		if [[ "$a" = "y" ]]
		then
			yes | ./categorizer $img | grep -v "ать гист"
			echo " "
		else 
			ls | ./categorizer $img | grep -v "ать гист"
			echo " "
		fi	

	done