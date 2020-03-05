#include <stdio.h>
#include <stdlib.h>
#define N 8
#define M 8
int board[N][M]; //Шахматная доска. 0 - пустая клетка, Число - номер ферзя

void Print(int n, int m, int a[N][M]) {

    int i, j;

        for(i = 0; i < n; i++) {

            for(j = 0; j < m; j++) {

                printf("%2d", a[i][j]);

            }

            printf("\n");

        }

}

int max(int a, int b) {

    if(a == b) return 0;

return (a > b)? a: b;
}

int lcs_length(char * A, char * B) {

    if (*A == '\0' || *B == '\0') return 0;
    else if (*A == *B) return 1 + lcs_length(A + 1, B + 1);
    else return max(lcs_length(A + 1, B), lcs_length(A, B + 1));

}

int CheckBoard();
int SearchSolution(int n) {
//Если проверка возвращает 0, то расстановка не подходит
    if (CheckBoard() == 0) return 0;
//Девятого ферзя ставить не нужно. Решение найдено
    if (n == 9) return 1;

    int row;
    int col;

        for(row = 0; row < N; row++) {

            for(col = 0; col < M; col++) {

                if (board[row][col] == 0) {

                    board[row][col]=n;
                    //Рекурсивно проверяем, будет ли решение
                    if (SearchSolution(n+1)) return 1;
                    //Данное решение не приводит к полному
                    board[row][col]=0;

                }

            }

        }

return 0;
}

int CheckQueen(int x, int y);
int CheckBoard() {
    //Проверка доски
    int i, j;

        for(i = 0; i < N; i++)
            for(j = 0; j < M; j++)
                if (board[i][j] != 0)
                    if (CheckQueen(i, j) == 0)
                        return 0;
return 1;
}

int CheckQueen(int x, int y) {
    //Проверка определенного ферзя
    int i, j;

    for(i = 0; i < N; i++)
        for(j = 0; j < M; j++)
            //Если нашли фигуру
            if (board[i][j] != 0)
                if (!(i == x && j == y)) { //Проверяем
                //Лежат на одной вертикали или горизонтали
                    if (i - x == 0 || j - y == 0) return 0;
                //Лежат на одной диагонали
                    if (abs(i - x) == abs(j - y)) return 0;

                }
//Частичное решение найдено
return 1;
}

void Zero(int n, int m, int a[N][M]) {
    //Очищаем доску
    int i, j;

        for(i = 0; i < n; i++)
            for(j = 0; j < m; j++)
                a[i][j] = 0;

}

int main() {

    //Количество маршрутов из одной клетки доски в другую
    int A[N][M];
    int i, j;

        for(j = 0; j < M; j++) A[0][j] = 1; //Первая строка всегда только из единиц

        for(i = 1; i < N; i++) {

            A[i][0] = 1;        //Первый столбец так же из единиц

            for(j = 1; j < M; j++) {
                        //Ходим по правилу: только вправо или вниз
                A[i][j] = A[i][j-1] + A[i-1][j];

            }

        }

    Print((N - 5), (M - 5), A);
    printf("Количество различных маршрутов: %d\n\n", A[N - 1][M - 1]);

    //Наибольшая общая подпоследовательность
    printf("Длина наибольшей общей последовательности: %d\n", lcs_length("124421253", "151123"));

    //Задача о восьми ферзях
    Zero(N, M, board);
    SearchSolution(1);
    printf("\nДоска с ферзями: \n");
    Print(N, M, board);

return 0;
}
