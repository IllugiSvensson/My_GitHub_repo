#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define ARR_SIZE 100

int bin[ARR_SIZE];
int arr[ARR_SIZE];
int size = 0;
int ct = 1;

//1. Реализовать функцию перевода из 10 системы в двоичную используя рекурсию.
void decTobin(long dec) {

    if(dec < 0)

        printf("Получить не удалось");

    if(dec > 0) {

        bin[size++] = dec % 2;  //Заполняем массив двоичными значениями
        dec = dec / 2;
        decTobin(dec);      //Рекурсивно вызываем функцию

    }

}

//2. Реализовать функцию возведения числа x в степень y
//a. без рекурсии
int power_a(int x, int y) {

    int pow = 1;

        if (x == 0) {

            pow = 0;

        } else if (y == 0) {

            pow = 1;

        } else {

            while(y) {

                pow = pow * x;
                y--;

            }

        }

return pow;
}

//b. рекурсивно
int power_b(int x, int y) {

    int pow = x;

        if(x == 0) return pow;

        if(y == 0) pow = 1;

        if(y > 1)  pow = x * power_b(pow, y - 1);

return pow;
}

//с. рекурсивно используя свойство четности

int power_c(int x, int y) {

    int pow = 1;

        if (x == 0) return x;

        if (y == 1) return x;

        if (y > 0) {

            if (y % 2) {

               pow = x * power_c(x, y - 1); //при нечетной степени

            } else {

                pow = power_c(x * x, y / 2); //При четной степени

            }

        }

return pow;
}

//3. Определить, сколько существует программ, которые преобразуют
//число 3 в число 20, используя команды (прибавь 1, умножь на 2).
//(Программа - набор команд).
//a. Используя массив
int counter_a(int a, int b) {

    int i;
    int cnt;

        arr[a] = 1;         //Начальное значение достигается одной командой
        arr[a + 1] = 1;     //В следующее значение можно попасть так же одной командой

            for(i = a + 2; i <= b; i++) {   //Начиная с третьего значения и далее

                arr[i] = arr[i / 2] + (arr[i - 2]);
                cnt = arr[i];

            }

return cnt;
}

//б. Используя рекурсию
int counter_b(int a, int b) {

    if ((a + 2) >= b) {

        ct = 1;

    } else {

        ct = counter_b(a, b / 2) + counter_b(a , b - 2);

    }

return ct;
}

int main() {

    int d, i;

        printf("Введите число для перевода: ");
        scanf("%d", &d);
        printf("Двоичное представление: ");

            if(d == 0) {

                printf("0");

            } else {

                decTobin(d);

                for(i = size - 1; i >= 0; i--)
                    printf("%d", bin[i]);   //Печатаем двоичное число с конца

            }

        puts(" ");

        printf("\nВведите число: ");
        scanf("%d", &d);
        printf("Введите показатель степени: ");
        scanf("%d", &i);

            if(i >= 0) {

                printf("Степень числа a: %d, b: %d, c: %d\n", power_a(d, i),
                                                              power_b(d, i),
                                                              power_c(d, i)
                                                              );

            } else {

                printf("Степень числа a: %5.3f, b: %5.3f, c: %5.3f\n", ((float)1 / power_a(d, abs(i))),
                                                                       ((float)1 / power_b(d, abs(i))),
                                                                       ((float)1 / power_c(d, abs(i)))
                                                                       );

            }

        puts(" ");

        printf("Число программ: %d\n", counter_a(3, 20));
        printf("Число программ: %d\n", counter_b(3, 20));

        puts(" ");

return 0;
}

