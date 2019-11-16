#include <iostream>
using namespace std;

class Time {
public:

    Time()  {

        cout << "Construct Time class" << endl;

    }

    ~Time()  {

        cout << "Destruct Time class" << endl;

    }

};

class Date {        //Классы закрыты по умолчанию
private:            //Доступ имеют только члены класса

    int m_day;      //m_day = 1; Конструктор по умолчанию присвоит значение
    int m_month;    //если не будет другого конструктора выше по приоритету
    int m_year;
    Time m_time;

public:             //Доступ имеет любой объект

    Date() {        //Конструкто по умолчанию

        cout << "Construct Date class" << endl;

    }

    Date(int d, int m, int y = 2000) : m_day(d), m_month(m), m_year(y)  { //Список инициализации
        //Напрямую инициализируем переменные-члены класса
    }

    void setDate(int day, int month, int year)  {
        //Можно добавить проверку данных
        m_day = day;
        m_month = month;
        m_year = year;

    }

    int getDay()  {

        return m_day;

    }

    const int &getYear()  {     //Возвращение значения по константной ссылке надежнее

        return m_year;

    }

    void print()  {

        cout << m_day << "/" << m_month << "/" << m_year << endl;

    }

    void copyFrom(const Date &b)  {	//Имеем прямой доступ к закрытым членам объекта b

        m_day = b.m_day;
        m_month = b.m_month;
        m_year = b.m_year;

    }

    ~Date() {

        cout << "Destruct Date class" << endl;

    }

};

int main()  {

    Date today; //today(1, 1); Если нет параметров, то сработает конструктор по умолчанию

        today.setDate(12, 12, 2018);
        cout << today.getYear() << endl;

    Date copy;

        copy.copyFrom(today);
        copy.print();
        	 //Конструкторы и деструкторы срабатывают по принципу стека
return 0;
}
