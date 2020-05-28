#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>

typedef int T;
typedef int hashTableIndex;     //Индекс в хэш-таблице
#define compEQ(a, b) (a == b)   //Определим директиву сравнения двух значений
FILE *file;

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
void insert(SNode **head, int value) {

    SNode *tmp = NULL;

        if (*head == NULL) {

            *head = getFreeNode(value, NULL);
            return;

        }

    tmp = *head;

        while (tmp) {

            if (value > tmp->data) {

                if (tmp->right) {

                    tmp = tmp->right;
                    continue;

                } else {

                    tmp->right = getFreeNode(value, tmp);
                    return;

                }

            } else if (value < tmp->data) {

                if (tmp->left) {

                    tmp = tmp->left;
                    continue;

                } else {

                    tmp->left = getFreeNode(value, tmp);
                    return;

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

int main() {

//Построение идеально сбалансированного дерева
    SNode* tree = NULL;
    file = fopen("/home/woljin1/Projects/file", "r");

        if (file == NULL) {

            puts("Can't open file!");
            return 1;
        }

    int count, cnt = 0;

        while(fscanf(file, "%d", &count) !=EOF)
            cnt++;              //Считываем количество записей

    fclose(file);
    file = fopen("/home/woljin1/Projects/file", "r");

        tree = BTree(cnt);           //Строим дерево

    fclose(file);
    printTree(tree);            //Печатаем скобочную запись
    puts(" ");

//Построение дерева поиска
    SNode *Tree = NULL;
    file = fopen("/home/woljin1/Projects/file", "r");

    int i;

        for(i = 0; i < cnt; i++) {

            int value;
            fscanf(file, "%d", &value);
            insert(&Tree, value);

        }

    fclose(file);
    printTree(Tree);
    printf("\nPreOrderTravers:");
    preOrderTravers(Tree);
    puts(" ");

return 0;
}

