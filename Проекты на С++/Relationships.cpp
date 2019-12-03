#include <iostream>
#include <string>
using namespace std;
//Отношения между объектами
class Cap { //Агрегация с классом Human
public:

    string getColor() const {

        return color;

    }

private:
    // Пусть все кепки будут красными.
    string color = "red";

};

class Human {   //Композиция с классом Brain
public:

    void Think() {

        brain.Think();

    }

    void InspectTheCap() {

        cout << "My cap is " << cap.getColor() << endl;

    }

private:

    class Brain {
    public:

        void Think() {

            cout << "I'm thinking!" << endl;

        }

    };

    Brain brain;
    Cap cap;

};

//Более сложный пример агрегации
class Worker {  //"Работник" не зависит от отдела
private:

    string name;

public:

    Worker(string n): name(n) {

    }

    string getName() const {

        return name;

    }

};

class Department {  //В конструкторе работник становится частью отдела
private:
    // Для простоты добавим только одного работника
    Worker *worker;

public:

    Department(Worker *w = NULL): worker(w) {

    }

};

//Ассоциация классов Car и Driver через переменную carID
class Car {
private:

    string name;
    int id;

public:

    Car(string n, int i): name(n), id(i) {

    }

    string getName() const {

        return name;

    }

    int getId() const {

        return id;

    }

};

// Данный класс содержит автомобили и имеет функцию для "выдачи" автомобиля
class CarLot {
private:

    static Car carLot[4];

public:
    // Удаляем конструктор по умолчанию, чтобы нельзя было создать объект этого класса
    CarLot() = delete;

    static Car* getCar(int id) {

        for(int count = 0; count < 4; ++count) {

            if(carLot[count].getId() == id) {

                return &(carLot[count]);

            }

        }

    return NULL;
    }

};

Car CarLot::carLot[4] = { Car("Camry", 5), Car("Focus", 14),
                          Car("Vito", 73), Car("Levante", 58) };

class Driver {
private:

    string name;
    int carId; // для связывания классов используется эта переменная

public:

    Driver(string n, int c): name(n), carId(c) {

    }

    string getName() const {

        return name;

    }

    int getCarId() const {

        return carId;

    }

};


int main() {

    Human human;
    human.Think(); //Обращаемся к методу объекта brain через human
    human.InspectTheCap(); //Метод существует отдельно от класса Human

    // Создаем нового работника
    Worker *worker = new Worker("Anton");
    // Создаем Отдел и передаем Работника в Отдел через параметр конструктора
    {

        Department department(worker);

    } // отдел выходит из области видимости и уничтожается здесь
    //а работник продолжает существовать
    cout << worker->getName() << " still exists!" << endl;
    delete worker;

    Driver d("Ivan", 14); // Ivan ведет машину с ID 14
    Car *car = CarLot::getCar(d.getCarId()); // Получаем этот Автомобиль из CarLot

        if (car) {

            cout << d.getName() << " is driving a " << car->getName() << endl;

        } else {

            cout << d.getName() << " couldn't find his car" << endl;

        }

return 0;
}
