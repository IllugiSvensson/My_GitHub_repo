#include <iostream>
#include <memory>
using namespace std;

//Шаблон проектирования: Фасад
class Alarm {
public:

    void alarmOn();
    void alarmOff();

};

class Ac {
public:

    void acOn();
    void acOff();

};

class Tv {
public:

    void tvOn();
    void tvOff();

};

class HouseFacade {
private:

    Alarm alarm;
    Ac ac;
    Tv tv;

public:

    HouseFacade() {}
    void goToWork();
    void comeHome();

};

void Alarm::alarmOn() {

    cout << "Alarm is on" << endl;

}

void Alarm::alarmOff() {

    cout << "Alarm is off" << endl;

}

void Ac::acOn() {

    cout << "Ac is on" << endl;

}

void Ac::acOff() {

    cout << "Ac is off" << endl;

}

void Tv::tvOn() {

    cout << "Tv is on" << endl;

}

void Tv::tvOff() {

    cout << "Tv is off" << endl;

}

void HouseFacade::goToWork() {

    ac.acOff();
    tv.tvOff();
    alarm.alarmOn();

}

void HouseFacade::comeHome() {

    ac.acOn();
    tv.tvOn();
    alarm.alarmOff();

}

int main() {

    HouseFacade hf;
    //Достаточно знать название класса и его методы
    hf.goToWork();
    hf.comeHome();

return 0;
}

