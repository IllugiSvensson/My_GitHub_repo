#include <iostream>
#include <cmath>
using namespace std;

//Создать класс Power, который содержит два вещественных числа.
//Этот класс должен иметь две переменные-члена для хранения этих вещественных чисел.
//Еще создать два метода: один с именем set, который позволит присваивать значения переменным,
//второй — calculate, который будет выводить результат возведения первого числа в степень второго
//числа. Задать значения этих двух чисел по умолчанию.
class Power {
private:

    float A = 1;
    float B = 1;

public:

    Power ()  {     //Конструктор по умолчанию проинициализирует переменные

    }

    void set(float a, float b) {

        A = a;
        B = b;

    }

    void calculate() {

        cout << "A ^ B = " << pow(A, B) << endl;

    }

};

//Написать класс с именем RGBA, который содержит 4 переменные-члена типа
//std::uint8_t: m_red, m_green, m_blue и m_alpha (#include cstdint для доступа к этому типу).
//Задать 0 в качестве значения по умолчанию для m_red, m_green, m_blue и 255 для m_alpha.
//Создать конструктор со списком инициализации членов, который позволит пользователю
//передавать значения для m_red, m_blue, m_green и m_alpha. Написать функцию print(),
//которая будет выводить значения переменных-членов.
class RGBA {
private:

    uint8_t m_red;
    uint8_t m_green;
    uint8_t m_blue;
    uint8_t m_alpha;

public:
                            //Используем конструктор со списком инициализации
    RGBA(uint8_t r = 0, uint8_t g = 0, uint8_t b = 0, uint8_t a = 255):
        m_red(r), m_green(g), m_blue(b), m_alpha(a) {

    }

    void print() {

        cout << "Red: " << m_red << endl;
        cout << "Green: " << m_green << endl;
        cout << "Blue: " << m_blue << endl;
        cout << "Alpha: " << m_alpha << endl;

    }

};

//Написать класс, который реализует функциональность стека. Класс Stack должен иметь:
//private-массив целых чисел длиной 10;
//private целочисленное значение для отслеживания длины стека;
//public-метод с именем reset(), который будет сбрасывать длину и все значения элементов на 0;
//public-метод с именем push(), который будет добавлять значение в стек.
//public-метод с именем pop() для вытягивания и возврата значения из стека. Если в стеке нет значений,
//то должно выводиться предупреждение;
//public-метод с именем print(), который будет выводить все значения стека.
class Stack {
private:

    int array[10];
    int track = 0;

public:

    void reset() {

        track = 0;

            for(int i = 0; i < 10; i++) {

                array[i] = 0;

            }

    }

    void push(int data) {

        if(track < 10) {

            array[track] = data;    //Заполняем массив
            track++;                        //Сдвигаем трекер

        } else

            cout << "Stack is full" << endl;

    }

    int pop() {

        int arr = NULL;
        if(track > 0) {

            arr = array[track];     //Вынимаем значение из массива
            track--;                        //Сдвигаем трекер

        } else {

            cout << "Stack is empty" << endl;

        }

    return arr;
    }

    void print() {

    cout << "(";

        for(int i = 0; i < track; i++) {    //Выводим отслеженное количество элементов

            cout << array[i] << " ";

        }

    cout << ")" << endl;

    }

};

int main() {

    Power pw;
    float a, b;
        cout << "Введите число для возведения в степень: ";
        cin >> a;
        cout << "Введите степень: ";
        cin >> b;

            pw.set(a, b);
            pw.calculate();
            cout << endl;

    uint8_t r, g, bl, al;
        cout << "Введите значение красной составляющей: ";
        cin >> r;
        cout << "Введите значение зеленой составляющей: ";
        cin >> g;
        cout << "Введите значение синей составляющей: ";
        cin >> bl;
        cout << "Введите значение альфы: ";
        cin >> al;

    RGBA rgba(r, g, bl, al);

        rgba.print();

    Stack stack;
    stack.reset();
    stack.print();

    stack.push(3);
    stack.push(7);
    stack.push(5);
    stack.print();

    stack.pop();
    stack.print();

    stack.pop();
    stack.pop();
    stack.print();

return 0;
}
