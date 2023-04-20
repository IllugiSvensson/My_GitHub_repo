#include <stdio.h>

//Не менять!
#define mEP1 690     //Минимальный ежемесячный платеж
#define mEP2 8170
#define mEP3 1020
#define PERC1 1.199  //Проценты
#define PERC2 1.1645
#define PERC3 1.1645


//Менять можно только тут
float current1 = 23645.36;  //Оставшиеся суммы платежей
float current2 = 220655.48;
float current3 = 19777.73;
int sum_plata = 35000;  //Платеж в месяц допустимый



float CheckPl(float, float, float);
float CheckSum(float, float, float, int, int);



int main()
{
    CheckSum(mEP1, mEP2, mEP3, mEP1 + mEP2 + mEP3, 1);
    puts(" ");
    float min, check = current1 + current2 + current3;  //Минимальный платеж не превышает общую сумму
    int plat[3];
    for (int i = mEP1; i < (sum_plata - mEP2 - mEP3); i += 10)     //Перебираем все комбинации платежей
        for (int j = mEP2; j < (sum_plata - mEP1 - mEP3); j += 10)
            for (int k = mEP3; k < (sum_plata - mEP1 - mEP2); k += 10)
            {
                if ((i + j + k) >= sum_plata) continue;     //Отсеиваем некорректные комбинации
                min = CheckSum(i, j, k, sum_plata, 0);      //Оцениваем текущую комбинацию
                if (min <= check)                           //Ищем наименьшую переплату
                {
                    check = min;
                    plat[0] = i; plat[1] = j; plat[2] = k;
                }
            }
    puts("Overprice:   First:  Second:  Third: ");
    printf("%5.2f     %d     %d     %d\n", check, plat[0], plat[1], plat[2]);
    puts(" ");
    CheckSum(plat[0], plat[1], plat[2], sum_plata, 1);

return 0;
}





float CheckSum(float pl1, float pl2, float pl3, int spl, int flag)
{
    int month = 0;           //Счетчик месяцев
    float rem1 = current1;   //Текущий остаток
    float rem2 = current2;
    float rem3 = current3;
    float overprice = 0; //Счетчик переплат
    float pl_1 = pl1, pl_2 = pl2, pl_3 = pl3; //Фикс. платеж
    if (flag == 1)
    {
        puts("Paying graphic: ");
        printf("%d    %5.2f     %5.2f     %5.2f\n", month, rem1, rem2, rem3);
    }
    while ((rem1 + rem2 + rem3) >= 0)
    {
        month++;
        if (rem1 <= 0 && rem2 <= 0) pl_3 = spl;     //Переправление платежей в случае
        else if (rem1 <= 0 && rem3 <= 0) pl_2 = spl;//закрытия одного/двух кредитов
        else if (rem2 <= 0 && rem3 <= 0) pl_1 = spl;
        else if (rem1 <= 0)
        {
           pl_2 = pl2 + pl_1/2;
           pl_3 = pl3 + pl_1/2;
        }
        else if (rem2 <= 0)
        {
            pl_1 = pl1 + pl_2/2;
            pl_3 = pl3 + pl_3/2;
        }
        else if (rem3 <= 0)
        {
            pl_1 = pl1 + pl_3/2;
            pl_2 = pl2 + pl_3/2;
        }
        overprice += (((rem1 * PERC1) - rem1) + ((rem2 * PERC2) - rem2) + ((rem3 * PERC3) - rem3))/12;
        rem1 = CheckPl(rem1, pl_1, PERC1);
        rem2 = CheckPl(rem2, pl_2, PERC2);
        rem3 = CheckPl(rem3, pl_3, PERC3);
        if (flag == 1) printf("%d    %5.2f     %5.2f     %5.2f\n", month, rem1, rem2, rem3);
    }
    if (flag == 1) printf("Overprice: %5.2f\n", overprice);

return overprice;
}

float CheckPl(float current, float epl, float percent)
{
    if (current <= 0) return 0;
    return current + (current * percent - current)/12 - epl;
}
