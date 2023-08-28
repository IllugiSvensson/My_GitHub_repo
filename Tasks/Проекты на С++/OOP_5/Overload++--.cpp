#include <iostream>
using namespace std;

class Day {
private:

    int day;

public:

    Day(int d = 1): day(d) {

    }

    Day &operator++();   // версия префикс
    Day &operator--();
    Day operator++(int); // версия постфикс
    Day operator--(int);

    void getDay() const {

        cout << day << endl;

    }

};

Day &Day::operator++() {
    // Если значением переменной day является 31, то выполняем сброс на 1
    if (day == 31)
        day = 1;
    // в противном случае просто увеличиваем day на единицу
    else ++day;

return *this;   //Возвращаем указатель на объект, который вызвал метод
}

Day &Day::operator--() {
    // Если значением переменной day является 1, то присваиваем day значение 31
    if (day == 1)
        day = 31;
    // в противном случае просто уменьшаем day на единицу
    else --day;

return *this;
}

Day Day::operator++(int) {
    // Создаем временный объект класса Day с текущим значением переменной day
    Day temp(day);

    // Используем оператор инкремента версии префикс для реализации
    //перегрузки оператора инкремента версии постфикс
    ++(*this); // реализация перегрузки

    // возвращаем временный объект
return temp;
}

Day Day::operator--(int) {

    Day temp(day);
    --(*this);

return temp;
}


int main() {

    Day day(31);
    day.getDay();
    (++day).getDay();   //Префиксная форма
    (--day).getDay();   //Сначала действие, потом результат
    (day++).getDay();
    day.getDay();       //Постфиксная форма
    (day--).getDay();   //Сначала результат, потом действие
    day.getDay();

return 0;
}

