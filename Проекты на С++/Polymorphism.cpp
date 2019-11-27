#include <iostream>
#include <string>
using namespace std;

//Классы с указателями и ссылками, наследования, виртуальность
class Animal {
protected:

    int age;
    string name;

public:

    Animal(int a, string n): age(a), name(n) {

    }

//    int getAge() const {
//        return age;
//    }
    //Виртуальная функция позволяет переопределить похожие методы в дочерних классах
    virtual int getAge() const {

        return age;

    }

    virtual ~Animal() {     //Виртуальный деструктор сначала вызывает деструкторы
                        //производных классов
        cout << "Dest ~Animal" << endl;

    }

};

class Pet : public Animal {
private:

    string owner;

public:

    Pet(int a, string n, string o): Animal(a, n), owner(o) {

    }

    int getAge() const {

        return age / 2;

    }

    string getOwner() const {

        return owner;
    }

    ~Pet() {

        cout << "Dest ~Pet" << endl;

    }

};

void writeAge(Animal &somePet) {

    cout << "Animal's age: " << somePet.getAge() << endl;

}

//Классы с абстракцией, связывание, множественное наследование
class Animals { //Абстрактный класс. Нельзя создать объект.
public:

    virtual void say()=0;   //Реализация будет в дочерних классах

};

class Cat: virtual public Animals {
public:

    void say() {

        cout << "Meow!" << endl;

    }

};

class Dog: virtual public Animals {
public:

    void say() {

        cout << "Woof!" << endl;

    }

};

class Cartoon: public Cat, public Dog { //Проблема множественного наследования
public:                  //решается виртуальным базовым классом (virtual public ..)

    void say() {

        cout << "Hello!" << endl;

    }

};

int add(int a, int b) { //Раннее и позднее связывание

    return a + b;

}

//Перегрузка операторов
class Dollars {
private:

    int cash;

public:

    Dollars(int c) {

        cash = c;

    }

    //Перегрузка сложения через дружественную функцию
    friend Dollars operator+ (const Dollars &d1, const Dollars &d2);

    int getDollars() const {

        return cash;

    }

    //Перегрузка умножения через метод класса
    Dollars operator*(int value) {
        //Перегрузку унарных операторов удобно делать через метод класса
        //используется скрытый указатель на объект this
        return Dollars(cash * value);

    }

};

Dollars operator+ (const Dollars &d1, const Dollars &d2) {

    return Dollars(d1.cash + d2.cash);

}

Dollars operator- (const Dollars &d1, const Dollars &d2) {
    //Перегрузка вычитания через обычную функцию. Используется get метод
    return Dollars(d1.getDollars() - d2.getDollars());

}

int main() {

    Pet pet(5, "Tom", "Mike");  //Прямой вызов
        cout << "Tom's age: " << pet.getAge() << endl;
    Pet &rpet = pet;            //Вызов через ссылку на объект pet
        cout << "Tom's age: " << rpet.getAge() << " (reference)" << endl;
    Pet *ppet = &pet;           //Вызов через указатель на объект pet
        cout << "Tom's age: " << ppet->getAge() << " (pointer)" << endl;
    //Указатели и ссылки могут указывать на базовый и производные классы,
    //но доступ имеют только к унаследованным членам класса.
    Animal &ranimal = pet;
        cout << "Tom's age: " << ranimal.getAge() << " (reference)" << endl;
    Animal *panimal = &pet;
        cout << "Tom's age: " << panimal->getAge() << " (pointer)" << endl;
        //cout << "Tom's owner: " << panimal->getOwner() << " (pointer)" << endl;

    writeAge(ranimal); //Передается ссылка типа animal на объект pet.
                       //Выполняется метод класса pet после переопределения
    cout << endl;

    Pet *p_pet = new Pet(7, "Tony", "Hank");
    Animal *animal = p_pet;
    delete animal;  //Создано два объекта типа pet, которые удалятся вместе с animal

    Cat cat;
    Dog dog;
    Cartoon cart;
    Animals *animal1 = &cat;
    Animals *animal2 = &dog;
    Animals *animals3 = &cart;
        animal1->say();
        animal2->say();
        animals3->say();
        cout << endl;

    // Создаем указатель на функцию add
    int (*pF)(int, int) = add;
    cout << pF(4, 5) << endl << endl; // вызов add(4 + 5)
    //Раннее связывание - обычный вызов
    //Позднее связывание - выбирается реализация на этапе выполнения

    Dollars cash1(7);
    Dollars cash2(9);
    Dollars Sum = cash1 + cash2;
    cout << "I have: " << Sum.getDollars() << " dollars" << endl;
    Sum = cash2 - cash1;
    cout << "I have: " << Sum.getDollars() << " dollars" << endl;
    Sum = cash1 * 5;
    cout << "I have: " << Sum.getDollars() << " dollars" << endl;

return 0;
}
