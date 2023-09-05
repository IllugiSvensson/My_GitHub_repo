#include <iostream>
#include <ostream>
#include <memory>
using namespace std;
//1. Создайте класс Date с полями день, месяц, год и методами доступа
//к этим полям. Перегрузите оператор вывода для данного класса.
//Создайте два "умных" указателя today и date. Первому присвойте
//значение сегодняшней даты. Для него вызовите по отдельности
//методы доступа к полям класса Date, а также выведите на экран
//данные всего объекта с помощью перегруженного оператора вывода.
//Затем переместите ресурс, которым владеет указатель today в
//указатель date. Проверьте, являются ли нулевыми указатели
//today и date и выведите соответствующую информацию об этом в консоль.
//2. По условию предыдущей задачи создайте два умных указателя
//date1 и date2.
//** Создайте функцию, которая принимает в качестве параметра
//два умных указателя типа Date и сравнивает их между собой
//(сравнение происходит по датам). Функция должна вернуть более
//позднюю дату.
//** Создайте функцию, которая обменивает ресурсами (датами) два
//умных указателя, переданных в функцию в качестве параметров.
//Примечание: обратите внимание, что первая функция не должна
//уничтожать объекты, переданные ей в качестве параметров.
class Date {
private:
    int year;
    int month;
    int day;
public:
    Date(int d = 1, int m = 1, int y = 2000)
    {
        year = y;
        month = m;
        day = d;
    }
    int getYear() const { return year; }
    int getMonth() const { return month; }
    int getDay() const { return day; }
    friend ostream& operator<< (ostream &out, const Date &date);
};

ostream& operator<< (ostream &out, const Date &date)
{
    out << date.day << "/" << date.month << "/" << date.year;
    return out;
}

Date compareDates(const Date& d1, const Date& d2)
{
    if(d1.getYear() > d2.getYear())
        return d2;
    else if (d1.getYear() < d2.getYear()) return d1;

    if(d1.getMonth() > d2.getMonth())
        return d2;
    else if (d1.getMonth() < d2.getMonth()) return d1;

    if(d1.getDay() > d2.getDay())
        return d2;
    else if (d1.getDay() < d2.getDay()) return d1;
    else return d1;

}

void swapDates(Date& d1, Date& d2)
{
    unique_ptr<Date> tmp = make_unique<Date>();
    *tmp = d1;
    d1 = d2;
    d2 = *tmp;
}

int main() {

    unique_ptr<Date> today = make_unique<Date>(06, 01, 1993);
    unique_ptr<Date> date = make_unique<Date>();
    cout << today->getDay() << "/" << today->getMonth() <<
            "/" << today->getYear() << " : " << *today << endl;
    cout << *date << endl;
    date = move(today);
    if (date == nullptr) cout << "Date is null" << endl;
    if (today == nullptr) cout << "Today is null" << endl;

    unique_ptr<Date> date1 = move(date);
    unique_ptr<Date> date2 = make_unique<Date>(27, 10, 1993);
    cout << compareDates(*date1, *date2) << endl;

    cout << *date1 << " : " << *date2 << endl;
    swapDates(*date1, *date2);
    cout << *date1 << " : " << *date2 << endl;

return 0;
}
