#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define T int
#define MaxN 5

typedef struct Node {   //Узел списка, тип данных Node

    int value;          //Значение узла
    struct Node *next;  //Указатель на следующий узел
    struct Node *prev;

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
    Node *prev = NULL;          //Временный узел
    T val;
    if (*head == NULL) {
        printf("List is Empty!");
        return 0;
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
    Node *current = head;
    while(current != NULL) {

        printf("%d ", current->value);
        current = current->next;

    }
    printf("\n");
}

Node *CopyList(Node *head)          //Функция копирования возвращает указатель на первый элемент списка
{
    Node *tmp = (Node*)malloc(sizeof(Node));
    tmp->value = head->value;
    Node *tmpR = tmp;
    Node *current = head->next;
    while (current != NULL){
        tmp->next = (Node*)malloc(sizeof(Node));
        tmp->next->value = current->value;
        tmp = tmp->next;
        current = current->next;
    }

    return tmpR;
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

void Insert_m(Queue *queue, int data)
{

    if (((queue->head + 1)%MaxN) == queue->tail){

        queue->q[queue->head] = data;
        printf("Queue is Full\n");
    }
    else {

        queue->q[queue->head] = data;
        queue->head = (queue->head + 1)%MaxN;

    }
}

int Remove_m(Queue *queue){

    int d;
    if (((queue->tail)%MaxN) == queue->head) {
        d = queue->q[queue->tail];
        queue->q[queue->tail] = 0;
        printf("Queue is Empty!\n");
        return d;
    }
    else {

        d = queue->q[queue->tail];
        queue->q[queue->tail] = 0;
        queue->tail = (queue->tail + 1)%MaxN;
        return d;
    }

}

void PrintQueue(Queue *queue){

    for(int i = 0; i < MaxN; i++)
        printf("%d ", queue->q[i]);
    puts(" ");
}

void Insert_l(int data, Node **head, Node **tail){

    Node *tmp = (Node*)malloc(sizeof(Node));
    tmp->value = data;
    tmp->next = NULL;
    if (*head == NULL) {

        *head = tmp;
        *tail = tmp;

    } else {

        (*tail)->next = tmp;
        *tail = tmp;

    }

}

int Remove_l(Node **head) {

    if (*head == NULL) {
        puts("Queue is Empty");
    }
    else {

        Node *tmp = NULL;
        int val;
        tmp = *head;
        val = tmp->value;
        (*head) = (*head)->next;
        free(tmp);
    }

}

void PrintDeck (Node *tail) {
    if (tail == NULL) {
        printf("Empty");
    }
    Node *current = tail;
    while(current != NULL) {

        printf("%d ", current->value);
        current = current->next;

    }
    printf("\n");
}

void PushBack(int data, Node **head, Node **tail)
{

    Node *tmp = (Node*)malloc(sizeof(Node));
    tmp->value = data;
    tmp->next = NULL;
    tmp->prev = *head;
    if (*head == NULL) {

        *head = tmp;
        *tail = tmp;

    } else {

        (*head)->next = tmp;
        *head = tmp;

    }

}

void PushFront(int data, Node **tail, Node **head)
{

    Node *tmp = (Node*)malloc(sizeof(Node));
    tmp->value = data;
    tmp->prev = NULL;
    tmp->next = *tail;
    if (*tail == NULL) {

        *head = tmp;
        *tail = tmp;

    } else {

        (*tail)->prev = tmp;
        *tail = tmp;

    }

}

int PopBack(Node **head, Node **tail)
{
    if (*head == NULL)
        puts("Deck is Empty");

    else {

        Node *tmp = NULL;
        int data;
        tmp = *head;
        data = tmp->value;
        if (*head != *tail)
            (*head) = (*head)->prev;
        else {
            *head = *tail = NULL;
        }

        free(tmp);
        printf("%d\n", data);
        return data;

    }

}

int PopFront(Node **tail, Node **head)
{
    if (*tail == NULL)
        puts("Deck is Empty");

    else {

        Node *tmp = NULL;
        int data;
        tmp = *tail;
        data = tmp->value;
        if (*tail != *head)
            (*tail) = (*tail)->next;
        else {
            *head = *tail = NULL;
        }
        free(tmp);
        printf("%d\n", data);
        return data;

    }

}



int main()
{

    //4.Создать функцию, копирующую односвязный список (то есть создающую в памяти копию односвязного
    //списка без удаления первого списка).
    Node *head = NULL;  //Указатель на первый элемент списка
    Node *tail = NULL;
    int i;
    for (i = 1; i <= 10; i++)
        PushList(i, &head);
    puts("Элементы списка после добавления:");
    PrintList(head);
    for (i = 5; i >= 1; i--)
        PopList(&head);
    puts("Элементы списка после удаления:");
    PrintList(head);
    puts("Оригинал и копия списка:");
    Node *newhead = CopyList(head);
    PrintList(head);
    PrintList(newhead);
    puts("+3 к новому списку и -2 к старому:");
    PushList(3, &newhead);
    PushList(13, &newhead);
    PushList(9, &newhead);
    PopList(&head);
    PopList(&head);
    PrintList(newhead);
    PrintList(head);
    for (i = 0; i < 8; i++){
        PopList(&head);
        PopList(&newhead);
    }
    printf("\n\n\n");

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
    Queue queue;
    for(int i = 0; i < MaxN; i++)
        queue.q[i]= 0;
    queue.head = 0;
    queue.tail = 0;
    Insert_m(&queue, 1);
    puts("Очередь на основе массива");
    PrintQueue(&queue);
    Insert_m(&queue, 1);
    Insert_m(&queue, 1);
    Remove_m(&queue);
    PrintQueue(&queue);
    //с использованием списка
    puts("");
    head = NULL;
    puts("Очередь на основе списка");
    for(int i = 0; i < MaxN; i++)
        Insert_l(i, &head, &tail);
    PrintList(head);
    Remove_l(&head);
    Remove_l(&head);
    PrintList(head);

    //7. Двустороняя очередь
    puts("");
    printf("Двусторонняя очередь: \n");
    head = tail = NULL;
    PopFront(&tail, &head);
    PopBack(&head, &tail);
    PushBack(9, &head, &tail);
    PushBack(8, &head, &tail);
    PushBack(7, &head, &tail);
    PrintDeck(tail);
    PushFront(5, &tail, &head);
    PrintDeck(tail);
    PopBack(&head, &tail);
    PopBack(&head, &tail);
    PopFront(&tail, &head);
    PopFront(&tail, &head);
    PopFront(&tail, &head);
    PopFront(&tail, &head);
    PopBack(&head, &tail);


return 0;
}

