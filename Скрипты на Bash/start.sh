#!/bin/bash

answer=`zenity --entry --title="RecognitionTrainer" --text="Введите дату в формате 23.01.13/IR" --width=200 --height=100`

Type=${answer:9}
Date=${answer::8}

if [ ${Type} == "IR" ]
then
    area=40

elif [ ${Type} == "TV" ]
then
    area=100

else
    zenity --error --title="RecognitionTrainer" --text="Ошибка в типе спектра" --width=200 --height=100
    exit

fi

#/home/user/Recognition/RecognitionObjectTrainer --min_area=$area --data_dir /home/user/Shared/$Date --res_csv_file /home/user/Shared/${Type}_${Date}.csv
/home/user/Recognition/RecognitionObjectTrainer --min_area=$area --data_dir /home/user/SH/Camshot/$Date --res_csv_file /home/user/SH/CSV/${Type}/${Type}_${Date}.csv

if [ `echo $?` != 0 ]
then
    zenity --error --title="RecognitionTrainer" --text="Фото не найдены или\nнеудачный запуск" --width=200 --height=100

fi
