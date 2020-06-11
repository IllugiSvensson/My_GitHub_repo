#include <stdio.h>
#include <stdlib.h>
#define MAXINT 2147483647
#define N 6//Количество вершин
#define M 5

int a[N]; //Массив с индексами
int W[N][N] = { {0, 1, 2, 11, 7, 12},
                {1, 0, 9, 10, 13, 11},
                {2, 9, 0, 8, 5, 8},
                {11, 10, 8, 0, 3, 1},
                {7, 13, 5, 3, 0, 3},
                {12, 11, 8, 1, 3, 0} }; //Матрица весов рёбер
int ostov[N - 1][2]; //Массив для хранения рёбер(которые соединяют вершины)
int w[M][M] = { {99, 2, 5, 99, 7},
                {2, 99, 1, 99, 99},
                {5, 1, 99, 5, 1},
                {99, 99, 5, 99, 3},
                {7, 99, 1, 3, 99} };
               //A,  B, C, D,  E - Путь от А до Е

//Построение минимального остовного дерева.
void painting () { //"Окрашиваем" вершины.

    int i;
    for(i = 0; i < N; i++)
        a[i] = i;

}

//Поиск кратчайшего маршрута. Алгоритм Дейкстры.
void printMatrix(int w[M][M]) {

    int i, j;
    printf("%s", "      ");

        for(i = 0; i < M; i++)
            printf("%c(%d) ", 65 + i, i);

    printf("\n");

        for(i = 0; i < M; i++) {

            printf("%c(%d)", 65 + i, i);

                for(j = 0; j < M; j++)
                    printf("%5d", (w[i][j] == MAXINT) ? 0 : w[i][j]);

            printf("\n");

        }

}

void printInfo(int P[M], int R[M]) {

    int i;
    printf("P:\n");

        for(i = 0; i < M; i++)
            printf("%c(%d) %c(%d)\n", P[i] + 65, P[i], i + 65, i);

    printf("R:\n");

        for(i = 0; i < M; i++)
            printf("%c%10d\n", i + 65, R[i]);

}

//Алгоритм Флойда-Уоршелла
void FloydWarshal(int w[M][M]) {

    int k, i, j;

    for(k = 0; k < M; k++)
        for(i = 0; i < M; i++)
            for(j = 0; j < M; j++)
                if (w[i][k] + w[k][j] < w[i][j])
                    w[i][j] = w[i][k] + w[k][j];

}

int main() {

    painting();
    int k, i, j;
    int iMin, jMin;

    //Построение минимального остовного дерева.
        for(k = 0; k < N - 1; k++) { //Поиск нужных рёбер
        //Поиск ребра с минимальным весом
            int min = MAXINT;
            for(i = 0; i < N; i++) {

                for(j = 0; j < N; j++) {

                    if (a[i] != a[j] && W[i][j] < min) {

                        iMin = i;
                        jMin = j;
                        min = W[i][j];

                    }

                }

            }

        //Добавление ребра в список выбранных
            ostov[k][0] = iMin;
            ostov[k][1] = jMin;

        //Перекрашивание вершин
            int jM = a[jMin], iM = a[iMin];
            for(i = 0; i < N; i++) {

                if (a[i] == jM) {

                    a[i] = iM;

                }

            }

        }

        //Вывод результата
        for(i = 0; i < N - 1; i++)
            printf("(%d,%d)\n", ostov[i][0], ostov[i][1]);

    puts(" ");
    //Поиск кратчайшего маршрута. Алгоритм Дейкстры.
    int active[M] = {0};               // Состояния вершин
    int Route[M], Peak[M];
    int min, kMin;

        for(i = 0; i < N; i++) {

            active[i] = 1;      //Если = 1, то вершина ещё не просмотрена
            Route[i] = w[0][i];
            Peak[i] = 0;

        }

    active[0] = 0; //Начинаем маршрут с вершины А(0), просмотрена.

        for(i = 0; i < N - 1; i++) {

            //Среди вершин ищем вершину с минимальным значением
            //printMatrix(w);
            //printInfo(Peak, Route);
            min = MAXINT;

                for(j = 0; j < M; j++)
                    if (active[j] == 1 && Route[j] < min) {

                        min = Route[j];  //Минимальный маршрут
                        kMin = j;        //Номер вершины с минимальным маршрутом

                    }

            active[kMin] = 0;   //Просмотрели эту точку

            //Проверка маршрута. Есть ли более короткий путь
                for(j = 0; j < N; j++)
                    //Если текущий путь в вершину j (R[j])
                    //больше чем путь из найденной вершины (R[kMin] +
                    //путь из этой вершины W[kMin][j], то
                    if (Route[j] > Route[kMin] + w[j][kMin] &&
                        w[j][kMin] != MAXINT && active[j] == 1) {

                        //мы запоминаем новое расстояние
                        Route[j] = Route[kMin] + w[j][kMin];
                        //и запоминаем, что можем добраться туда более
                        //коротким путём в массиве Peak
                        Peak[j] = kMin;
                        //printMatrix(w);
                        //printInfo(Peak, Route);

                    }

        }

    i = M - 1;

        while(i != 0) {

            printf("%c ", i + 65);
            i = Peak[i];

        }
    printf("A \n");

    //Алгоритм Флойда-Уоршелла
    FloydWarshal(w);
    printf("\n");
    printMatrix(w);

return 0;
}
