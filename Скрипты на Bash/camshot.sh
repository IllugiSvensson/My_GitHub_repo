#!/bin/bash

export DISPLAY=:0
path=/mnt/archive/CCTVfrags
out=/mnt/archive/Camshot
per=5000
algo=mog
res=mask

echo "********* $1 started! *********"
channels="H-ERS1-TV-1 H-ERS1-IR-1"
launch camshot --path $path/$1 --out $out/$1 --use_md --md_period $per --md_algoritms $algo --md_result $res --use_md_filters --channels=$channels --time 30
    echo "********* $channels end! *********"
    echo " "
channels="H-ERS1-TV-2 H-ERS1-TV-3 H-ERS1-TV-9 H-ERS1-IR-2 H-ERS1-IR-7"
launch camshot --path $path/$1 --out $out/$1 --use_md --md_period $per --md_algoritms $algo --md_result $res --use_md_filters --channels=$channels --time 15
    echo "********* $channels end! *********"
    echo " "
channels="H-ERS1-TV-6 H-ERS1-TV-7 H-ERS1-IR-4 H-ERS1-IR-5 H-ERS1-IR-6"
launch camshot --path $path/$1 --out $out/$1 --use_md --md_period $per --md_algoritms $algo --md_result $res --use_md_filters --channels=$channels --time 5
    echo "********* $channels end! *********"
    echo " "
channels="H-ERS1-TV-4 H-ERS1-TV-5 H-ERS1-TV-8 H-ERS1-TV-10 H-ERS1-IR-3 H-ERS1-IR-8"
launch camshot --path $path/$1 --out $out/$1 --use_md --md_period $per --md_algoritms $algo --md_result $res --use_md_filters --channels=$channels --time 10
    echo "********* $channels end! *********"
    echo " "

echo " "
echo " "
echo " "