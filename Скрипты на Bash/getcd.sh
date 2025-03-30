#!/bin/bash

function calc {
    let Calc=$1-$2
    Calc=$(( $Calc % 11 ))
    echo $Calc
}

DumpList=( $(coredumpctl -r | grep present | head -n 7) )
k=0
j=1

for i in ${DumpList[@]}
do
    if [[ `calc $k 1` == "0" || `calc $k 2` == "0" || `calc $k 4` == "0" || `calc $k 9` == "0" ]]
    then
	Item="$Item $i"
	if [ $j == 4 ]
	then
	    j=0
	    ListItem+=("$Item")
	    Item=""
	fi
	let "j=$j+1"
    fi
    let "k=$k+1"
done

answer=( $(zenity --list --text="<span font=\"20\">Выберите дамп для чтения</span>" --width=640 --height=480 --title="GetCoreDump" --column="Список дампов" "${ListItem[@]}") )

[ -z $answer ] && exit 0
Proc=${answer[3]}
PID=${answer[2]}
coredumpctl -o /data/tmp/${PID}.dump dump $PID $Proc && gdb $Proc /data/tmp/$PID.dump -ex bt -ex quit > /data/tmp/${PID}_bt.log
coredumpctl -o /data/tmp/${PID}.dump dump $PID $Proc && gdb $Proc --batch /data/tmp/$PID.dump -ex 'thread apply all bt' -ex quit > /data/tmp/${PID}_allbt.log

zenity --text-info --title="GetCoreDump" --width=1800 --height=1000 --font="20" --filename=/data/tmp/${PID}_bt.log
zenity --text-info --title="GetCoreDump" --width=1800 --height=1000 --font="20" --filename=/data/tmp/${PID}_allbt.log

rm -f ${PID}.dump ${PID}_bt.log ${PID}_allbt.log