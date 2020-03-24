#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define T int
#define MaxN 1000

T StackA[MaxN];
int N = -1;

//Реализация стека с использованием массива
void pushA(T i) {

    if (N < MaxN) {

        N++;
        StackA[N] = i;

    } else printf("Стек переполнен");

}

T popA() {

    if (N != -1) {

        return StackA[N--];

    } else printf("Стек пуст");

}

//Реализация стека с использованием списка
struct TNode {  //Структура узел списка

    T value;            //Данные
    struct TNode *next; //Указатель на следующий элемент

};
typedef struct TNode Node;

struct Stack {

    Node *head;
    int size;
    int maxSize;

};
struct Stack Stack;

void push(T value) {

    if (Stack.size >= Stack.maxSize) {

        printf("Неверный размер стека");
        return;

    }
            //Создаем указатель на узел
        Node *tmp = (Node*) malloc(sizeof(Node));
        tmp->value = value;         //Записываем в него
        tmp->next = Stack.head;     //данные и предыдущее значение указателя
        Stack.head = tmp;       //Увеличиваем размер стека и запоминаем
        Stack.size++;           //указатель на текущий элемент

}

T pop() {

    if (Stack.size == 0) {

        printf("Стек пуст");
        return 0;

    }

        Node* Next = NULL;  //Временный указатель
        T Value;            //Значение наверху списка
        Value = Stack.head->value;
        Next = Stack.head;
        Stack.head = Stack.head->next;
        free(Next);         //Удаляем предыдущую запись
        Stack.size--;       //Уменьшаем размер стека

return Value;
}

void PrintStack() {

    Node *current = Stack.head;

        while(current != NULL) {

            printf("%d ", current->value);
            current = current->next;

        }

}

//Структура из нескольких стеков
struct TStack {

    int N;
    T Data[MaxN];

};
struct TStack Stack1;
struct TStack Stack2;
struct TStack Stack3;

void pushT(struct TStack *Stack, T data) {

    Stack->N++;
    (*Stack).Data[(*Stack).N] = data;

}

T popT(struct TStack *Stack) {

    if (Stack->N != -1)
        return Stack->Data[Stack->N--];

}

void init(struct TStack *Stack) {

    Stack->N = -1;

}

//Вычисление выражения в постфиксной записи
Node* head = NULL;

void Push(T value) {

    Node *temp;
    temp = (Node*)malloc(sizeof(Node));
    temp->value = value;
    temp->next = head;
    head = temp;

}

T Pop() {

    Node* temp = NULL;
    T value = head->value;
    temp = head;
    head = head->next;
    free(temp);

return value;
}

void Print() {

    Node* current;
    current = head;

        while (current != NULL) {

            printf("%d ", current->value);
            current = current->next;

        }

}

void PrintR(Node* current) {

    if (current != NULL) {

        PrintR(current->next);
        printf("%d ", current->value);

    }

}

int isNumber(char *str) {

    int i = 0;

        while (str[i] != '\0')
            if (!isdigit(str[i++]))
                return 0;

return 1;
}

int main() {

    pushA(1);
    pushA(2);
    pushA(3);
    pushA(4);
    pushA(5);
    pushA(6);

        while(N != -1)
            printf("%d ", popA());

    puts(" ");

    Stack.maxSize = 100;
    Stack.head = NULL;

        push(1);
        push(2);
        push(3);
        push(4);
        push(5);
        push(6);
        PrintStack();

    puts(" ");

    init(&Stack1);
    init(&Stack2);
    init(&Stack3);

        pushT(&Stack1, 1);
        pushT(&Stack1, 2);
        pushT(&Stack2, 3);
        pushT(&Stack3, 4);
        pushT(&Stack1, 5);
        pushT(&Stack1, 6);

            while(Stack1.N != -1)
                printf("%d ", popT(&Stack1));

            printf("%d ", popT(&Stack2));
            printf("%d ", popT(&Stack3));

    puts(" ");

    int res = 0;
    char buf[100] = "20 30 - 10 *"; // (30 - 20) * 10
        //Выражение, разделенное пробелами (по одному пробелу!)

        int i;
        for (i = 0; i < strlen(buf); i++) {
            //Получаем элемент из строки
            char el[20];                //Элемент (число или операция)
            int j = 0;
            while (buf[i] != ' ' && buf[i] != '\0') {

                el[j] = buf[i];
                j++;
                i++;

            }

            el[j] = '\0';
                //Если элемент – число
                if (isNumber(el))
                    Push(atoi(el));         //Кладём его в стек, преобразовав из
                                            //строки в integer
                else {

                    switch (el[0]) {
                        case '+':
                            res = Pop() + Pop();
                            Push(res);
                            break;
                        case '-':
                            res = -Pop() + Pop();
                            Push(res);
                            break;
                        case '*':
                            res = Pop() * Pop();
                            Push(res);
                            break;
                        case '/':
                            res = Pop() / Pop();
                            Push(res);
                            break;
                    default:
                            break;

                    }

                }

            }

        printf("Решение: %d \n", Pop());

return 0;
}
