#!/bin/bash

#Инициализация портов menlinux compci
for i in {0..7}; do mknod /dev/ttyD$i c 19 $i; done #8 портов
modprobe men_bb_d203_a24
modprobe men_mdis_kernel
mdis_createdev -b d203_a24_1								
modprobe men_lx_m77 devName=m77_1 brdName=d203_a24_1 slotNo=0 mode=2,4,2,2 echo=0,0,0,0
						#mode 2 - RS422, 4 - RS485, 7 - RS232
						#Задаем для первых 4х портов