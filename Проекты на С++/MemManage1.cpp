#include <iostream>
using namespace std;
float (*action)(float z, float x);

void ChangeData(int a) //Копирование значения
{
    a = 10;
}

void ChangeLink(int& a) //Передача по ссылке
{
    a = 10;
}
void ChangePointer(int* a) //Передача указателя
{
    *a = 15;
}

int* getPtr()   //Возвращение указателя во внешнюю программу
{
    int a = 9;
    return &a;  //Надо следить за такими возвратами. Опасно!
}

void PrintArray(int* array, int len)
{
    for (int i = 0; i < len; i++)
    {
        cout << array[i] << endl;
    }
}

int* CreateArray(int c)
{
    return new int[c];
}

float add (float a, float b)
{
    return a + b;
}

float substract(float a, float b)
{
    return a - b;
}

void Register(float(*act)(float, float))
{
    action = act;
}
int main(int argc, char** args) {

    int a = 5;
    int* b = &a;
    int& c = a;
    cout << "a = " << a << endl
         << "b = " << b << endl
         << "c = " << c << endl;

    int arr[5] = {1, 2, 3, 4, 5};
    PrintArray(arr, 5);

    int* arr2[5];
    for (int i = 0; i < 5; i++)
    {
        arr2[i] = arr;
    }
    for(int i = 0; i < 5; i++)
    {
        for(int j = 0; j < 5; j++)
            cout << *(arr2[i] + j) << " ";
        cout << endl;
    }

    int* ar = CreateArray(5);
    for(int i = 0; i < 0; i++)
    {
        cout << ar[i] << endl;
    }
    cout << ar << endl;
    delete[] ar;

    float* d = new float;
    *d = 2.5;
    cout << d << " " << *d << endl;
    delete d;

    for(int i = 0; i < argc; i++)
    {
        int t = 0;
        while (*(args[i] + t) != 0x00)
        {
            cout <<*(args[i] + t) << " ";
            t++;
        }
        cout << endl;
    }


    float z = 3.14;
    float x = 2;
    if (argc > 1) Register(substract);
    else Register(add);
    cout << action(z, x) << endl;

return 0;
}
