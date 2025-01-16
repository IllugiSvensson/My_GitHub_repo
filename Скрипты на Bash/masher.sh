#!/bin/bash

for n in /mnt/archive/Camshot/$1
do
    cd $n/Frames
    for i in `ls | grep "video"`
    do
	cp -r $i/* ${i::-6}
	rm -rf $i
    done

    cd $n/Masks
    for i in `ls | grep "video"`
    do
	cp -r $i/* ${i::-6}
	rm -rf $i
    done

    rm -rf $n/Rects

done

touch /mnt/archive/Camshot/$1