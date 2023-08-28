#include "parsetext.h"

ParseText::ParseText(QString txt) {

    str = txt;

}

double ParseText::parse() { //Считает выражение в целом

    double value = 0;
    quint32 index = 0;
    value = term(str, index); //Запускаем проверку строки "рекурсивно"

        while(1) {

            if (str.at(index) == "=") return value;
            else if(str.at(index) == "+") {value += term(str, ++index);} //Рекурсивно проверяем
            else if(str.at(index) == "-") {value -= term(str, ++index);} //следующие числа на наличие * или /
            else return 0;

    }

}

double ParseText::term (QString str, quint32 &index) {

    double value = 0;
    value = number(str, index);

        while(1) {       //Если после числа идут * или /, то вычисляем

            if(str.at(index) == "*") {value *= number(str, ++index);} //Если есть знак, то вычисляем преобразованный
            else if(str.at(index) == "/") {value /= number(str, ++index);} //в число кусок
            else break;

        }

return value;
}

double ParseText::number(QString str, quint32 &index) { //Преобразует строку в числа

    double value =0;

        if (!(str.at(index).isDigit())) return 0;

            while(str.at(index).isDigit()) {

                value = 10 * value + (str.at(index++).unicode() - '0'); //Преобразуем элемент строки в число

            }

        if(str.at(index)!='.') return value;    //Если число не дробь, то возвращаем число

    double factor = 1.0;

        while(str.at(++index).isDigit()) {       //Если дробь, то преобразуем и дробную часть

            factor *=0.1;
            value = value + (str.at(index).unicode() - '0') * factor;

        }

return value;
}

