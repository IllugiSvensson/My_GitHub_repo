#include <iostream>
#include <cmath>
using namespace std;

//Создать абстрактный класс Figure (фигура). Его наследниками являются
//классы Parallelogram (параллелограмм) и Circle (круг). Класс Parallelogram —
//базовый для классов Rectangle (прямоугольник), Square (квадрат), Rhombus (ромб).
//Для всех классов создать конструкторы. Для класса Figure добавить чисто
//виртуальную функцию area() (площадь). Во всех остальных классах переопределить
//эту функцию, исходя из геометрических формул нахождения площади.
class Figure {
public:
    //Чисто виртуальная функция
    virtual void area() = 0;

};

class Parallelogram : public Figure {
private:

    unsigned int base;
    unsigned int height;

public:

    Parallelogram(unsigned int b = 0, unsigned h = 0): base(b), height(h) {

    }

    void area() {
        //Переопределение абстрактной функции
        cout << "Area of Parallelogram: " << base * height << endl;

    }

};

class Circle : public Figure {
private:

    unsigned int radius;

public:

    Circle(unsigned int r = 0): radius(r) {

    }

    void area() {

        cout << "Area of Circle: " << M_PI * pow(radius, 2) << endl;

    }

};

class Rectangle : public Parallelogram {
private:

    unsigned int lenght;
    unsigned int width;

public:

    Rectangle(unsigned int l = 0, unsigned w = 0): lenght(l), width(w) {

    }

    void area() {

        cout << "Area of Rectangle: " << lenght * width << endl;

    }

};

class Square : public Parallelogram {
private:

    unsigned int side;

public:

    Square(unsigned int s = 0): side(s) {

    }

    void area() {

        cout << "Area of Square: " << pow(side, 2) << endl;

    }

};

class Rhombus : public Parallelogram {
private:

    unsigned int diag1;
    unsigned int diag2;

public:

    Rhombus(unsigned int d1 = 0, unsigned int d2 = 0): diag1(d1), diag2(d2) {

    }

    void area() {

        cout << "Area of Rhombus: " << diag1 * diag2 * 0.5 << endl;

    }

};


//Создать класс Car (автомобиль) с полями company (компания) и model
//(модель). Классы-наследники: PassengerCar (легковой автомобиль) и Bus
//(автобус). От этих классов наследует класс Minivan (минивэн). Создать
//конструкторы для каждого из классов, чтобы они выводили данные о классах.
//Создать объекты для каждого из классов и посмотреть, в какой последовательности
//выполняются конструкторы. Обратить внимание на проблему «алмаз смерти».
class Car {
protected:

    string company;
    string model;

public:

    Car(string c = "someCompany", string m = "someModel"): company(c), model(m) {

        cout << "Company: " << company << " " << "Model: " << model << endl;

    }

};

class PassangerCar : virtual public Car {
public:

    PassangerCar(string c = "someCompany", string m = "someModel"): Car(c, m) {

        cout << "Company: " << company << " " << "Model: " << model << endl;
        cout << "Passanger Car" << endl;

    }

};

class Bus : virtual public Car {
public:

    Bus(string c = "someCompany", string m = "someModel"): Car(c, m) {

        cout << "Company: " << company << " " << "Model: " << model << endl;
        cout << "Bus" << endl;

    }

};

class Minivan : public PassangerCar, public Bus {
public:
        //Виртуальный базовый класс решает проблему алмаза смерти
    Minivan(string c = "someCompany", string m = "someModel"): Bus(c, m), PassangerCar(c, m), Car(c, m) {

        cout << "Company: " << company << " " << "Model: " << model << endl;
        cout << "Minivan" << endl;

    }

};


//Создать абстрактный класс Fraction (дробь). От него наследуют два класса:
//SimpleFraction (обыкновенная дробь) и MixedFraction (смешанная дробь).
//Обыкновенная дробь имеет только числитель и знаменатель (например, 3/7 или 9/2),
//а смешанная — еще и целую часть (например, 312 ). Предусмотреть, чтобы знаменатель
//не был равен 0. Перегрузить математические бинарные операторы (+, -, *, /) для
//выполнения действий с дробями, а также унарный оператор (-). Перегрузить
//логические операторы сравнения двух дробей (==, !=, <, >, <=, >=). Поскольку
//операторы < и >=, > и <= — это логические противоположности, попробуйте
//перегрузить один через другой.
class Fraction {
public:

    virtual void getFraction() = 0;

};

class MixedFraction; //Прототип класса для перегрузки

class SimpleFraction: public Fraction {
private:

    int num;
    int den;

public:

    SimpleFraction(int n = 0, int d = 1): num(n), den(d) {

        if (d == 0) {

            cout << "Denominator equal zero! Increased to 1" << endl;
            den = 1;

        }

    }

    void getFraction() {

        cout << num << "/" << den << endl;

    }

    friend class MixedFraction; //Откроем доступ к членам класса MixedFraction

    int getNum() const {

        return num;

    }

    int getDen() const {

        return den;

    }
    //Перегрузка через дружественную функцию. Нужен прототип класса MixedFraction
    friend bool operator< (const MixedFraction &a, const SimpleFraction &b);

};

class MixedFraction: public Fraction {
private:

    int num;
    int den;
    int integerpart;

public:

    MixedFraction(int n = 0, int d = 1, int i = 0):
        num(n), den(d), integerpart(i) {

            if (d == 0) {

                cout << "Denominator equal zero! Increased to 1" << endl;
                den = 1;

            }

        }

    void getFraction() {

        cout << integerpart << "-" << num << "/" << den << " = "
             << den * integerpart + num << "/" << den << endl;
        num = den * integerpart + num;

    }

    friend class SimpleFraction; //Откроем доступ к членам класса SimpleFraction
    //Перегрузим операторы здесь, доступ ко всем членам классов есть
    //Через метод класса, используем указатель this
    MixedFraction operator+ (SimpleFraction b);
    MixedFraction operator- (SimpleFraction b);
    MixedFraction operator* (SimpleFraction b);
    MixedFraction operator/ (SimpleFraction b);

    MixedFraction operator- () {

        return MixedFraction(-num, den);

    }

    int getNum() const {

        return num;

    }

    int getDen() const {

        return den;

    }

    void print() {

        cout << num << " / " << den << endl;

    }

    //Перегрузка через дружественную функцию
    friend bool operator< (const MixedFraction &a, const SimpleFraction &b);

};

MixedFraction MixedFraction::operator+ (SimpleFraction b) {

    int cd = den * b.den;
    int ns = num * b.den + b.num * den;

        MixedFraction sum(ns, cd);

return sum;
}

MixedFraction MixedFraction::operator- (SimpleFraction b) {

    int cd = den * b.den;
    int ns = num * b.den - b.num * den;

        MixedFraction subtr(ns, cd);

return subtr;
}

MixedFraction MixedFraction::operator* (SimpleFraction b) {

  int np = num * b.num;
  int dp = den * b.den;

return MixedFraction(np, dp);
}

MixedFraction MixedFraction::operator/ (SimpleFraction b) {

  int np = num * b.den;
  int dp = den * b.num;

return MixedFraction(np, dp);
}

//Перегрузка через обычные функции
bool operator== (const MixedFraction &a, const SimpleFraction &b) {

  return (a.getNum() * b.getDen() == a.getDen() * b.getNum());

}

bool operator!= (const MixedFraction &a, const SimpleFraction &b) {

  return (a.getNum() * b.getDen() != a.getDen() * b.getNum());

}

bool operator> (const MixedFraction &a, const SimpleFraction &b) {

  return (a.getNum() * b.getDen() > a.getDen() * b.getNum());

}

bool operator<= (const MixedFraction &a, const SimpleFraction &b) {
        //Перегрузка одного оператора через другой
  return !(a > b);

}

bool operator< (const MixedFraction &a, const SimpleFraction &b) {

  return (a.num * b.den < a.den * b.num);

}

bool operator>= (const MixedFraction &a, const SimpleFraction &b) {

    return !(a < b);

}


int main() {

    Parallelogram parallelogram(5, 4);
    Circle circle(2);
    Rectangle rectangle(2, 3);
    Square square(7);
    Rhombus rhombus(1, 5);
    Figure *figureP = &parallelogram;
    Figure *figureC = &circle;
    Figure *figureR = &rectangle;
    Figure *figureS = &square;
    Figure *figureRh = &rhombus;
        figureP -> area();  //Указатель типа базового класса
        figureC -> area();  //позволяет вызывать методы нужных классов
        figureR -> area();
        figureS -> area();
        figureRh -> area();

        cout << endl;

    Car car;        //Сначала вызывается конструктор базового класса
    cout << endl;
    PassangerCar passangerCar("Ford", "Focus"); //Конструктор Car + PassangerCar
    cout << endl;
    Bus bus("Ikarus", "Lux");       //Конструктор Car + Bus
    cout << endl;
    Minivan minivan("Dodge", "Caravan"); //За создание базового класса отвечает
                                        //самый дочерний
        cout << endl;

    SimpleFraction simple(3, 7);
    MixedFraction mixed(3, 4, 2);
    cout << "Simple Fraction: "; simple.getFraction();
    cout << "Mixed Fraction: "; mixed.getFraction();
    MixedFraction sum, subst, neg, mult, div;
    sum = mixed + simple;
    subst = mixed - simple;
    mult = mixed * simple;
    div = mixed / simple;
    neg = -mixed;
        cout << "Sum: "; sum.print();
        cout << "Subst: "; subst.print();
        cout << "Mult: "; mult.print();
        cout << "Div: "; div.print();
        cout << "Neg: "; neg.print();
    cout << "Equal: " << (mixed == simple) << endl;
    cout << "NotEqual: " << (mixed != simple) << endl;
    cout << "More: " << (mixed > simple) << endl;
    cout << "Less-equal: " << (mixed <= simple) << endl;
    cout << "Less: " << (mixed < simple) << endl;
    cout << "More-equal: " << (mixed >= simple) << endl;

return 0;
}
