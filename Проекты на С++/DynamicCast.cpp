#include <iostream>
#include <string>
using namespace std;
//Динамическое приведение типов
class Parent {
protected:

    string name;

public:

    Parent(string n): name(n) {

    }

    virtual ~Parent() {

    }

};

class Child: public Parent {
protected:

     string patronymic;

public:

    Child(string n, string p): Parent(n), patronymic(p) {

    }

    const string &getName() {

        return name;

    }

};

Parent *Create() {
    //Данная функция возвращает указатель типа Parent
    //Но указывать может и на объект дочернего класса
    return new Child("Alex", "Mike");
    //Приведение к базовому типу Child -> Parent
}

int main() {

    Parent *p = Create();
    Child *ch = dynamic_cast<Child*>(p);
    //Приведение к дочернему типу Parent -> Child
        cout << "The name of the Child is: " << ch->getName() << '\n';

    delete p;

return 0;
}
