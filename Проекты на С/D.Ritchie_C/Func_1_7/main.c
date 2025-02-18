#include <stdio.h>

//Прототип функции
int power(int m, int n);

int main()
{

    for (int i = 0; i < 10; ++i) //Вызов функции два раза по значениям
        printf("%d %d %d\n", i, power( 2, i), power(-3, i));
    return 0;
}

//Описание функции
//Возращаемый тип, имя, список параметров и их типы
int power(int base, int n)
{
//Все что внутри функции уничтожается при выходе из неё
    int p = 1;
    for (int i = 1; i <= n; ++i)
        p = p * base;
    //Возвращаемое значение
    return p;
}
