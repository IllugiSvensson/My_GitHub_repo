#include <iostream>
#include <cmath>
using namespace std;

void Hit(float a, float b)
{
    float x0 = 1, x1 = 5;
    float y0 = -3, y1 = 9;
    if (a >= x0 && a <= x1 && b >= y0 && b <= y1)
        cout << "Hit!" << endl;
    else cout <<"Not Hit" << endl;

}

void otherHit(float a, float b)
{
    float x0 = 1, x1 = 5;
    float y0 = -3, y1 = 9;
    if ((a <= x0 || a >= x1) && b >= y0 && b <= y1)
        cout << "Hit!" << endl;
    else cout <<"Not Hit" << endl;

}

int Froggy()
{
    int path[6] = {0};
    for (int i = 0; i < 6; ++i)
    {
        if (i == 0) path[i] = 1;
        else if (i == 1) path[i] = 2;
        else path[i] = path[i - 1] + path[i - 2];
    }
    return path[5];
}

void Progress(float a0, float b, float stop)
{
    float Sn = a0;
    float sign = (b > 0) ? 1 : -1;
    cout << "Sum: ";
    while(Sn * sign < stop * sign && b != 0)
    {
        a0 += b;
        Sn += a0;
        cout << Sn << " ";
    }
    cout << endl;
}

void Check(float x)
{
    if ((int)x % 2 == 0) cout << "Четное!" << endl;
    else cout << "Не четное" << endl;
}

void checkM(float z)
{
    int i = 2;
    cout << "Множители: ";
    while(z != 1)
    {
        if ((int)z % i == 0)
        {
            cout << i << " ";
            z /= i;
            break;
        }
        else i++;
    }
    cout << endl;
}

void DivideN(float n)
{
    cout << "Разбиение: ";
    while(n > 1){
        if (((int)n % 10) % 2 == 0)
            cout << (int)n % 10 << ", ";
        n /= 10;
    }

}

void CheckR()
{
    float x;
    int n = 0;
    float sum = 0;
    bool any = false;
    do {
        cin >> x;
        any = any || (x < 0);
        n++;
        if ((int)x % 2 == 0 && x > 0) sum += x;
    } while (n < 3);
    if (any) cout << "Есть отрицательные" << endl;
}

void checkmax()
{
    float x;
    cin >> x;
    float max = x;
    float min = x;
    int n = 0;
    do {
        cin >> x;
        if (x > max) max = x;
        if (x < min) min = x;
        n++;
    } while(n >= 3);

    cout << "Максимум: " << max << endl;
    cout << "Минимум: " << min << endl;
}

void Fir(float x)
{
    for (int i = x; i > 0; i--)
    {
        for(int j = 1; j <= x - i + 1; j++)
            cout << "* ";
        cout << endl;
    }
    for (int i = 0; i < x; ++i)
    {
        for(int j = x - i; j > 0; j--)
            cout << "* ";
        cout << endl;
    }
}

void ToUpper()
{
    char c;
    int n = 0;
    do {
        cin >> c;
        switch(c)
        {
        case 'a':
            cout << (char)toupper('a') << endl; break;
        case 'd':
            cout << (char)toupper('d') << endl; break;
        case 'e':
            cout << (char)toupper('e') << endl; break;
        case 'z':
            cout << (char)toupper('z') << endl; break;
        case 'w':
            cout << (char)toupper('w') << endl; break;
        default:
            cout << c << " "; break;
        }
        n++;
    } while (n < 5);
}

float sumRow()
{
    float sum = 0;
    for (int i = -5; i <= 10; i++)
    {
        if (i == 0) continue;
        sum += 1.0 / i;
    }
    return sum;
}

int Factor(int x)
{
    int factor = 1;
    for (int i = 1; i <= x; ++i)
        factor *= i;
    return factor;

}
int main()
{
    //Задание 1. Вычислить модуль числа
    float x, y, z;
    cin >> x >> y >> z;
    cout << "Модуль: " << ((x > 0) ? x : x) << endl;
    //Задание 2. Проверить попадание точки в прямоугольник
    Hit(x, y);
    //Задание 3. Проверить попадание точки в закрашенную область
    otherHit(x, y);
    //Задание 4. Найти количество маршрутов лягушки
    cout << "Число маршрутов: " << Froggy() << endl;
    //Задание 5. Реализовать арифметическую прогрессию
    Progress(x, y, z);
    //Задание 7. Проверка на четность
    Check(x);
    //Задание 8. Найти все простые множители целого числа
    checkM(z);
    //Задание 9. Разбить число на цифры
    DivideN(y);
    cout << endl;
    //Задание 10. Найти из введеных чисел отрицательные
    //CheckR();
    //Задание 13. Найти максимальное из введенных чисел
    cout << "Числа: " << endl;
    //checkmax();
    //Задание 15. Вывести ёлочку из звуздочек в консоль
    Fir(x);
    //Задание 18. Заменить на верхний регистр
    cout << "Верхний регистр: " << endl;
    ToUpper();
    cout << endl;
    //Задание 21. Вычислить сумму ряда
    cout << "Сумма: " << sumRow() << endl;
    //Задание 22. Вычислить факториал
    cout << "Факториал: " << Factor((int)x) << endl;
    return 0;
}
