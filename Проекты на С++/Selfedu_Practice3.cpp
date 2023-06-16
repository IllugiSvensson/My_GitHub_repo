#include <iostream>
#include <cmath>
#include <string.h>
using namespace std;

float sumArray()
{
    float ar[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    float sum = 0;
    int cnt = 0;
    for (int i = 0; i < 10; ++i)
    {
        sum += ar[i];
        cnt++;
    }
    return sum / cnt;
}

void riseArray()
{
    int arr[12];
    int k = 0;
    for (int i = 0, j = 1; i < 12; i += 2, j += 2)
    {
        arr[i] = k;
        arr[j] = k + 6;
        k++;
    }
    for (int i = 0; i < 12; i++)
    {
        cout << arr[i] << " ";
    }
    cout << endl;
}

void reverse()
{
    int array[5] = {1, 2, 3, 4, 5};
    int arr[5], t;
    for (int i = 4; i >= 0; i--)
        arr[4 - i] = array[i];
    for (int i = 0; i < 5; i++)
        cout << arr[i] << " ";
    for (int i = 0; i < 5 / 2; i++)
    {
        t = arr[i];
        arr[i] = arr[4 - i];
        arr[4 - i] = t;
    }
    for (int i = 0; i < 5; i++)
        cout << arr[i] << " ";
    cout << endl;
}

void multMatrix()
{
    int m1[4][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {10, 11, 12}};
    int m2[2][3] = {{1, 3, 5}, {2, 4, 6}};
    int m3[4][2] = {0};
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 3; j++)
        {
            m3[i][0] += m1[i][j] * m2[0][j];
            m3[i][1] += m1[i][j] * m2[1][j];
        }
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 2; j++)
            cout << m3[i][j] << " ";
        cout << endl;
    }
}

void sumMatrix()
{
    int m1[4][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {10, 11, 12}};
    int m2[4][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}, {1, 1, 1}};
    int m3[4][3] = {0};
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 4; j++)
        {
            m3[i][j] = m1[i][j] + m2[i][j];
        }
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 3; j++)
            cout << m3[i][j] << " ";
        cout << endl;
    }
}

void newArray()
{
    int arr[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    for (int i = 0; i < 10; i++)
        if (arr[i] == 5 || arr[i] == 2)
        {
            for (int j = i; j < 9; j++)
                arr[j] = arr[j + 1];
            arr[9] = -1;
        }
    for (int i = 0; i < 10; i++)
        cout << arr[i] << " ";
    cout << endl;
    for (int i = 0; i < 10; i++)
        if (i == 1 || i == 4)
        {
            for (int j = 9; j > i; j--)
                arr[j] = arr[j - 1];
            arr[i] = 0;
        }
    for (int i = 0; i < 10; i++)
        cout << arr[i] << " ";
    cout << endl;
}

void arraySort()
{
    int temp;
    int arr[4][7] = {{0, 4, 5, 3, 2, -1, -7}, {8, 7, 4, 10, 100, 1, -5}, {8, 7, -20, 9, -10, 1, 2}, {-7, -6, -8, -1, -2, -3, -7}};
    for (int i = 0; i < 4; i++)
        for(int j = 0; j < 7; j++)
            for(int k = j; k < 6; k++)
            {
                if (arr[i][j] > arr[i][k + 1])
                {
                    temp = arr[i][k + 1];
                    arr[i][k + 1] = arr[i][j];
                    arr[i][j] = temp;
                }
            }
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 7; j++)
            cout << arr[i][j] << " ";
        cout << endl;
    }
}

void ToUpper()
{
    char ch[] = "Hello World!";
    for (int i = 0; i < strlen(ch); i++)
        cout << (char)((islower(ch[i])) ? toupper(ch[i]): ch[i]);
    cout << endl;

}

void Compare()
{
    char ch[] = "Hello World!";
    if (stricmp(ch, "hello world!") == 0)
        cout << "Have string!" << endl;
    else cout << "Dont have string" << endl;

}

void revString()
{
    char ch[] = "i like to compile";
    char c;
    for (int i = 0; i < strlen(ch) / 2; i++)
    {
        c = ch[i];
        ch[i] = ch[strlen(ch) - i - 1];
        ch[strlen(ch) - i - 1] = c;
    }
    puts(ch);
    cout << endl;
}

void divideString()
{
    char ch[] = "i like to compile";
    for (int i = 0; i < strlen(ch); i++)
        if (ch[i] == ' ') cout << endl;
        else cout << ch[i];
    cout << endl;
}

void swapString()
{
    char ch[] = "Hello World!";
    char c;
    int N = strlen(ch);
    for (int i = 0; i < N / 2; i++)
    {
        c = ch[N / 2 + i];
        ch[N / 2 + i] = ch[i];
        ch[i] = c;
    }
    for (int i = 0; i < N; i++)
        cout << ch[i];
    cout << endl;
}

void minArray()
{
    int a[5], i = 0;
    int min;
    cin >> a[0];
    min = a[i];
    do
    {
        i++;
        cin >> a[i];
        if (a[i] < min) min = a[i];
    } while (i < 4);
    cout << min << endl;
}

void checkmate()
{
    char chm[8][8] = {' '};
    for (int i = 0; i < 8; i++)
        for(int j = 0; j < 8; j++)
            if (i % 2 == 0 && j % 2 == 0) chm[i][j] = '*';
            else if (i % 2 != 0 && j % 2 != 0) chm[i][j] = '*';
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
            cout << chm[i][j] << " ";
        cout << endl;
    }
}

int main()
{
    //Задание 1. Вычислить сумму элементов массива
    cout << "Среднее: " << sumArray() << endl;
    cout << "Сумма элементов: " << sumArray() * 10 << endl;
    //Задание 3. Заполнить массив двумя циклами
    cout << "Элементы: ";
    riseArray();
    //Задание 4. Скопировать массив в реверсивном порядке
    cout << "Элементы: ";
    reverse();
    //Задание 6. Перемножить две матрицы
    cout << "Перемножение: " << endl;
    multMatrix();
    //Задание 7. Сложить матрицы
    cout << "Сложение: " << endl;
    sumMatrix();
    //Задание 8. Удалить элементы из массива и вставить нули
    cout << "Массив без элементов: " << endl;
    newArray();
    //Задание 10. Отсортировать элементы матрицы
    cout << "Сортировка: " << endl;
    arraySort();
    //Задание 11. Перевести строку в верхний регистр
    cout << "Регистр: " << endl;
    ToUpper();
    //Задание 12. Найти подстроку в строке
    Compare();
    //Задание 13. Реверсировать строку
    cout << "Реверс строки: ";
    revString();
    //Задание 14. Разделить строку на отдельные слова
    cout << "Разбитая строка: " << endl;
    divideString();
    //Задание 17. Свапнуть половины строки друг с другом
    cout << "Перевернутая строка: " << endl;
    swapString();
    //Задание 19. Найти минимальное из введенных значений в массив
    cout << "Минимальное: " << endl;
    minArray();
    //Задание 21. Составить шахматную доску
    checkmate();
    return 0;
}
