#include <iostream>
#include <memory>
using namespace std;

//Пример раскручивания стека:
void last() { // вызывается функцией three()

    cout << "Start last" << endl;
    cout << "last throwing int exception" << endl;
    throw -1;
    cout << "End last" << endl;

}
void three() { // вызывается функцией two()

    cout << "Start three" << endl;
    last();
    cout << "End three" << endl;

}
void two() { // вызывается функцией one()

    cout << "Start two" << endl;

        try {

        three();

        }

        catch(double) {

        cerr << "two caught double exception" << endl;

        }

    cout << "End two" << endl;

}
void one() { // вызывается функцией main()

    cout << "Start one" << endl;

        try {

            two();

        }

        catch (int) {

            cerr << "one caught int exception" << endl;

        }

        catch (double) {

            cerr << "one caught double exception" << endl;

        }

    cout << "End one" << endl;

}

//Исключения при наследовании
class Parent {
public:

    Parent() {}
    virtual ~Parent() {}
    virtual void print() {

        cout << "This is Parent" << endl;

    }

};
class Child: public Parent {
public:

    Child() {}
    ~Child() {}
    virtual void print() {

        cout << "This is Child" << endl;

    }

};

//Функциональный блок try
class Animal {
private:

    int age;

public:

    Animal(int a): age(a) {

        if(age <= 0) throw 1;

    }

};
class Pet: public Animal {
public:

    Pet(int a) try: Animal(a) {

    }

    catch(...) {
    // Этот блок находится на том же уровне отступа, что и конструктор
        cerr << "Constructor of Animal failed" << endl;
    // Исключения из списка инициализации членов класса Pet
    // или тела конструктора обрабатываются здесь
    // Если мы здесь не будем явно выбрасывать исключение,
    //то текущее (пойманное) исключение будет повторно сгенерировано
    //и отправлено в стек вызовов
    }
};


int main() {

    int x = 0;

        try {
            //в последующий блок catch выбросится первое исключение
            throw -1; //int
            throw "Error"; //const char*
            throw x;

        }

    catch(const char* ex) { //обрабатываем исключения типа const char*

        cerr << "Error in ex: " << ex << endl;

    }
    catch(int ex) { //Обрабатывается исключение типа int

        cerr << "Error in ex: " << ex << endl;

    }

    cout << endl << "Start main" << endl;

        try {
            //Начинаем наблюдения с функции one() и раскручиваем стек до last()
            one();
        }

    catch(int) {

        cerr << "main caught int exception" << endl;

    }
    catch(...) {   //Обработчик catch-all
        //ловит любой тип исключений
        cerr << "Trying to catch all exceptions" << endl;

    }

    cout << "End main" << endl << endl;

    try {

        Parent par;
        Parent &parent = par;   //Преобразование ссылки типа parent к типу child
        Child &child = dynamic_cast<Child&>(parent);

    }

    catch(exception &ex) { //exception переопределится в дочернем классе bad_cast

        cerr << "Caught: " << ex.what() << endl; //what сообщает ошибку

    }

    try {

        throw Child();

    } //Правило: обрабатывать исключения нужно, начиная с дочерних классов

    catch(Parent &parent) {

        cerr << "caught Parent" << endl;

    }
    catch(Child &child) {

        cerr << "caught Child" << endl;

    }
    cout << endl;

    try {

        try {

            throw Child();

        }

        catch(Parent &p) {

            cerr << "Caught Parent" << endl;
            p.print(); cout << endl;
            throw; //Выбрасываем повторно исключение

        }

    }

    catch(Parent &p) {

        cerr << "Caught Parent again" << endl;
        p.print(); cout << endl;

    }

    try {

        Pet pet(0);

    }

    catch(int) {

        cout << "Error" << endl;

    }

return 0;
}

