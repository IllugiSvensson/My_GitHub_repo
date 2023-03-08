#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>

typedef int T;
typedef int hashTableIndex;     //Индекс в хэш-таблице
#define compEQ(a, b) (a == b)   //Определим директиву сравнения двух значений
FILE *file;

typedef struct Node_ {
    T data;                   // Данные, сохранённые в узле
    struct Node_ *next;       // Следующий узел
} Node;

typedef struct SNode {

    T data;
    struct SNode *left;
    struct SNode *right;
    struct SNode *parent;

} SNode;

//Построение идеально сбалансированного дерева с n узлами
SNode* BTree(int n) {

    SNode* newNode;
    int x, nl, nr;

        if (n == 0)     //Если элементов нет, то строим пустое дерево

            newNode = NULL;

        else {          //Если элементы есть, считываем элемент

            fscanf(file, "%d", &x);
            nl = n / 2;
            nr = n - nl - 1;
            newNode = (SNode*)malloc(sizeof(SNode));  //Выделяем память под новый узел
            newNode->data = x;                        //Распределяем элементы в левое и правое
            newNode->left = BTree(nl);                //поддерево равномерно
            newNode->right = BTree(nr);

        }

return newNode;
}

//Распечатка двоичного дерева в виде скобочной записи
void printTree(SNode *root) {

    if (root) {                                 //Если есть корень

        printf("%d", root->data);

            if (root->left || root->right) {    //Проверяем, есть ли ссылки на поддерева

                printf("(");                    //Если ссылка есть, рекурсивно обходим дерево

                    if (root->left)

                        printTree(root->left);

                    else

                        printf("NULL");

                printf(",");

                    if (root->right)

                        printTree(root->right);

                    else

                        printf("NULL");

                printf(")");

            }

    }

}

//Создание нового узла
SNode* getFreeNode(T value, SNode *parent) {

    SNode* tmp = (SNode*)malloc(sizeof(SNode));
    tmp->left = tmp->right = NULL;
    tmp->data = value;
    tmp->parent = parent;

return tmp;
}

//Вставка узла
void insert(SNode **Tree, int value) {

    SNode *tmp = NULL;

    if (*Tree == NULL) {

        *Tree = getFreeNode(value, NULL);
        return ;

    }

    tmp = *Tree;

        while (tmp) {

            if (value >= tmp->data) {

                if (tmp->right) {

                    tmp = tmp->right;
                    continue;

                } else {

                    tmp->right = getFreeNode(value, tmp);
                    break;

                }

            } else if (value <= tmp->data) {

                if (tmp->left) {

                    tmp = tmp->left;
                    continue;

                } else {

                    tmp->left = getFreeNode(value, tmp);
                    break;

                }

            } else {

                exit(2);             //Дерево построено неправильно

            }

        }

}

void preOrderTravers(SNode* root) {

    if (root) {

        printf("%d ", root->data);
        preOrderTravers(root->left);
        preOrderTravers(root->right);

    }

}

Node **hashTable;
int hashTableSize;

hashTableIndex hash(T data)
{
// Хэш-функция, применяемая к данным
    return (data % hashTableSize);
}

Node *insertNode(T data)
{
    Node *p, *p0;
    hashTableIndex bucket;
// Распределим узел для данных и вставим в таблицу
// Вставка узла в начало таблицы
    bucket = hash(data);       // Рассчитываем номер блока
    p = (Node*)malloc(sizeof(Node));
    if (p == 0) {
    //В стандартный поток ошибок выводим сообщение о нехватке памяти
        fprintf(stderr, "out of memory (insertNode)\n");
        exit(1);
    }
    p0 = hashTable[bucket]; //Запоминаем текущее значение указателя найденного блока
    hashTable[bucket] = p; //В найденный блок записываем новый элемент
    p->next = p0; //Связываем новый элемент со старым
    p->data = data; //Записываем данные в новый элемент
    return p;
}

// Удаление узла
void deleteNode(T data) {
    Node *p0, *p;
    hashTableIndex bucket;
// Удаляем узел, содержащий данные из таблицы
// Находим узел
    p0 = 0;
    bucket = hash(data);
    p = hashTable[bucket];
    while (p && !compEQ(p->data, data)) {
        p0 = p;
        p = p->next;
    }
    if (!p)
        return;
// p – искомый узел, удаляем его из списка
    if (p0)
// Не первый, p0 указывает на предыдущий
        p0->next = p->next;
    else
// Первый в цепочке
        hashTable[bucket] = p->next;
    free(p);
}

Node *findNode(T data) {
    Node *p;
// Нахождение узла, содержащего данные
    p = hashTable[hash(data)];
    while (p && !compEQ(p->data, data))
        p = p->next;
    return p;
}

void printTable(int size) {
    Node *p;
    for (int i = 0; i < size; i++)
    {
        p = hashTable[i];
        while (p)
        {
            printf("%5d", p->data);
            p = p->next;
        }
        printf("\n");
    }
}


int main(int argc, char **argv) {

//Построение идеально сбалансированного дерева
    puts("Balanced tree:");
    SNode* tree = NULL;
    file = fopen("/home/sad/Projects/file", "r");
    if (file == NULL) {
        puts("Can't open file!");
        return 1;
    }
    int count, cnt = 0;
    while(fscanf(file, "%d", &count) !=EOF)
        cnt++;              //Считываем количество записей
    fclose(file);
    file = fopen("/home/sad/Projects/file", "r");
    tree = BTree(cnt);           //Строим дерево
    fclose(file);
    printTree(tree);            //Печатаем скобочную запись
    puts(" ");
    puts(" ");

//Построение дерева поиска
    puts("Search tree:");
    SNode *Tree = NULL;
    file = fopen("/home/sad/Projects/file", "r");
    if (file == NULL) {
        puts("Can't open file!");
        return 1;
    }
    int i;
    cnt = count = 0;
    while(fscanf(file, "%d", &count) !=EOF)
        cnt++;              //Считываем количество записей
    fclose(file);
    file = fopen("/home/sad/Projects/file", "r");
    for(i = 0; i < cnt; i++) {
        int value = 0;
        fscanf(file, "%d", &value);
        insert(&Tree, value);
    }
    fclose(file);
    printTree(Tree);
    printf("\nPreOrderTravers:");
    preOrderTravers(Tree);
    puts(" ");
    puts(" ");

//ХЭШ таблица
    int *a, maxnum, random;
    if (argc < 2) {
        printf("incorrect command line\ncommand line maxnum hashTableSize [random]\nSample:\n");
        printf("hashTable 2000 100\n");
        printf("Create 2000 records, hastTable=100, fill sequense numbers\n");
        printf("or 4000 200 r\n");
        printf("Create 4000 records, hastTable=200, fill random numbers\n");
        exit(0);             // Выход без ошибки
    }
    maxnum = atoi(argv[1]);
    hashTableSize = atoi(argv[2]);
    random = argc > 3;
    if ((a = (int*)malloc(maxnum * sizeof(*a))) == 0)
    {
        fprintf(stderr, "out of memory (a)\n");
        exit(1);
    }
    if ((hashTable = (Node**)calloc(hashTableSize , sizeof(Node *))) == 0)
    {
        fprintf(stderr, "out of memory (hashTable)\n");
        exit(1);
    }
    if (random)
    { /* random */
// Заполняем «a» случайными числами
        for (i = 0; i < maxnum; i++)
            a[i] = rand()%100;
        printf("ran ht, %d items, %d hashTable\n", maxnum, hashTableSize);
    }
    else
    {                         // Заполняем последовательными данными
        for (i = 0; i<maxnum; i++)
            a[i] = i;
        printf("seq ht, %d items, %d hashTable\n", maxnum, hashTableSize);
    }
    for (i = 0; i < maxnum; i++)
        insertNode(a[i]);

    printTable(hashTableSize);
    for (i = maxnum - 1; i >= 0; i--)
        findNode(a[i]);

    for (i = maxnum - 1; i >= 0; i--)
        deleteNode(a[i]);

    getchar();

return 0;
}

