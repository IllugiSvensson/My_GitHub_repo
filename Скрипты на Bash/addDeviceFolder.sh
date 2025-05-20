#!/bin/bash

for i in /data/grn/imitator/CCTV+DDS/$1
do

    path=$i/CCTV/RecorderCCTV.V1
    for j in $path/*
    do

	cd $j
	files=`ls`
	folder=`basename $j`
	mkdir $j/$folder
	mv $files $j/$folder
	cd $path

    done

done