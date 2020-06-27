#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

void swap(int *, int *);
int HeapSort(int *, int );
int cnt = 0;
int b[100];

//Быстрая сортировка Хоара.
void quickSort(int *array, int first, int last) {

    int i = first, j = last, x = array[(first + last) / 2];

        do {    //Разбиваем массив на две части и раскладываем
                //на меньше опорного и больше опорного
            while (array[i] < x) {

                cnt++;
                i++;

            }

            while (array[j] > x) {

                cnt++;
                j--;

            }

            if(i <= j) {

                if (array[i] > array[j]) {    //Меняем местами

                    swap(&array[i], &array[j]);
                    cnt++;

                }

                cnt++;
                i++;
                j--;

            }

        } while (i <= j);

        if (i < last)       //Рекурсивно повторяем для каждой части
            quickSort(array, i, last);

        if (first < j)
            quickSort(array, first, j);

}

//Пирамидальная сортировка
int HeapSort(int *a, int n) {

    int i, mid, t = n - 1, k;
    mid = n / 2;                                //Середина массива

        for (i = mid; i >= 1; i--) {

            if (a[i - 1] < a[2 * i - 1]) {
                                                      //Условие сравнения, которое
                swap(&a[i - 1], &a[2 * i - 1]);       //соответствует пирамидальной
                cnt++;                                //сортировке

            }

            if (2 * i < n && a[i - 1] < a[2 * i]) {     //Если n нечётное

                swap(&a[i - 1], &a[2 * i]);
                cnt++;

            }

        }

    k = 2 * mid;
    swap(&a[0], &a[t]); cnt++;
    t--;

        while (t > 0) {

            mid = t / 2;                                //Теперь на последнем месте стоит
                                                        //максимальный элемент,
                for (i = mid; i >= 1; i--) {            //его больше не трогаем
                                                        //и проходимся по коротким ветвям
                    if (a[i - 1] < a[2 * i - 1]) {

                        swap(&a[i - 1], &a[2 * i - 1]);
                        cnt++;

                    }

                    if (2 * i < n && a[i - 1] < a[2 * i]) {

                        swap(&a[i - 1], &a[2 * i]);
                        cnt++;

                    }

                }

            k += 2 * mid;
            swap(&a[0], &a[t]);
            cnt++;
            t--;

        }

    if (n > 0 && a[0] > a[1]) {                 //Последнее сравнение –
                                                //нулевого элемента с первым
        swap(&a[0], &a[1]);
        cnt++;

    }

    k++;

return k;
}

//Сортировка подсчетом
void simpleCountingSort(int *A, int k) {

    int i, j,c=0;
    int C[100];

        for (i = 0; i < k; i++) //Обнуляем массив частот вхождений
            C[i] = 0;

        for (i = 0; i < 100; i++) {

            C[A[i]]++;
            cnt++;

        }

        for (i = 0; i < k; i++)
            for (j = 0; j < C[i]; j++) {

                b[c++] = i;
                cnt++;

            }

}

int main() {

    srand(time(NULL));
    int a[100];
    int i;

        printf("Неотсортированный массив: \n");
        for (i = 0; i < 100; i++) {

            a[i] = rand() % 100; //Заполняем резервный массив
            printf("%d ", a[i]);
            b[i] = a[i];        //Заполняем рабочий массив

        }
        puts(" ");

    quickSort(b, 0, 99);

        printf("Быстрая сортировка Хоара: \n");
        for(i = 0; i < 100; i++) {

            printf("%d ", b[i]);
            b[i] = a[i];

        }
        printf(" Действий: %d", cnt);
        puts(" "); cnt = 0;

    HeapSort(b, 100);

        printf("Пирамидальная сортировка: \n");
        for(i = 0; i < 100; i++) {

            printf("%d ", b[i]);
            b[i] = a[i];

        }
        printf(" Действий: %d", cnt);
        puts(" "); cnt = 0;

    simpleCountingSort(b, 100);

        printf("Сортировка подсчётом: \n");
        for(i = 0; i < 100; i++) {

            printf("%d ", b[i]);
            b[i] = a[i];

        }
        printf(" Действий: %d", cnt);
        puts(" "); cnt = 0;

return 0;
}

void swap(int *p, int *q) {

    int buf;
    buf = *p;
    *p = *q;
    *q = buf;

}

