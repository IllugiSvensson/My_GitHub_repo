#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define SIZE 1000
int array[SIZE] = {0};

void swap(int *a, int *b) {

    int t = *a;

        *a = *b;
        *b = t;

}

int arrsearch(int *c) {

    int s, m;
    int L = 0;
    int R = SIZE - 1;

        printf("Введите число для поиска: ");
        scanf("%d", &s);

            while(L <= R) {

                m = L + (R - L) / 2;

                if (c[m] < s) {

                    L = m + 1;

                } else if(c[m] > s){

                    R = m - 1;

                } else

                    return m;

            }

return -1;
}

int main() {

    srand(time(NULL));
    int i, j, t;
    int cnt = 0;
    int arr[SIZE];

    printf("Массив до сортировки: \n");

        for(i = 0; i < SIZE; i++) {

            array[i] = rand() % 100;    //Заполняем массив случайными числами
            arr[i] = array[i];          //копируем в локальный массив
            printf("%d ", array[i]);

        }

    printf("\n\n");

//1.Попробовать оптимизировать пузырьковую сортировку. Сравнить количество операций сравнения
//оптимизированной и неоптимизированной программы.

        for(i = 0; i < SIZE; i++) {

            cnt++;
            for(j = 0; j < SIZE - 1; j++) {

                cnt++;
                if(arr[j] > arr[j + 1]) {

                    cnt++;  //Считаем количество свапов
                    swap(&arr[j], &arr[j + 1]);

                }

            }

        }

        printf("Отсортированный массив: \n");

            for(i = 0; i < SIZE; i++) {

                printf("%d ", arr[i]);
                arr[i] = array[i];  //Очищаем массив после сортировки

            }

        printf("\nПроизводительность пузырька: %d команд\n\n", cnt); cnt = 0;

        i = 0;
        t = 1;

            while (t) {

                t = 0;
                cnt++;
                for(j = 0; j < SIZE - 1 - i; j++) { //Отсекаем отсортированные элементы

                    cnt++;
                    if(arr[j] > arr[j + 1]) {

                        swap(&arr[j], &arr[j + 1]);
                        t = 1;
                        cnt++;

                    }

                }

                i++;

            }

        printf("Отсортированный массив: \n");

            for(i = 0; i < SIZE; i++) {

                printf("%d ", arr[i]);
                arr[i] = array[i];  //Очищаем массив после сортировки

            }

        printf("\nПроизводительность пузырька(опт): %d команд\n\n", cnt); cnt = 0;

//2.Сортировка шейкером
    int L = 1;
    int R = SIZE - 1;

        while(L <= R) {

            cnt++;
            for(i = R; i >= L; i--) {

                cnt++;
                if(arr[i - 1] > arr[i]) {

                    swap(&arr[i - 1], &arr[i]);
                    cnt++;

                }

            }

            L++;
            cnt++;
            for(i = L; i <= R; i++) {

                cnt++;
                if(arr[i - 1] > arr[i]) {

                    swap(&arr[i - 1], &arr[i]);
                    cnt++;

                }

            }

            R--;

        }

        printf("Отсортированный массив: \n");

            for(i = 0; i < SIZE; i++) {

                printf("%d ", arr[i]);

            }

        printf("\nПроизводительность шейкера: %d команд\n\n", cnt); cnt = 0;

//3.Реализовать бинарный алгоритм поиска в виде функции, которой передаётся отсортированный массив.
//Функция возвращает индекс найденного элемента или –1, если элемент не найден.

    t = arrsearch(arr);

        if(t == -1)

            printf("Значение не найдено\n");

        else

            printf("Индекс: %d\n\n", t);

return 0;
}

