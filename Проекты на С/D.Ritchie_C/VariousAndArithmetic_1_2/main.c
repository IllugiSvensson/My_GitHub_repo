#include <stdio.h>

/*Print Fahrenheit - Celsius table*/
//this is comment
int main()
{
    //Объявление переменных (тип_имя)
    float fahr, celsius;
    int lower, upper, step;

    //Инициализация/присваивание значений
    lower = 0; //lower border of temp
    upper = 300; // uper border
    step = 20; /*step*/
    fahr = lower; //тут происходит неявное привидение целого к дроби

    //Цикл с предусловием (сначала условие, потом выполнение)
    while (fahr <= upper)
    {
        // 5/9 даст 0, так как воспринимаются как целые. для дроби нужно написать 5.0/9 или 5/9.0
        celsius = 5 * (fahr - 32) / 9;
        //форматированный вывод - значения с % соответствуют порядку аргументов после ""
        //%_ширинаполя_тип
        printf("%3.0f\t%6.1f\n", fahr, celsius);
        fahr = fahr + step;
    }

    //Упражнение
    celsius = lower;
    fahr = 0;
    printf("Celsius\tFahrenheit\n");
    while (celsius <= upper)
    {
        fahr = (celsius * 9.0 / 5.0) + 32;
        printf("%7.0f\t%9.1f\n", celsius, fahr);
        celsius = celsius + step;
    }
    return 0;
}

//Другие типы:                          Спецификаторы:
/*int - Целое                           %o - Восьмиричное
float - дробное                         %x - Шестнадцатиричное
char - символ                           %c - Символ
short - короткое целое                  %s - Строка символов
long - длинное целое                    %% - знак %
double - дробь двойной точности*/
