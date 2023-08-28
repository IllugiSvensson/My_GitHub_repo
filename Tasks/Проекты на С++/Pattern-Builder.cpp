#include <iostream>
#include <memory>
using namespace std;

//Шаблон проектирования: Строитель
class Pizza {
private:

    string dough;
    string sauce;
    string topping;

public:

    void setDough(const string &dough);
    void setSauce(const string &sauce);
    void setTopping(const string &topping);
    void open() const;

};

class PizzaBuilder {
protected:

    unique_ptr<Pizza> pizza;

public:

    virtual ~PizzaBuilder() = default;

    Pizza *getPizza();
    void createNewPizzaProduct();
    virtual void buildDough() = 0;
    virtual void buildSauce() = 0;
    virtual void buildTopping() = 0;

};

class HawaiianPizzaBuilder: public PizzaBuilder {
public:

    ~HawaiianPizzaBuilder() override = default;

    void buildDough() override;
    void buildSauce() override;
    void buildTopping() override;

};

class SpicyPizzaBuilder: public PizzaBuilder {
public:

    ~SpicyPizzaBuilder() override = default;

    void buildDough() override;
    void buildSauce() override;
    void buildTopping() override;

};

class Cook {
private:

    PizzaBuilder *pizzaBuilder;

public:

    void openPizza();
    void makePizza(PizzaBuilder *pb);

};

void Pizza::setDough(const string &d) {

    dough = d;

}
void Pizza::setSauce(const string &s) {

    sauce = s;

}
void Pizza::setTopping(const string &t) {

    topping = t;

}
void Pizza::open() const {

    cout << "Pizza with " << dough << ", " << sauce << "and " << topping << endl;

}
Pizza *PizzaBuilder::getPizza() {

    return pizza.release();

}
void PizzaBuilder::createNewPizzaProduct() {

    pizza = make_unique<Pizza>();

}
void HawaiianPizzaBuilder::buildDough() {

    pizza -> setDough("cross");

}
void HawaiianPizzaBuilder::buildSauce() {

    pizza -> setSauce("mild");

}
void HawaiianPizzaBuilder::buildTopping() {

    pizza -> setTopping("ham+pineapple");

}
void SpicyPizzaBuilder::buildDough() {

    pizza -> setDough("pan baked");

}
void SpicyPizzaBuilder::buildSauce() {

    pizza -> setSauce("hot");

}
void SpicyPizzaBuilder::buildTopping() {

    pizza -> setTopping("pepperoni+salami");

}
void Cook::openPizza() {

    pizzaBuilder -> getPizza() -> open();

}
void Cook::makePizza(PizzaBuilder *pb) {

    pizzaBuilder = pb;
    pizzaBuilder -> createNewPizzaProduct();
    pizzaBuilder -> buildDough();
    pizzaBuilder -> buildSauce();
    pizzaBuilder -> buildTopping();
}

int main() {

    Cook cook;
    HawaiianPizzaBuilder hawaiianPizzaBuilder;
    SpicyPizzaBuilder spicyPizzaBuilder;

    cook.makePizza(&hawaiianPizzaBuilder);
    cook.openPizza();

    cook.makePizza(&spicyPizzaBuilder);
    cook.openPizza();

return 0;
}

