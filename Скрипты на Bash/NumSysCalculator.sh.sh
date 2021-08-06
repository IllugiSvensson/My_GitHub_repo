#!/bin/bash

function NumSysParser {		#Функция перевода системы счисления в числа для сравнения

    case $1 in
	[bB]) echo 2;;
	[oO]) echo 8;;
	[dD]) echo 10;;
	[hH]) echo 16;;
    esac

}

function HexParser {		#Преобразование шестнадцатиричных цифр в буквы и обратно

    case $1 in
	[aA]) echo 10;;
	[bB]) echo 11;;
	[cC]) echo 12;;
	[dD]) echo 13;;
	[eE]) echo 14;;
	[fF]) echo 15;;
	"10") echo A;;
	"11") echo B;;
	"12") echo C;;
	"13") echo D;;
	"14") echo E;;
	"15") echo F;;
	*)    echo $1;;
    esac

}

function Transformator {	#Функция перевода из одной системы в другую

    cnt=`echo -n $2 | wc -c`	#Считаем количество разрядов. На 1 меньше, потому что отсчет с нуля
    cnt=$(($cnt - 1))
    res=0
    str=""
    
	if [ -n "$3" ]		#Для перевода из 10 в любую другую нужно делить
	then

	    dev=$2
	    r=`NumSysParser $3`
	    while [ $dev -ge $r ]	#Делим по модулю и обычно, пока делимое больше делителя
	    do

		d=$(($dev % $r))
		d=`HexParser $d`
		dev=$(($dev / $r))
		str=$str$d		#записываем остатки от деления в строку подряд

	    done
	    echo $str$dev | rev		#Выводим строку в обратном порядке

	elif [ $1 -ne "10" ]		#Для перевода любой системы в десятичную нужно умножать
	then

	    for i in `echo $2 | fold -w1 | paste -sd ' '`	#Дробим строку на отдельные разряды пробелами
	    do

		d=`HexParser $i`
		res=$(($res + $(($d * $(($1 ** $cnt))))))	#Полином. Поразрядно возводим в степень разряда основание
		cnt=$(($cnt - 1))				#и умножаем на значение разряда

	    done						#Циклично проходимся по разрядам, уменшая степень до 0
	    echo $res

	else

	    echo $2		#Когда перевод не нужен

	fi

}

function Calculator {		#Функция калькулятора

    operand1=`echo ${1%?}`			#Передаем при вызове строку, получаем набор отдельных аргументов

    numsys1=`echo $1 | egrep -o "[bodhBODH]\b"`	#Парсим цифры и буквы основания на разные переменные
    numsys1=`NumSysParser $numsys1`

    operand2=`echo ${3%?}`

    numsys2=`echo $3 | egrep -o "[bodhBODH]\b"`
    numsys2=`NumSysParser $numsys2`

    resultnumsys=`NumSysParser $4`

    operand1=`Transformator $numsys1 $operand1`	#Приводим числа к 10 системе
    operand2=`Transformator $numsys2 $operand2`
    result=$((operand1 $2 operand2))		#Выполняем арифметику
    result=`Transformator "x" $result $4`	#Переводим результат к требуемой системе
    zenity --info --title="Результат" --text="Выражение: $1 $2 $3\nРезультат: $result$4"

}

while :
do

    value=`zenity --entry --title="Калькулятор систем счисления" --text="Введите выражение:"`
    #Баг с zenity. При вводе *, * интерпретируется не как символ, а как ls *. На выходе мусор.
    if [ $? != 0 ]	#Условие выхода из цикла
    then

	exit

    fi
    bin="[0-1]{1,}[bB]{1}"	#Проверка ввода под каждую систему счисления
    oct="[0-7]{1,}[oO]{1}"
    dec="[0-9]{1,}[dD]{1}"
    hex="[0-9a-fA-F]{1,}[hH]{1}"
    valid=`echo $value | egrep -o "($bin|$oct|$dec|$hex)\s{1}(-|\*|\/|\+){1}\s{1}($bin|$oct|$dec|$hex)\s{1}[bodhBODH]{1}"`
    if [ -z "$valid" ]		#Повторяем ввод в случае ошибки
    then

	zenity --error --title="Ошибка" --text="Ошибка входных данных"
	continue

    fi
    Calculator $valid	#Запускаем расчет

done