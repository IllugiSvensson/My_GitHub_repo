#include <iostream>
#include <memory>
using namespace std;

//Шаблон проектирования: Стратегия
//Задача: Нужно создать класс автомобилей с бензиновым и электродвигателем
//так же нужен класс-прототип автомобиле, который не ездит
//Предполагается, что будет родительский класс Car, и пара дочерних, которые
//переопределяют тип двигателя. В шаблонной структуре нужно добавить еще
//один дочерний класс Nomove, который описывает прототипы без двигателя.
class IMovable {
public:

    virtual void move() const = 0;

};

class PetrolMove: public IMovable {
public:

    void move() const override;

};

class ElectricMove: public IMovable {
public:

    void move() const override;

};

class Car {
private:

    IMovable *movable_;

public:

    Car(IMovable *strategy);
    void set_movable(IMovable *strategy);
    void move() const;

};


void PetrolMove::move() const {

    cout << "Petrol move" << endl;

}
void ElectricMove::move() const {

    cout << "Electric move" << endl;

}
Car::Car(IMovable *strategy): movable_(strategy) {

}
void Car::set_movable(IMovable *strategy) {

    movable_ = strategy;

}
void Car::move() const {

    movable_ -> move();

}


int main() {

    PetrolMove petrolMove;
    ElectricMove electricMove;

    Car car1(&petrolMove);
    Car car2(&electricMove);

    car1.move();
    car2.move();

    car1.set_movable(&electricMove);
    car1.move();

return 0;
}

