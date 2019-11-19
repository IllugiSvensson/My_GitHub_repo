#include <iostream>
#include <string>
using namespace std;

//Создать класс Person (человек) с полями: имя, возраст, пол и вес.
//Определить методы переназначения имени, изменения возраста и веса.
//Создать производный класс Student (студент), имеющий поле года обучения.
//Определить методы переназначения и увеличения этого значения.
class Person {
private:

    string m_name;
    int m_age;
    string m_gender;
    int m_weight;

public:

    Person(string n = "Person", int a = 17, string g = "male", int w = 70)
        : m_name(n), m_age(a), m_gender(g), m_weight(w) {

    }

    string getName() const { return m_name; }
    int getAge() const { return m_age; }
    string getGender() const { return m_gender; }
    int getWeight() const { return m_weight; }

    void setName(string n) {

        m_name = n;

    }

    void setAge(int a) {

        m_age = a;

    }

    void setGender(string g) {

        m_gender = g;

    }

    void setWeight(int w) {

        m_weight = w;

    }

};

class Student: public Person {
private:

    int m_year;

public:

    Student(string n, int a, string g, int w, int y = 2000)
        : Person(n, a, g, w), m_year(y) {

    }

    int getYear() const { return m_year; }

    void setYear(int y) {

        m_year = y;

    }

    void increaseYear() {

        m_year ++;

    }

};

//Создать классы Apple (яблоко) и Banana (банан), которые наследуют
//класс Fruit (фрукт). У Fruit есть две переменные-члена: name (имя)
//и color (цвет). Добавить новый класс GrannySmith, который наследует класс Apple.
class Fruit {
protected:

    string m_name;
    string m_color;

public:

    Fruit(string n = "somename", string c = "somecolor"): m_color(c), m_name(n) {

    }

    string getName() const { return m_name; }
    string getColor() const { return m_color; }

};

class Apple: public Fruit {
public:

    Apple(string c = "red", string n = "apple"): Fruit(n, c) {

    }

};

class Banana: public Fruit {
public:

    Banana(string n = "banana", string c = "yellow"): Fruit(n, c) {

    }

};

class GrannySmith: public Apple {
public:

    GrannySmith(string n = "Granny Smith", string c = "green"): Apple(c, n) {

    }

};

//Создать базовый класс Array (массив), в котором определить поле-массив
//подходящего типа. Максимально возможный размер массива задается статической
//константой. Создать конструктор инициализации, задающий количество элементов
//и начальное значение (по умолчанию — 0). Затем создать производный класс Money
//(деньги), который используется для представления суммы денег. У класса есть поле:
//номинал купюры, представленный как перечислимый тип данных nominal.
//Элемент массива с меньшим индексом содержит меньший номинал.
class Array {
protected:

    static const unsigned int N = 5;
    int a[N];

public:

    Array() {

        for(int i = 0; i < N; i++) {

            a[i] = 0;

        }

    }

};

class Money: public Array {
private:

    enum nominal {

        one = 1,
        five = 5,
        ten = 10,
        fifty = 50,
        oneHundred = 100

    };

public:

    Money() {

        a[0] = one;
        a[1] = five;
        a[2] = ten;
        a[3] = fifty;
        a[4] = oneHundred;

    }

    int getSum(int q, int w, int e, int r, int t) {

        return (a[0] * q) + (a[1] * w) + (a[2] * e) + (a[3] * r) + (a[4] * t);

    }

};

int main(int argc, char *argv[]) {

    Person person;
    cout << person.getName() << " " << person.getGender()
         << " " << person.getAge() << " " << person.getWeight() << endl;

    person.setName("Anna");
    person.setGender("female");
    person.setAge(21);
    person.setWeight(55);

    cout << person.getName() << " " << person.getGender()
         << " " << person.getAge() << " " << person.getWeight() << endl << endl;

    Student student("Tom", 19, "male", 68, 2015);

    cout << student.getName() << " " << student.getGender() << " " << student.getAge()
         << " " << student.getWeight() << " " << student.getYear() << endl;

    student.setYear(2019);
    cout << student.getYear() << endl;
    student.increaseYear();
    cout << student.getYear() << endl << endl;

    Apple a("red");
    Banana b;
    GrannySmith c;
    cout << "My " << a.getName() << " is " << a.getColor() << endl;
    cout << "My " << b.getName() << " is " << b.getColor() << endl;
    cout << "My " << c.getName() << " is " << c.getColor() << endl;

    Money money;
    cout << endl << "Cash: " << money.getSum(0, 1, 2, 3, 4) << endl;

return 0;
}
