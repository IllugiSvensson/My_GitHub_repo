#include <iostream>
#define MORE(a, b) ( ((a) > (b)) ? 1: 0)
//#include "prog.h"
//inline int add(int a, int b) {return a + b;}
using namespace std;
//Хранение состояний
struct arg_pair
{
    int a;
    int b;
};

//Подстановка имен типов
typedef int (*func)(arg_pair);
int add(arg_pair arg)
{
    return arg.a + arg.b;
}

//Изменяемость данных
//void func1(const int* a) Данные - константа
//void func1(int* const a) Константа - указатель на эти данные
void func1(const int* a)
{
    cout << "Argument: " << *a << endl;
    //*a = 2; Нельзя изменять константы
    int * p = const_cast<int*>(a); //Снимаем запрет на изменение
}

//Составить и проверить в действии функцию, составляющую 32-разрядное
//беззнаковое целое значение uint32_t из четырех байт данных.
//Обращаться со значением нужно при этом как с простым массивом
//из 4 элементов типа unsigned char. При этом:
//Использовать указатели;
//Применить операции приведения типов данных;
//Заполненное 32-разрядное значение должно быть возвращено из функции.
uint32_t fillBytes(unsigned char array[4])
{
    uint32_t res;
    void* p = static_cast<void*>(&res); //Промежуточная переменная для обхода защиты приобразования указателей
    unsigned char* p_ar = static_cast<unsigned char*>(p);
    for (int i = 0; i < 4; i++)
        p_ar[i] = array[i];
    return res;
}


void DETECTED_OS()
{
#ifdef __WIN64
    cout << "Windows" << endl;
#else
    cout << "LINUX" << endl;
#endif
cout << "Date: " << __DATE__ << endl;
cout << "Time: " << __TIME__ << endl;
}


int main()
{
    func ac;
    ac = add;
    arg_pair arg = {4, 5};
    cout << ac(arg) << endl;

    //Приведение в стиле Си
    int a = 5;
    float b = (float)a;

    //Приведение в стиле Си++
    int c = 12500;
    short j = static_cast<short>(c);
    cout << b << " " << j << endl;
    //Хитрость с приведением указателя. Сначала приводим к void
    void* d = static_cast<void*>(&d);
    short* s = static_cast<short*>(d); //Без приведения к void будет ошибка

    func1(&a);
    cout << a << endl;

    uint32_t v = 1;
    unsigned char ar[4] = {1, 2, 3, 4};
    cout << v << endl;
    v = fillBytes(ar);
    //cout << v << endl;

    uint32_t mask = 0xFF;
    for (int i = 0; i < 32; i += 8)
        cout << ((v & (mask << i)) >> i) << endl;

    //Команды препроцессора, константы
    cout << __FILE__ << __LINE__ << endl;
    cout << MORE(4, 7) << endl;

//Составить программу, выводящую на экран текущую среду сборки (Windows/Linux),
//дату и время последней успешной сборки. Использовать константу TIME для вывода времени.
    DETECTED_OS();

return 0;
}
