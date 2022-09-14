#!/bin/bash

#Первый аргумент - точка монтирования
#Второй аргумент - юзернейм
#Третий аргумент - пароль
if [ $# -ne 3 ]
then

    echo "args: mount_point username nita_password"

else

    echo "//main/GetStand $1 cifs username=$2,uid=1000,password=$3,domain=NITA 0 0" >> /etc/fstab
    mount -t cifs //main/GetStand $1 -o username=$2,password=$3,uid=1000,domain=NITA
    echo "Success"

fi
