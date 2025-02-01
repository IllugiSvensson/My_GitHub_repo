#include <stdio.h>

void func1();
void func2();

int main()
{
    int c, i , nwhite, nother;
    //Объявление массива из 10 элементов. Инициализация начинается с 0 по 9
    int ndigit[10];

    nwhite = nother = 0;
    for (i = 0; i < 10; ++i)
        ndigit[i] = 0;

    while ((c = getchar()) != EOF)
        //Проверка, является ли символ цифрой
        if (c >= '0' && c <= '9')
            //с - 0 есть числовое представление символа цифры
            ++ndigit[c - '0'];
    //else if может быть сколько угодно, а if - else может быть вложенным
    else if (c == ' ' || c == '\n' || c == '\t')
            ++nwhite;
    else
            ++nother;

    printf("digits = ");
    for (i = 0; i < 10; ++i)
        printf(" %d", ndigit[i]);
    printf(", symb-del = %d, other = %d\n", nwhite, nother);

    //Упражнения
    func1();
    func2();
    return 0;
}

void func1()
{
    int hysto[10];
    int c, cnt = 0;
    for (int i = 0; i < 10; i++)
        hysto[i] = 0;
    while ((c = getchar()) != EOF) {
        if (c != ' ' || c != '\n' || c != '\t')
            cnt++;
        else
            hysto[cnt - 1]++;
    }
    for (int i = 0; i < 10; i++)
    {
        for (int j = 0; j < hysto[i]; j++)
            printf("%c", '|');
        printf("\n");
    }
}

void func2()
{
    int hysto[32];
    int c, cnt = 0;
    for (int i = 0; i < 32; i++)
        hysto[i] = 0;
    while ((c = getchar()) != EOF) {
        if (c == 'a') hysto[0]++;
        else if (c == 'b') hysto[1]++;
        else hysto[2]++;
        //etc
    }
    for (int i = 0; i < 32; i++)
    {
        for (int j = 0; j < hysto[i]; j++)
            printf("%c", '|');
        printf("\n");
    }
}
