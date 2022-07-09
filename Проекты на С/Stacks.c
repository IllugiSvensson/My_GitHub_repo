#include <stdio.h>
#include <stdlib.h>

#define T int  //Для первой задачи поменять на int
#define MaxN 1000

T Stack[MaxN];
int N = -1;

void Push(T i) {

    if(N < MaxN) {

        N++;
        Stack[N] = i;

    } else {

        printf("Стек переполнен!\n");

    }

}

T Pop() {

    if(N != -1) {

        return Stack[N--];

    } else {

        printf("Стек пуст!\n");

    }

}

typedef struct TNode {

    T value;
    struct Node *next;

} Node;
struct StackList {

    Node *head;
    int size;
    int maxSize;

};
struct StackList Stck;

void PushList(T value) {

    if(Stck.size >= Stck.maxSize) {

        printf("Стек переполнен!\n");
        return;

    }

    Node *tmp = (Node*)malloc(sizeof(Node));    //Выделяем память под новый элемент
    if(tmp == NULL) {

        printf("Ошибка выделения памяти!\n");
        exit(0);

    }

        tmp->value = value;         //Записываем данные
        tmp->next = Stck.head;      //Записываем предыдущее значение
        Stck.head = tmp;            //Указываем на вновь созданный элемент
        Stck.size++;

}

T PopList() {

    if(Stck.size == 0) {

        printf("Стек пуст!\n");
        return 0;

    }

    Node *next = NULL;              //Временный указатель
    T value;
    value = Stck.head->value;       //сохраняем данные
    next = Stck.head;
    Stck.head = Stck.head->next;    //Записываем предыдущий элемент
    free(next);
    Stck.size--;

return value;
}

void PrintStack() {

    Node *current = Stck.head;  //Вершина списка

        while(current != NULL) {

            printf("%d ", current->value);
            current = current->next;

        }

    puts(" ");

}

int main() {

//1.Реализовать перевод из десятичной в двоичную систему счисления с использованием стека.
    int dec;

        while(1) {  //Проверяем ввод пользователя

            printf("Введите число для перевода: ");
            scanf("%d", &dec);

                if(dec < 0) {

                    printf("Введите целое положительное число\n");

                } else if (dec == 0) {

                    Push(0);
                    break;

                } else break;

        }

        while(dec != 0) {

            Push(dec % 2);  //Кладем в стек остаток от деления на два
            dec = dec / 2;  //Делим число на два циклично

        }

    printf("Двоичное представление: ");

        while(N != -1) {

            printf("%d", Pop());   //Вынимаем из стека бинарные числа

        }

    puts(" ");

//2.Добавить в программу «Реализация стека на основе односвязного списка» проверку на выделение
//памяти. Если память не выделяется, то должно выводиться соответствующее сообщение. Постарайтесь
//создать ситуацию, когда память не будет выделяться (добавлением большого количества данных).

    Stck.maxSize = 10;
    Stck.head = NULL;

        for(dec = 0; dec < 10; dec++) {

            PushList(dec);

        }
    //При добавлении большого количества данных виснет комп.
    //при этом память используется на 100%
    PrintStack();
    puts(" ");

//3.Написать программу, которая определяет, является ли введённая скобочная последовательность
//правильной. Примеры правильных скобочных выражений – (), ([])(), {}(), ([{}]),
//неправильных – )(, ())({), (, ])}), ([(]), для скобок – [, (, {.
//Например: (2+(2*2)) или [2/{5*(4+7)}].

    char *arr;
    unsigned int i;
    arr = "[2/{5*({}4+7)}]";

        for(i = 0; i < strlen(arr); i++) {

            switch(arr[i]) {

                case '(':
                    Push(arr[i]);
                    break;
                case '{':
                    Push(arr[i]);
                    break;
                case '[':
                    Push(arr[i]);
                    break;
                case ')':
                    if((N == -1)  || (Stack[N] != '(')) {
                        Push(arr[i]);
                    } else Pop();
                    break;
                case '}':
                    if((N == -1)  || (Stack[N] != '{')) {
                        Push(arr[i]);
                    } else Pop();
                    break;
                case ']':
                    if((N == -1)  || (Stack[N] != '[')) {
                        Push(arr[i]);
                    } else Pop();
                    break;

                }

            }

        if(N != -1)

            printf("Ошибки в последовательности!\n\n");

        else

            printf("Последовательность верна!\n\n");

return 0;
}
