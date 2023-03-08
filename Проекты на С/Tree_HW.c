#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
FILE *file;

int hash(char *arr)
{
    int d = 0, i = 0;

     while (arr[i]) {
        d += (int)arr[i];
        i++;
    }
    return d;
}

typedef struct SNode {

    int data;
    struct SNode *left;
    struct SNode *right;
    struct SNode *parent;

} SNode;

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
SNode* getFreeNode(int value, SNode *parent) {

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

//Обход дерева КЛП
void preOrderTravers(SNode* root) {

    if (root) {

        printf("%d ", root->data);
        preOrderTravers(root->left);
        preOrderTravers(root->right);

    }

}
//Обход дерева ЛКП
void inOrderTravers(SNode* root) {

    if (root) {

        inOrderTravers(root->left);
        printf("%d ", root->data);
        inOrderTravers(root->right);

    }

}
//Обход дерева ЛПК
void postOrderTravers(SNode* root) {

    if (root) {

        postOrderTravers(root->left);
        postOrderTravers(root->right);
        printf("%d ", root->data);

    }

}

SNode *treeSearch(SNode *Tree, int data)
{

    if (Tree == NULL)
        return NULL;
    if (Tree->data == data)
            return Tree;
    if (Tree->data > data)
            return treeSearch(Tree->left, data);
    if (Tree->data < data)
            return treeSearch(Tree->right, data);

}

int main(int argc, char *argv[]) {
//1. Реализовать простейшую хэш-функцию. На вход функции подается строка, на выходе получается сумма кодов символов.
    char arr[256] = "attention";
    printf("Входная строка: %s\nХэш код: %d", arr, hash(arr));
    puts("");

//2. Переписать программу, реализующее двоичное дерево поиска:
    //Добавить в него обход дерева различными способами.
    //Реализовать поиск в нём.
    //*Добавить в программу обработку командной строки с помощью которой можно указывать,
    //из какого файла считывать данные, каким образом обходить дерево.
    if (argc < 2)
    {
        puts("Аргументы: Файл обход");
        return 1;
    }
    puts("Дерево поиска:");
    SNode *Tree = NULL;
    file = fopen(argv[1], "r");
    if (file == NULL) {
        puts("Can't open file!");
        return 1;
    }
    int i, cnt = 0, count = 0;
    while(fscanf(file, "%d", &count) !=EOF)
        cnt++;              //Считываем количество записей
    fclose(file);
    file = fopen(argv[1], "r");
    for(i = 0; i < cnt; i++) {
        int value = 0;
        fscanf(file, "%d", &value);
        insert(&Tree, value);
    }
    fclose(file);
    printTree(Tree);
    switch (atoi(argv[2])) {

    case 1:
        printf("\nКЛП: ");
        preOrderTravers(Tree);
        break;
    case 2:
        printf("\nЛКП: ");
        inOrderTravers(Tree);
        break;
    case 3:
        printf("\nЛПК: ");
        postOrderTravers(Tree);
        break;
    default:
        exit(2);
    }
    puts(" ");
    SNode *t;
    puts("Поиск числа 654");
    t = treeSearch(Tree, 3);
    if (t == NULL) {
        puts("Значение не найдено");
    } else {
        printf("Значение %d", t->data);
    }

return 0;
}
