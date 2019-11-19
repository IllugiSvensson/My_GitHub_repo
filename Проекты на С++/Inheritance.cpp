#include <iostream>
#include <string>
using namespace std;
//Класс с константными методами и объектами
class Date {
private:

    int m_day;
    int m_month;
    int m_year;

public:

    Date(int day, int month, int year);
    void setDate(int day, int month, int year);

    //Константные методы гарантируют, что объект не будет изменяться
    int getDay() const { return m_day; }
    int getMonth() const { return m_month; }
    int getYear() const { return m_year; }

};

// Конструктор класса Date
Date::Date(int day, int month, int year) {

    setDate(day, month, year);

}

// Метод класса Date
void Date::setDate(int day, int month, int year) {

    m_day = day;
    m_month = month;
    m_year = year;

}

//Объект передается по константной ссылке, копия объекта не создается
void printDate(const Date &date) {

    cout << date.getDay() << "."
        << date.getMonth() << "."
        << date.getYear() << endl;

}

//Класс со статическими переменными и указателем this
class Bar {
private:
    //Статическая переменная будет общей для всех объектов класса
    static int number;
    int value;
    int value2;

public:

    Bar() { number++; }
    Bar(int value, int value2) {
        //Явно укажем на какие переменные объекта ссылаться
        this -> value = value;
        this -> value2 = value2;
        number++;
        cout << endl << "Constructor Bar" << endl;
        cout << value << "-" << value2 << endl;

    }

    Bar(Bar &b) {
        //Конструктор копирования, указываем что копировать и куда
        this -> value = b.value;
        this -> value2 = b.value2;
        number++;
        cout << "Constructor Bar copy" << endl;

    }

    ~Bar() {

        number--;
        cout << "Destructor Bar" << endl;

    }
    //Только статический метод может возвращать статическую переменную
    //когда не создан объект класса
    static int getNumber() { return number; }

    int getValue() const { return value; }
    //Метод возвращает сам объект, что позволяет создавать цепочки методов
    Bar &setValue(int x) { value = x; return *this; }
    int getValue2() const { return value2; }
    Bar &setValue2(int x) { value2 = x; return *this; }

};

int Bar::number = 0;

//Класс с наследованием и дружественными классами
class Animal {
protected:

    string name;
    int age;

public:

    Animal(string n, int a) { name = n; age = a; }

    string getName() const { return name; }
    int getAge() const { return age; }

    void setAge(int a) {

        age = a;

    }

};

class Pet : public Animal {
protected:

    string owner;

public:
          //Вызываем конструктор родительского класса
    Pet(string o, string n, int a) : Animal(n, a) { owner = o; }

    string getOwner() const { return owner; }
    friend void resetAge(Pet &pet);

};
//Дружественная функция получает доступ к закрытым членам класса
void resetAge(Pet &pet) {

    pet.age = 0;

}

class Cat : public Pet {
private:

    string breed;

public:

    Cat(string n, string o, string b, int a): Pet(n, o, a),
        breed(b) {

    }

    friend class Dog;

};

class Dog: public Pet {
private:

    string breed;

public:

    Dog(string n, string o, string b, int a): Pet(n, o, a),
        breed(b) {

    }

    friend class Cat;
    //Классы Cat и Dog друзья и имеют доступ к закрытым членам
    bool compareAge(Cat &cat, Dog &dog) {

        return dog.age < cat.age;

    }

};

int main() {

    Date date(12, 11, 2018);
    printDate(date);

    Bar bar(10, 20);
    Bar bar2(bar);
    cout << bar2.getValue() << "-" << bar2.getValue2() << endl;
    //bar.setValue устанавливает значение и возвращает bar для
    //дальнейшей цепочки
    bar.setValue(15).setValue2(25);
    cout << bar.getValue() << "-" << bar.getValue2() << endl;
    cout << Bar::getNumber() << endl << endl;

    Pet pet("Mike", "Tom", 5);
    cout << "Owner: " << pet.getOwner() << endl << "Name: " << pet.getName()
         << endl << "Age: " << pet.getAge() << endl;
    resetAge(pet);
    cout << pet.getAge() << endl << endl;
    Cat cat("Mike", "Tom", "Persian", 5);
    Dog dog("John", "Spike", "Mops", 4);

        (dog.compareAge(cat, dog)) ? (cout << "Cat is older" << endl):
                                     (cout << "Dog is older" << endl);

    //Указатель на базовый класс может указывать и на дочерний
    //но доступа к специфичным членам дочернего класса все равно нет
    Animal *p;      //Указатель типа базового класса
    Animal animal("somepet", 4);
    p = &animal;    //Указывает на объект базового класса
    p -> setAge(6);
    cout << animal.getAge() << endl;
    p = &pet;       //Указывает на объект дочернего класса
    p -> setAge(10);
    cout << pet.getAge() << endl << endl;

return 0;
}
