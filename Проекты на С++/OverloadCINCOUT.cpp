#include <iostream>
using namespace std;

class Date {
private:

    int day;
    int month;
    int year;

public:

    Date(int d = 1, int m = 1, int y = 2019): day(d), month(m), year(y) {

    }

    friend ostream& operator<< (ostream &out, const Date &date);
    friend istream& operator>> (istream &in, Date &date);
    //Тип возврата - объекты классов iostream, возвращаемых по ссылке
    //Позволяет делать цепочки вызова типа << << <<

};

ostream& operator<< (ostream &out, const Date &date) {

    out << "Date: " << date.day << ". " << date.month << ". " << date.year << endl;
    return out;

}

istream& operator>> (istream &in, Date &date) {
    //параметр date (объект класса Date) должен быть не константным, чтобы можно было изменить члены класса
    in >> date.day;
    in >> date.month;
    in >> date.year;
    return in;

}

int main() {

    Date date;
    cout << "Введите текущую дату: ";
    cin >> date;
    cout << date;

return 0;
}
