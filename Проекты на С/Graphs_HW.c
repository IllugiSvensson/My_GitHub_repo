//Написать программу поиска кратчайшего маршрута между вершинами используя алгоритм Дийкстра.
//Считать матрицу весов из файла и вывести её на экран
//Обойти граф в глубину(рекурсивно) и в ширину
//Найти маршрут между двумя любыми вершинами
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define N 11
FILE *file;
typedef struct Node {   //Узел списка, тип данных Node

    int value;          //Значение узла
    struct Node *next;  //Указатель на следующий узел
    struct Node *prev;

} Node;

void swapRow(int array[N][N], int n)
{
    int arr[N];
    for(int i = 0; i < 9; i++)
    {
        arr[i] = array[n][i];
        array[n][i] = array[0][i];
        array[0][i] = arr[i];
    }
}

void DFS(int array[N][N], int *arr, int n)
{

    arr[n] = n + 65;
    for (int i = 0; i < N; i++)
    {
        if ((array[n][i] != 0) && (arr[i] == 0))
            DFS(array, arr, i);

    }

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

        return data;

    }

}

void BFS(int array[N][N], int *arr, int n, Node **head, Node **tail)
{
    arr[n] = n + 65;
    PushBack(n, head, tail);
    int tmp;
    while ((*head != NULL) && (*tail != NULL))
    {
        tmp = PopFront(tail, head);
        for(int i = 0; i < N; i++)
        {
            if ((array[tmp][i] != 0) && (arr[i] == 0))
            {
                PushBack(i, head, tail);
                arr[i] = i + 65;
            }
        }

    }

}

void findPath(int array[N][N], int *arr, int n, int e, Node **head, Node **tail)
{
    arr[n] = 0;
    PushBack(n, head, tail);
    int tmp;
    while ((*head != NULL) && (*tail != NULL))
    {
        tmp = PopFront(tail, head);
        for (int i = 0; i < N; i++)
        {
            if ((array[tmp][i] != 0) && (array[tmp][i] + arr[tmp] < arr[i]))
            {
                PushBack(i, head, tail);
                arr[i] = array[tmp][i] + arr[tmp];
            }
        }
    }
    int current = e;
    if ((arr[e] == 99) || (arr[n]) == 99)
    {
        puts("No Path!");
    } else {

        printf("%c ", e + 65);
        while (current != arr[n])
        {
            for (int i = 0; i < N; i++)
            {
                if ((array[e][i] != 0) && (arr[e] - array[e][i]) == arr[i])
                {
                    printf("%c ", i + 65);
                    e = i;
                    current = arr[e] - array[e][i];
                    break;
                }
            }
        }
    }
}

int main ()
{
    //Считать матрицу весов и вывести её на экран
    int array[N][N] = {0};
    file = fopen("/home/sad/Desktop/Projects/C_Prj/file", "r");
    if (file == NULL) {
        puts("Can't open file!");
        return 1;
    }
    for (int i = 0; i < N; i++)
        for(int j = 0; j < N; j++)
            fscanf(file, "%d", &array[i][j]);
    fclose(file);
    puts("Матрица весов: ");
    for (int i = 0; i < N + 1; i++)
         printf("%c  ", i + 64);
    puts("");
    for (int i = 0; i < N; i++)
    {
        printf("%c  ", i + 65);
        for(int j = 0; j < N; j++)
            printf("%d  ", array[i][j]);
        puts("");
    }

    //Обход графа в глубину
    //swapRow(array, 0);
    int arr[N] = {0};
    DFS(array, arr, 0);
    puts("Вершины, соединенные одним маршрутом: ");
    for (int i = 0; i < N; i++)
        printf("%c  ", arr[i]);
    puts("");

    //Обход графа в ширину
    for (int i = 0; i < N; i ++)
         arr[i] = 0;
    Node *tail = NULL,  *head = NULL;
    BFS(array, arr, 0, &head, &tail);
    puts("Вершины, соединенные одним маршрутом: ");
    for (int i = 0; i < N; i++)
        printf("%c  ", arr[i]);
    puts("");

    //Поиск маршрутов алгоритмом Дийкстры
    for (int i = 0; i < N; i ++)
         arr[i] = 99;
    puts("Кратчайший путь: ");
    findPath(array, arr, 9, 5, &head, &tail);
    puts("");

return 0;
}
