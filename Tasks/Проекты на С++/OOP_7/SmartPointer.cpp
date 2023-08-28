#include <iostream>
#include <memory>
using namespace std;
class Date {
public:

    Date(int d) {

    }

};

template<class T>
class Auto_ptr {
private:
    //Поле класса содержит указатель на другой класс
    T *m_p; //указатель произвольного типа

public:

    Auto_ptr(T *p): m_p(p) {

    }

    ~Auto_ptr() {

        delete m_p;

    }

    T& operator* () const {

        return *m_p;

    }

    T* operator-> () const {

        return m_p;

    }

    Auto_ptr(const Auto_ptr &x) = delete;   //Нужно удалить обычные конструкторы
    Auto_ptr& operator= (const Auto_ptr &x) = delete; //для использования rvalue

    //Конструктор перемещения
    Auto_ptr(Auto_ptr &a) {

        m_p = a.m_p;    //текущему полю присваиваем поле переданного объекта
        a.m_p = nullptr;    //и зануляем поле объекта

    }

    //Присвоение перемещения
    Auto_ptr& operator= (Auto_ptr &a) {

        if(&a == this) return *this; //Проверяем поля

            delete m_p; //Если поля разные, очищаем поле
            m_p = a.m_p;    //Перемещаем значения
            a.m_p =nullptr; //очищаем поле
            return *this;

    }

    bool isNULL() const {

        return m_p == nullptr;

    }

    //Конструктор перемещения для rvalue
    Auto_ptr(Auto_ptr &&a) {

        m_p = a.m_p;    //текущему полю присваиваем поле переданного объекта
        a.m_p = nullptr;    //и зануляем поле объекта

    }

    //Присвоение перемещения для rvalue
    Auto_ptr& operator= (Auto_ptr &&a) {

        if(&a == this) return *this; //Проверяем поля

            delete m_p; //Если поля разные, очищаем поле
            m_p = a.m_p;    //Перемещаем значения
            a.m_p =nullptr; //очищаем поле
            return *this;

    }

};

int main() {
    //Виды ссылок:
//    int x = 7;    //Здесь выделяется память под переменную
//    int &lref = x;  //Ссылка это всевдоним переменной
//    //Использование ссылки не создает копию объекта
//    //(ссылается на ранее выделенную память, а не выделяет новую)

//    //lvalue - выражения, имеющие область памяти в компьютере
//    //rvalue - временные выражения, не имеющие памяти
//    //анонимный класс Date(3); - это rvalue значение
//    //Область видимости для класса является сам класс

//    //Существуют rvalue ссылки
//    int &&rref = 7; //rlavue ссылка
//    //резервирует rvalue выражение для дальнейшего использования

//    //Умные указатели:
//    //Проблема
//    Date *today = new Date(17); //указатель на объект класса Date
//    //Встречаются ситуации:
//    int a = 0;
//        if (a == 1) exit(1);
//        //Принудительно выходим из программы по условию
//        //либо из-за исключения.
//    delete today; //память при этом не освобождается
//    //В этом помогает умный указатель, который сам освобождает память
//    //они создаются на основе класса и механизма деструктора:

    Auto_ptr<Date> today(new Date(17));
    //основной недостаток этого способа: поверхностное копирование
    Auto_ptr<Date> today2(today); //Появляется второй объект
    //с указателем на одну и туже область памяти
    //(копируется указатель, а не область памяти)
    //Глубокое копирование при этом сделать невозможно
    //Применим конструктор перемещения

    if(today.isNULL()) //Данные переместились в объект today2
                            //Указатель на today обнулился
            cout << "today is null" << endl;

    Auto_ptr<Date> today3 = today2;
    if(today2.isNULL())
                //аналогично с today2
            cout << "today2 is null" << endl;

    //Теперь передадим в конструктор rvalue значение:
    //Auto_ptr<Date> today4(Date(17)); //нужно изменить конструктор и присвоение
        Auto_ptr<Date> today4(Auto_ptr<Date>(new Date(17)));//и саму запись
            //Теперь конструктор принимает rvalue ссылку
        Auto_ptr<Date> today5 = move(today4); //move преобразует lvalue в rvalue
        if(today4.isNULL())
                    //аналогично с today2
                cout << "today4 is null" << endl;

    //Встроенный умный указатель:
    unique_ptr<Date> today6 = make_unique<Date>(17);    //нужен c++14
    unique_ptr<Date> today7 = move(today6);

        if(!today6) cout << "today6 is null";
        else cout << "today7 is not null";

    Date *today8 = today7.get(); //Получим обычный указатель из умного
                //= today2.release() получаем обычный указатель и удаляем умный

return 0;
}

