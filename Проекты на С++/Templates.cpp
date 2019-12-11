#include <iostream>
using namespace std;

template <typename T>   //Шаблон функции
const T &Max(const T &a, const T &b) {

    return (a > b) ? a : b;

}

template <class T>  //Шаблон класса
class Day {
private:

    T day;

public:

    Day(T d) {

        day = d;

    }

    ~Day() {

    }

    T getDay();
    //Перегрузка оператора сравнения, чтобы пользоваться шаблоном функции
    friend bool operator> (const Day &d1, const Day &d2) {

        return (d1.day > d2.day);

    }

    void print() {

        cout << day << endl;

    }

};
// метод, определенный вне тела класса, нуждается в собственном определении шаблона метода
template <class T>
T Day<T>::getDay() {

    return day;

}

template <>     //Явная специализация шаблона функции
void Day<double>::print() {

    cout << day + 2 << endl;

}

template <class T>  //Специализация шаблона класса для указателей
class Day<T*> {
private:

    T *day;

public:

    Day(T *d) {

        day = new T(*d);    //Копируем одно отдельное значение

    }

    ~Day() {

        delete day; //Удаляется копированное значение

    }

    void print() {

        cout << *day << endl;

    }

};
template <> //Явная специализация шаблона класса (Особый конструктор)
Day<char*>::Day(char *d) {
    // Определяем длину day
    int length = 0;

    while (d[length] != '\0')
        ++length;
    ++length; // +1, учитывая нуль-терминатор

    // Выделяем память для хранения значения d
    day = new char[length];

    // Копируем фактическое значение d в day
    for (int count = 0; count < length; ++count)
        day[count] = d[count];

}
template <> //Нужен специальный деструктор под тип char*
Day<char*>::~Day() {

    delete[] day;

}
//Специализация метода print под тип char
//Она нужна, чтобы при таком типе не срабатывал вызов Day<T*>::print()
template<>
void Day<char*>::print() {

    cout << day;

}

template <class T>
class Repo {
private:

    T arr[8];

public:

    void set(int index, const T &value) {

        arr[index] = value;

    }

    const T &get(int index) {

        return arr[index];

    }

};
template <> //Специализация под тип bool
class Repo<bool> {
private:
    //Переменные удобнее хранить не в массиве(8 байт)
    unsigned char data; //В таком типе будет выделяться по биту на каждое bool значение

public:

    void set(int index, bool value) {
        //Выбираем оперируемый бит
        unsigned char mask = 1 << index;

            if(value) data |= mask; //включаем бит побитовым ИЛИ
            else data &= ~mask; //Выключаем бит побитовым И

    }

    bool get(int index) {

        //Выбираем бит
        unsigned char mask = 1 << index;
        //Используем побитовое И для получения бита и преобразования в bool
        return (data & mask) != 0;

    }

};

template <class T, int size> // size является параметром non-type шаблона класса
class StaticArray {
private:
    // параметр non-type шаблона класса отвечает за размер выделяемого массива
    T array[size];  //Такой параметр заменяется не типом, а значением

public:

    void Insert(int index, T value) {

        array[index] = value;

    }

    T getValue(int index) {

        return array[index];

    }

};

template <class T, int size> //Создаем наследника, чтобы не дублировать код
class STar: public StaticArray<T, size> {
//Наследуем полный функционал базового класса
};
template <int size> //Частичная специализация шаблона для double
class STar<double, size>: public StaticArray<double, size> {
public:

    void getMessage() {

        cout << "It's double!" << endl;

    }

};

int main() {

    cout << "int: " << Max(4,8) << endl;
    cout << "double: " << Max(7.56, 21.434) << endl;
    cout << "ch: " << Max('b', '9') << endl;
    Day<int> seven(7);
    Day<int> twelve(12);
    Day<int> M = Max(seven, twelve);
    cout << "Max: " << M.getDay() << endl;
    Day<double> dbl(8.4);           //Сработает специализация шаблона
    dbl.print(); cout << endl << endl;

    Day<int> myDay(12);
    cout << "My Day: "; myDay.print();
    int x = 8;
    Day<int*> myptr(&x);
    cout << "My ptr: "; myptr.print();

    char *string = new char[40];    //Присваиваем указатель переменной
    cout << "Enter your name: ";    //При выводе получаем сам указатель
    cin >> string;                  //а не его значение.
    Day<char*> day(string);         //Нужна специализация для указателей
    delete[] string;
    day.print(); cout << endl << endl;

    StaticArray<double, 5> StAr;
    for(int i = 0; i < 5; ++i) {

        StAr.Insert(i, i * 3.3 / 2);
        cout << StAr.getValue(i) << " ";

    }
    cout << endl;
    STar<double, 5> star;
    star.getMessage();

return 0;
}
