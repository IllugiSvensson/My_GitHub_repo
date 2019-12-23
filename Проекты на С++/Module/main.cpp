#include <iostream>
#include "funcs.hpp"
#include "date.hpp"
#include "globals.hpp"
using namespace std;

int main() {

    int days;
    days = increase();
    days = increase();
    days = decrease();

        cout << "Days: " << days << " number: " << celebration << endl;

    Date d1, d2;

        if (d1.get_day() == dayDefault)
            cout << "День установлен по умолчанию" << endl;

        cout << "Число вызовов функций: " << d2.get_number() << endl;
        d1.changeDay(5);
        cout << "День установлен в: " << d1.get_day() << endl;
        cout << "Число созданных объектов: " << d1.get_number() << endl;

return 0;
}
