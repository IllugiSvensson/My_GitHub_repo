#include <iostream>
using namespace std;

//1. Реализовать шаблон класса Pair1, который позволяет пользователю
//передавать данные одного типа парами.
//Следующий код:
//Pair1<int> p1(6, 9);
//cout << "Pair: " << p1.first() << ' ' << p1.second() << '\n';
//const Pair1<double> p2(3.4, 7.8);
//cout << "Pair: " << p2.first() << ' ' << p2.second() << '\n';
//… должен производить результат:
//Pair: 6 9
//Pair: 3.4 7.8

template<class T>
class Pair1 {
private:

    T f;
    T s;

public:

    Pair1(T ft, T sd): f(ft), s(sd) {}

    T first() const {

        return f;

    }

    T second() const {

        return s;

    }

    ~Pair1() {}

};

//2.Реализовать класс Pair, который позволяет использовать разные
//типы данных в передаваемых парах.
//Следующий код:
//Pair<int, double> p1(6, 7.8);
//cout << "Pair: " << p1.first() << ' ' << p1.second() << '\n';
//const Pair<double, int> p2(3.4, 5);
//cout << "Pair: " << p2.first() << ' ' << p2.second() << '\n';
//… должен производить следующий результат:
//Pair: 6 7.8
//Pair: 3.4 5
//Подсказка: чтобы определить шаблон с использованием двух разных
//типов, просто разделите параметры типа шаблона запятой.
template<typename T, typename S>
class Pair {
private:

    T f;
    S s;

public:

    Pair(T ft, S sd): f(ft), s(sd) {}
    ~Pair() {}

    T first() const {

        return f;

    }

    S second() const {

        return s;

    }

};

//3. Написать шаблон класса StringValuePair, в котором первое
//значение всегда типа string, а второе — любого типа. Этот шаблон
//класса должен наследовать частично специализированный класс Pair,
//в котором первый параметр — string, а второй — любого типа данных.
//Следующий код:
//StringValuePair<int> svp("Amazing", 7);
//std::cout << "Pair: " << svp.first() << ' ' << svp.second() << '\n';
//… должен производить следующий результат:
//Pair: Amazing 7
//Подсказка: при вызове конструктора класса Pair из конструктора
//класса StringValuePair не забудьте указать, что параметры относятся
//к классу Pair.
template<typename U>
class Pair<string, U> {
private:

    string f;
    U s;

public:

    Pair(string ft, U sd): f(ft), s(sd) {}
    ~Pair() {}

    string first() const {

        return f;

    }

    U second() const {

        return s;

    }

};

template<typename T>
class StringValuePair: public Pair<string, T> {
public:

    StringValuePair(string a, T b):Pair<string, T>(a, b) {}

};


int main() {

    Pair1<int> p1(6, 9);
    cout << "Pair: " << p1.first() << ' ' << p1.second() << '\n';
    const Pair1<double> p2(3.4, 7.8);
    cout << "Pair: " << p2.first() << ' ' << p2.second() << '\n' << endl;

    Pair<int, double> p11(6, 7.8);
    cout << "Pair: " << p11.first() << ' ' << p11.second() << '\n';
    const Pair<double, int> p22(3.4, 5);
    cout << "Pair: " << p22.first() << ' ' << p22.second() << '\n' << endl;

    StringValuePair<int> svp("Amazing", 7);
    std::cout << "Pair: " << svp.first() << ' ' << svp.second() << '\n';

    return 0;
}



