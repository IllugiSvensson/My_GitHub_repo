#include <iostream>
#include <cmath>
#include <time.h>
using namespace std;
#define PI 3.1415
#define CQ(R) PI* R * R
#define SIZE 4
#define VP(a, b, c) a * b * c

float Area(float a, float b)
{
    return 2 * (a + b);
}

float Square(int a, int b)
{
    return 0.5 * a * b;
}

int sumRange()
{
    int sum = 0;
    for (int i = 1; i <= 6; ++i)
    {
        sum += i;
    }
    return sum;
}

float Hipo(float a, float b)
{
    return sqrt(a * a + b * b);
}

void Random()
{
    srand(time(NULL));
    for (int i = 0; i < 5; ++i)
        cout << rand() % 6 << " ";
    cout << endl;
    for (int i = 0; i < 5; ++i)
        cout << (rand() % 4) + 4 << " ";
}

float Percent(int a)
{
     return a * 0.16;
}

int Factor()
{
    int res = 1;
    for (int i = 1; i <= 6; ++i)
        res *= i;
    return res;
}

void Swap(float a, float b)
{
    float temp = b;
    b = a;
    a = temp;
    cout << a << " " << b;
}

float Cos(float a)
{
    return cos(a / 180.0 * PI);
}

float Path(float a, float b)
{
    float x = a + 2, y = b - 11;
    return sqrt((x - a) * (x - a) + (y - b) * (y - b));
}

void Roots(float a, float b)
{
    if (a == 0) cout << "inf" << endl;
    else cout << "Корень: " << b / a << endl;
}

int mRange()
{
    int sum = 5;
    for (int i = 8; i <= 20; i += 3)
        sum *= i;
    return sum;
}

int main()
{
    //Задание 1. Найти периметр прямоугольника, введенный с клавиатуры через пробел
    float a, b;
    cout << "Введите два числа через пробел: ";
    cin >> a >> b;
    cout << "Периметр: " << Area(a, b) << endl;
    //Задание 2. Найти площать треугольника из целочисленных значений
    cout << "Площать: " << Square((int)a, (int)b) << endl;
    //Задание 3. Вычислить площадь круга, используя макрос функции
    cout << "Площадь круга: " << CQ(a) << endl;
    //Задание 4. Вычислить сумму диапазона [1..6]
    cout << "Сумма диапазона: " << sumRange() << endl;
    //Задание 5. Найти гипотенузу треугольника с известными катетами
    cout << "Гипотенуза: " << Hipo(a, b) << endl;
    //Задание 6. Сгенерировать 6 случайных чисел и вывести на экран
    cout << "Случайные значения: " << endl;
    Random();
    cout << endl;
    //Задание 8. Вычислить объем n-угольной пирамиды, используя условную компиляцию
    #if (SIZE == 3)
        cout << "Объем 3-угольной пирамиды: " << b * (0.5 * a * b) / 3.0 << endl;
    #elif (SIZE == 4)
        cout << "Объем 4-угольной пирамиды: " << (b * a * b) / 3.0 << endl;
    #endif
    //Задание 9. Вычислить 15% от 13800 или любого другого.
    cout << "Проценты: " << Percent((int)a) << endl;
    //Задание 11. Вычислить факториал 6 умножением и индукцией
    cout << "Факториал: " << Factor() << endl;
    //Задание 12. Сделать свап двух переменных
    cout << "Свап переменных: " << a << " " << b << " | ";
    Swap(a, b);
    cout << endl;
    //Задание 13. Вычислить косинус угла
    cout << "Косинус: " << Cos(a) << endl;
    //Задание 14. Вычислить кратчайшее расстояние между точками
    cout << "Расстояние: " << Path(a, b) << endl;
    //Задание 15. Вычислить либо площадь, либо длину окружности в завиимости от константы
    #ifdef SQ
    cout << "Площадь: " << CQ(a) << end;;
    #else
    cout << "Длина: " << CQ(a) / a << endl;
    #endif
    //Задание 16. Вычислить модуль числа
    float c = -a;
    cout << "Модуль: " << sqrt(c * c) << endl;
    //Задание 17. Найти корни уровнения первого порядка
    Roots(a, b);
    //Задание 18. Вычислить объем параллелипипеда используя макрос
    cout << "Объем: " << VP(a, b, sqrt(c * c)) << endl;
    //Задание 19. Вычислить синус угла через косинус
    cout << "Синус: " << sqrt(1 - Cos(a) * Cos(a)) << endl;
    //Задание 20. Вычислить произведение диапазона с шагом 3
    cout << "Произведение: " << mRange() << endl;
    return 0;
}
