#include <stdio.h>
#include <string.h>
#define ARR_SIZE 20

void loop(int a, int b) {

    printf("%3d", a);

        if (a < b) loop(a + 1, b);
        //Цикл от а до b с шагом 1
}

int sumDigit(long a) {

    if (a == 0) {

        return 0;

    } else {

        return sumDigit(a / 10) + a % 10;
    }

}

int G(int n);   //Нужен прототип для вызова в другой рекурсии
int F(int n) {

    if (n > 2) {

        return F(n - 1) + G(n - 2);

    } else  {

        return n;

    }

}

int G(int n) {

    if (n > 2) {

        return G(n - 1) + F(n - 2);

    } else {

        return 3 - n;

    }

}

int fib(int n) {    //В рекурсии важно определить выход из нее

    if (n == 0) return 0;
    if (n == 1) return 1;

return fib(n - 1) + fib(n - 2);
}

int count = 0;
void findWords(char* A, char *word, unsigned int N);
void more() {

   char word[] = "...";              // Длина слова. Чем больше точек, тем
                                     // длиннее слово
   findWords("more", word, 0);

}

void findWords(char* A, char *word, unsigned int N) {

    if (N == strlen(word)) {           // Слово построено

         printf("%d %s\n", ++count, word);
         return;

    }

    unsigned int i;
    char *w;
    w = word;

        for(i = 0; i < strlen(A); i++) {

            w[N] = A[i];
            findWords(A, w, N + 1);     // Рекурсия
        }

}

void TowerOfHanoi(int from, int to, int other, int n) {

   if (n > 1) TowerOfHanoi(from, other, to, n - 1);

    printf("%d %d\n", from, to);

   if (n > 1) TowerOfHanoi(other, to, from, n - 1);

}

int map[10][10] = { //Карта закраски
    {0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 1, 0, 0, 0},
    {0, 1, 1, 0, 0, 0, 0, 1, 1, 0},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {0, 1, 1, 0, 0, 0, 0, 1, 1, 0},
    {0, 0, 0, 1, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 0, 0, 0, 0}
};
int k = 0;
void Paint(int x, int y) {
        //Алгоритм обхода области
   if (map[x][y] == 0) {

       k++;
       map[x][y] = k;
       Paint(x, y - 1);
       Paint(x - 1, y);
       Paint(x, y + 1);
       Paint(x + 1, y);

   }

}

struct State {

    int n;
    int src;
    int dest;
    int tmp;
    int step;

};
typedef struct State State;

#define T State
#define MaxN 1000
T stack[MaxN];
int N = -1;
void push(T i) {

    if (N < MaxN) {

        N++;
        stack[N] = i;

    } else printf("Stack overflow");

}

T pop() {

    if (N != -1) return stack[N--];
    else printf("Stack is empty");

}

T* back() {

    if (N != -1) return &stack[N];
    else printf("Stack is empty");

}

void tower(int n, int src, int dest, int tmp) {

    {
        State state;
        state.n = n;
        state.src = src;
        state.dest = dest;
        state.tmp = tmp;
        state.step = 0;
        push(state);
    }

        while (N != -1) {

            State* state = back();
            switch (state->step) {

                case 0:
                    if (state->n == 0) {

                        pop();

                    } else {

                        ++state->step;
                        State newState;
                        newState.n = state->n - 1;
                        newState.src = state->src;
                        newState.dest = state->tmp;
                        newState.tmp = state->dest;
                        newState.step = 0;
                        push(newState);

                    }
                    break;
                case 1:
                    printf("%d->%d\n",state->src,state->dest);
                    ++state->step;
                    State newState;
                    newState.n = state->n - 1;
                    newState.src = state->tmp;
                    newState.dest = state->dest;
                    newState.tmp = state->src;
                    newState.step = 0;
                    push(newState);
                    break;
                case 2:
                    pop();
                    break;
            }

        }

}

int main() {

    //Рекурсивный цикл
    loop(0, 10);
    printf("\n\n");

    //Сумма цифр числа. Рекурсия
    int n;

        printf("Введите число:");
        scanf("%d", &n);
        printf("Сумма цифр числа: %d\n\n", sumDigit(n));

    //Задача из ЕГЭ. Двойная рекурсия
    printf("Решение: %d\n\n", G(6));

    //Числа Фибоначчи, рекурсивно
    int i;

        for (i = 0; i < 20; i++) printf("%d ", fib(i));
        puts(" ");

    int f[ARR_SIZE];    //Тот же алгоритм, но с массивом

        f[0] = 0;
        f[1] = 1;

        for (i = 2; i < ARR_SIZE; i++) f[i] = f[i - 1] + f[i - 2];
        for (i = 0; i < ARR_SIZE; i++) printf("%d ", f[i]);
        printf("\n\n");

    //Рекурсивный перебор из букв
        more(); //Букв три
        puts(" ");

    //Ханойская башня
        TowerOfHanoi(1, 2, 3, 3);
        puts(" ");

    //Закраска замкнутой области
        Paint(4, 1); //Координаты начальной точки
        for (i = 0; i < 10; i++) {

            for(k = 0; k < 10; k++) {

                printf("%2d ", map[i][k]);
            }

            puts(" ");

        }

    //Ханойная башня с использованием стека без рекурсии (о стеках будет далее)
        // Перекладываем с первого на второй штырь
        // 1-й параметр – количество колец
        puts(" ");
            tower(3, 1, 2, 3);

return 0;
}
