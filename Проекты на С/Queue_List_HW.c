#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define T int
#define MaxN 10

typedef struct Node {   //Узел списка, тип данных Node

    int value;          //Значение узла
    struct Node *next;  //Указатель на следующий узел

} Node;

void PushList (T data, Node **head)  //Добавляем элемент в список
{
    Node *tmp = (Node*)malloc(sizeof(Node));    //Выделяем память под элемент
    tmp->value = data;      //Присваиваем значение в узел
    tmp->next = *head;      //Присваиваем адрес предыдущего узла
    *head = tmp;            //Присваиваем адрес нового узла

}

T PopList(Node **head)
{

    Node *prev = NULL;          //Временная переменная
    T val;
    if (head == NULL) {
        return 1;
    }
    prev = *head;               //Записываем адрес первого узла
    val = prev->value;          //И данные из узла
    (*head) = (*head)->next;    //Записываем адрес следующего узла
    free(prev);                 //Удаляем узел
    return val;

}

void PrintList (Node *head) {

    if (head == NULL) {
        printf("Empty");
    }
    while(head) {

        printf("%c ", head->value);
        head = head->next;

    }
    printf("\n");

}

Node *CopyList(Node *head)
{
    Node *tmp2 = (Node*)malloc(sizeof(Node));
    tmp2->value = head->value;
    Node *tmp3 = tmp2;
    head = head->next;
    while(head) {

        tmp2->next = (Node*)malloc(sizeof(Node));
        tmp2->next->value = head->value;
        tmp2 = tmp2->next;
        head = head->next;

    }

return tmp3;
}

int priority (char c) {

    if (c == '/') return 3;
    else if (c == '*') return 2;
    else if (c == '+') return 1;
    else if (c == '-') return 1;
    else return 5;

}

typedef struct queue {

    int q[MaxN];
    int head, tail;

} Queue;

void Insert (Queue *qu, int data) {

    if (qu->tail < MaxN - 1) {

        qu->tail++;
        qu->q[qu->tail] = data;

    } else if (qu->tail < qu->head) {

        printf("Empty\n");
        return;

    } else {

        printf("Full\n");
        return;
    }

}

void PrintQueue (Queue *qu) {

    if (qu->tail < qu->head) {

        printf("Empty\n");
        return;

    }
    for (int i = qu->head; i <=qu->tail; i++)
        printf("%d ", qu->q[i]);
    printf("\n");

}

int Remove (Queue *qu) {

    int data;
    if (qu->tail < qu->head) {

        printf("Empty\n");
        return 0;

    }
    data = qu->q[qu->tail];
    for (int i = qu->head; i < qu->tail; i++) {

        qu->q[i] = qu->q[i + 1];

    }
    qu->tail--;

return data;
}

int main()
{

    //4.Создать функцию, копирующую односвязный список (то есть создающую в памяти копию односвязного
    //списка без удаления первого списка).
    Node *head = NULL;  //Указатель на первый элемент списка
    PushList(1, &head);
    PushList(2, &head);
    PushList(3, &head);
    puts("Элементы списка после добавления и удаления:");
    PrintList(head);
    PopList(&head);
    PrintList(head);
    puts("Оригинал и копия списка:");
    Node *newhead = NULL;
    newhead = CopyList(head);
    PrintList(head);
    PrintList(newhead);
    PushList(3, &newhead);
    PopList(&head);
    puts("+1 к новому списку и -1 к старому:");
    PrintList(newhead);
    PrintList(head);
    PopList(&head);
    PopList(&newhead);
    PopList(&newhead);

    //5. *Реализовать алгоритм перевода из инфиксной записи арифметического выражения в постфиксную.
    char str[256] = "((1+2*(3*4)+5)/2)*5";
    int len = strlen(str);
    for (int i = 0; i < len; i++) {

        if (isdigit(str[i]) != 0) {

            PushList(str[i], &newhead);

        } else if (str[i] == '(') {

            PushList(str[i], &head);

        } else if (str[i] == ')') {

            while(head->value != '(') {

                PushList(PopList(&head), &newhead);

            }
            PopList(&head);

        } else {

            if (head == NULL || head->value == '(') {

                PushList(str[i], &head);

            } else if (priority(str[i]) > priority(head->value)) {

                PushList(str[i], &head);

            } else if (priority(str[i]) <= priority(head->value)) {

                while (head->value != '(' || (priority(str[i]) >= priority(head->value))) {

                    PushList(PopList(&head), &newhead);

                }
                PushList(str[i], &head);

            }

        }

    }
    PushList(PopList(&head), &newhead);
    while(newhead != NULL) {

        PushList(newhead->value, &head);
        newhead = newhead->next;

    }
    puts("Строка из постфиксной записи:");
    PrintList(head);
    puts(" ");

    //6. Реализовать очередь c использованием массива.
    Queue Qu;
    Qu.head = 1;
    Qu.tail = 0;
    Insert(&Qu, 1);
    Insert(&Qu, 2);
    Insert(&Qu, 3);
    Insert(&Qu, 4);
    Insert(&Qu, 5);
    puts("Вывод очереди на основе массива:");
    PrintQueue(&Qu);
    Remove(&Qu);
    Remove(&Qu);
    Remove(&Qu);
    PrintQueue(&Qu);

return 0;
}
