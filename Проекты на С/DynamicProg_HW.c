#include <stdio.h>
#include <string.h>

#define max(a,b) ((a > b) ? a : b)
#define N 5
#define M 5

int lcs_length(char *A, char *B) {

    int i, j, n, m, c;
    int array[strlen(A)][strlen(B)];

        n = strlen(A);
        m = strlen(B);
                    //Задача похожа на нахождение числа маршрутов
                    //Сравниваем граничные значения
        for(j = 0; j < m; j++) {    //Сравниваем "Вниз"

            c = (B[j] == A[0])? 1: 0;
            array[0][j] = c;

        }

        c = 0;

        for(i = 0; i < n; i++) {    //Сравниваем "Вправо"

            c = (B[0] == A[i])? 1: 0;
            array[i][0] = c;

        }

        for(i = 1; i < n; i++) {    //Сравниваем внутренние значения

            for(j = 1; j < m; j++) {

                if(A[i] == B[j]) {

                    array[i][j] = 1 + array[i -1][j - 1];

                } else {

                    array[i][j] = max(array[i - 1][j], array[i][j - 1]);

                }

            }

        }

        for(i = 0; i < n; i++) {

            puts(" ");

            for(j = 0; j < m; j++)

                printf("%2d ", array[i][j]);

        }

        c = array[0][0];

        for(i = 0; i < n; i++)
            for(j = 0; j < m; j++)
                if(array[i][j] > c)
                    c = array[i][j];

    puts(" ");

return c;
}

int var[8][2]= { {2, 1},
                 {2, -1},
                 {1, 2},
                 {1, -2},
                 {-1, 2},
                 {-1, -2},
                 {-2, 1},
                 {-2, -1} };

int cntsteps(int x, int y, int A[N][M]) {

    int k, xn, yn;
    int count = 0;

        if((x < 0 || x >= M || y < 0 || y >= M || A[x][y] != 0)) {

            return -1;      //Проверяем, можно ли ходить

        }

        for(k = 0; k < 8; k++) {

            xn = x + var[k][0]; //если можно ходить, то считаем
            yn = y + var[k][1]; //сколько шагов есть дальше

                if(xn >= 0 && xn < M && yn >= 0 && yn < M && A[xn][yn] == 0) {

                    count++;

                }

        }

return count;
}

int main() {

//1.Найти количество маршрутов на доске с препятствиями
    int map[N][M] = { {1, 1, 1, 1, 1},
                      {1, 0, 1, 0, 1},
                      {1, 1, 1, 1, 1},
                      {1, 1, 0, 1, 1} };
    int i, j;

        for(i = 0; i < N - 1; i++) {

            if(map[i][0] == 0)

                map[i + 1][0] = 0;  //Проверка на препятствие снизу

        }

        for(j = 0; j < M - 1; j++) {

            if(map[0][j] == 0)

                map[0][j + 1] = 0;  //Проверка на препятствие справа

        }

        for(i = 1; i < N; i++) {

            for(j = 1; j < M; j++) {    //Обходим другие пути

                if(map[i][j] == 0) continue;
                map[i][j] = map[i - 1][j] + map[i][j - 1];

            }

        }

        for (i = 0; i < N; i++) {

            for (j = 0; j < M; j++) {

                printf("%3d", map[i][j]);

            }

            puts(" ");

        }

    printf("Количество маршрутов: %d\n", map[i - 1][j - 1]);

//2.Найти длину наибольшей общей подпоследовательности с помощью матрицы

    printf("Наибольшая общая подпоследовательность: %d\n\n",
           lcs_length("0514421253", "151123"));

//3.Задача о ходе коня

    int Arr[N][M];
    int steps[8];   //Сделать можно 8 различных шагов
    int x, y ,n, m;
    int sx = 0;
    int cnt = 1;

    int var[8][2]= { {2, 1},
                     {2, -1},
                     {1, 2},
                     {1, -2},
                     {-1, 2},
                     {-1, -2},
                     {-2, 1},
                     {-2, -1} };

    for(i = 0; i < N; i++)
        for(j = 0; j < M; j++)
            Arr[i][j] = 0;

        printf("Введите координату поля Х: ");
        scanf("%d", &x);
        printf("Введите координату поля У: ");
        scanf("%d", &y);

    Arr[x][y] = 1;      //Начальная точка, из которой будем ходить

        do {

            for(n = 0; n < 8; n++) {
                //Записываем количество возможных последующих шагов
                steps[n] = cntsteps(x + var[n][0], y + var[n][1], Arr);

            }

            for(n = 0; n < 8; n++) {

                if(steps[n] > 0) {  //Отсекаем запрещенные ходы

                    sx = n;         //Проверка на тупик
                    break;

                }

                if(n == 7) {        //Если дошли до конца

                    for(m = 0; m < 8; m++) {

                        if(steps[m] == 0) {     //делаем последний ход

                            Arr[x + var[m][0]][y + var[m][1]] = ++cnt;

                        }

                    }

                    for(i = 0; i < M; i++) {

                        puts(" ");
                        for(j = 0; j < M; j++) {

                            printf("%4d ",Arr[i][j]);

                        }

                    }

                    puts(" ");
                    return 0;   //Завершаем цикл

                }

            }

            for(n = 0; n < 8; n++) {    //Проверяем шаги

                if(steps[n] < steps[sx] && steps[n] > 0) {

                    sx = n;

                }

            }
                        //Фиксируем новые координаты
                x += var[sx][0];
                y += var[sx][1];
                Arr[x][y] = ++cnt;  //Отмечаем положение коня

        } while (1);

return 0;
}
