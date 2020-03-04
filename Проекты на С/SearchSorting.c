#include <stdio.h>
#include <malloc.h>
#include <time.h>
#include <stdlib.h>
#define MaxN 1000

int InterpolationSearch(int *a, int length, int value, int *c) {

    int min = 0;
    int max = length - 1;
    int mid;

        while (min <= max) { //Находим разделяющий элемент

            *c = *c + 1;
            if ((a[max]) - a[min] == 0) mid = min + (max - min) * (value - a[min]);
            else mid = min + (max - min) * (value - a[min]) / (a[max] - a[min]);

            if (a[mid] == value) return mid;
            else if (a[mid] < value) min = mid + 1;
            else if (a[mid] > value) max = mid - 1;

        }

return -1; //Элемент не найден
}

void swap(int *a, int *b) {

    int t = *a;
    *a = *b;
    *b = t;

}

void print(int N, int *a) {

    int i;
    for(i = 0; i < N; i++)
        printf("%3i", a[i]);
        printf("\n");

}

int main() {

    int A[MaxN];            //Основной массив со случайными числами
    int i, value, count = 0;
    for (i = 0; i < MaxN; i++) {

        A[i] = rand() % 100; //Заполняем массив случайными числами

    }
    print(MaxN, A);

    //Линейный поиск в массиве.
    printf("\nВведите число для поиска: ");
    scanf("%d", &value);

        i = 0;
        while (i < MaxN && A[i] != value) { // Алгоритм поиска

                i++;
                count++;    //Счетчик производительности

        }

        if (i != MaxN) {

            printf("\nИндекс: %d\n", i);

        } else {

            printf("\nЗначение не найдено\n");

        }

        printf("Производительность линейного поиска: %4d / %d\n", count, MaxN); count = 0;

    //Поиск с барьером
    int C[MaxN + 1];

        for (i = 0; i < MaxN; i++) {

            C[i] = A[i];    //Копируем массив

        }

        C[i] = value;   //Установим барьер
        i = 0;

            while(C[i] != value) {

                i++;
                count++;

            }
                         //Ищем значение, пока не найдем
        if (i != MaxN) { //или не уткнемся в барьер

            printf("\nИндекс: %d\n", i);

        } else {

            printf("\nЗначение не найдено\n");

        }

        printf("Производительность поиска с барьером: %4d / %d\n", count, MaxN); count = 0;

    //Интерполяционный поиск
    int B[MaxN], m;
    int c = 0;

        for (i = 0; i < MaxN; i++) {

            B[i] = i;   //Для упорядоченного массива
            //B[i] = A[i];

        }

        m = InterpolationSearch(B, MaxN, value, &c); //Попробуем найти число

            if (m == -1) printf("\nЗначение не найдено\n");
            else printf("\nИндекс: %d\n", m);

        printf("Производительность интерполяционного поиска: %4d / %d\n", c, MaxN);
        printf("Производительность ухудшается, когда массив случайный\n");
        printf("Причем все сильно зависит от распределения значений\n");

    //Бинарный поиск
    int L = 0;
    int R = MaxN - 1;
    m = L + (R - L) / 2;

        while(L <= R && B[m] != value) {

            if (B[m] < value) {     //Смещаем центральное и боковые значения

                L = m + 1;
                m = L + (R - L) / 2;

            } else {

                R = m - 1;
                m = L + (R - L) / 2;

            }

            count++;

        }

        if (B[m] == value) {

            printf("\nИндекс: %d\n", m);

        } else {

            printf("\nЗначение не найдено\n");

        }

        printf("Производительность бинарного поиска: %4d / %d\n", count, MaxN); count = 0;

    //Пузырьковая сортировка
    int j = 0;
    for (i = 0; i < MaxN; i++) {

        B[i] = A[i];    //Копируем массив

    }

        for(i = 0; i < MaxN; i++) {

            for(j = 0; j < MaxN - 1; j++) {

                if (B[j] > B[j + 1]) {

                    count++;
                    swap(&B[j], &B[j + 1]);

                }

            }

        }

    printf("\nМассив после сортировки: \n");
    print(MaxN, B);
    printf("Производительность пузырька: %4d / %d\n\n", count, MaxN); count = 0;

    //Шейкерная сортировка
    for (i = 0; i < MaxN; i++) {

        B[i] = A[i];    //Копируем массив

    }
    L = 1;
    R = MaxN - 1;

        while(L <= R) {

            for(i = R; i >= L; i--) {

                if(B[i - 1] > B[i]) {

                        count++;
                        swap(&B[i - 1], &B[i]);

                }

            }

            L++;

            for(i = L; i <= R; i++) {

                if(B[i - 1] > B[i]) {

                    count++;
                    swap(&B[i - 1], &B[i]);

                }

            }

            R--;

        }

    printf("Массив после сортировки: \n");
    print(MaxN, B);
    printf("Производительность шейкера: %4d / %d\n\n", count, MaxN); count = 0;

    //Сортировка методом выбора
    for (i = 0; i < MaxN; i++) {

        B[i] = A[i];    //Копируем массив

    }
    j = 0;
    int jmin;

        for(i = 0; i < MaxN; i++) {

            jmin = i;

            for(j = i + 1; j < MaxN; j++) {

                if (B[j] < B[jmin]) {

                    jmin = j;
                    count++;
                }

            }

            swap(&B[i], &B[jmin]);
            count++;

        }

    printf("Массив после сортировки: \n");
    print(MaxN, B);
    printf("Производительность выборов: %4d / %d\n\n", count, MaxN); count = 0;

    //Сортировка вставками
    for (i = 0; i < MaxN; i++) {

        B[i] = A[i];    //Копируем массив

    }

        for (i = 0; i < MaxN; i++) {

            int temp = B[i];
            j = i;
            count++;

            while (j > 0 && B[j - 1] > temp) {

                swap(&B[j], &B[j - 1]);
                j--;
                count++;

            }

        }

    printf("Массив после сортировки: \n");
    print(MaxN, B);
    printf("Производительность вставок: %4d / %d\n\n", count, MaxN); count = 0;

return 0;
}

//*Заполнение массива по строкам и столбцам
//Оказывается скорость заполнения отличается от способа заполнения
//#include <stdio.h>
//#include <stdlib.h>
//#include <sys/time.h>
//#include <unistd.h>
//#include <math.h>

//#define MINDIM_M    1000
//#define MINDIM_N    1000
//#define MINDIM_K    1000
//#define MAXDIM_M    3300
//#define MAXDIM_N    3300
//#define MAXDIM_K    3300
//#define INC_M   100
//#define INC_N   100
//#define INC_K   100
//#define MIN_T   1

//struct timeval tv1, tv2, dtv;
//struct timezone tz;

////Запоминаем в глобальных переменных текущее время
//void time_start() {

//    gettimeofday(&tv1, &tz);

//}

////Расчитываем время, прошедшее с момента запуска time_start()
//long time_stop() {

//    gettimeofday(&tv2, &tz);
//    dtv.tv_sec = tv2.tv_sec - tv1.tv_sec;
//    dtv.tv_usec = tv2.tv_usec - tv1.tv_usec;

//        if(dtv.tv_usec < 0) {

//            dtv.tv_sec--;
//            dtv.tv_usec += 1000000;

//        }

//return dtv.tv_sec * 1000 + dtv.tv_usec / 1000;
//}

//double buffer1[MAXDIM_M*MAXDIM_N];
//double buffer2[MAXDIM_M*MAXDIM_N];

//void initMatrix(size_t m, size_t n, double *A, size_t incRowA, size_t incColA) {

//    size_t j, i;

//        for (j = 0; j < n; ++j)
//            for (i = 0; i < m; ++i)
//                A[i * incRowA + j * incColA] = j * n + i + 1;

//}

//void printMatrix(size_t m, size_t n, const double *A,
//                 size_t incRowA, size_t incColA) {

//    size_t i, j;

//        for (i = 0; i < m; ++i) {

//            printf("   ");

//            for (j = 0; j < n; ++j)
//                printf("%4.1lf ", A[i * incRowA + j * incColA]);

//            printf("\n");

//        }

//    printf("\n");

//}

//int main() {

//    printf("   M    N      t1      t2   t2/t1\n");
//    printf("          col-maj row-maj\n");
//    printf("=====================================\n");

//    size_t m, n;

//        for (m = MINDIM_M, n = MINDIM_N; m < MAXDIM_M && n < MAXDIM_N;
//            m += INC_M, n += INC_N) {

//            size_t runs = 0;
//            double t1 = 0;

//            do {

//                time_start();
//                initMatrix(m, n, buffer1, 1, m);
//                t1 += time_stop();
//                ++runs;

//            } while (t1 < MIN_T);

//            t1 /= runs;
//            runs = 0;
//            double t2 = 0;

//            do {

//                time_start();
//                initMatrix(m, n, buffer2, n, 1);
//                t2 += time_stop();
//                ++runs;

//            } while (t2 < MIN_T);

//                t2 /= runs;
//                printf("%4d %4d %7.2lf %7.2lf %7.2lf\n", m, n, t1, t2, t2/t1);

//        }

//}
