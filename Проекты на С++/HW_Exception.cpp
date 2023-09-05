#include <iostream>
#include <memory>
#include <string>
using namespace std;
//1.Написать шаблонную функцию div, которая должна вычислять
//результат деления двух параметров и запускать исключение
//DivisionByZero, если второй параметр равен 0. В функции main
//выводить результат вызова функции div в консоль, а также ловить исключения.
//2. Написать класс Ex, хранящий вещественное число x и имеющий
//конструктор по вещественному числу, инициализирующий x значением
//параметра. Написать класс Bar,хранящий вещественное число y
//(конструктор по умолчанию инициализирует его нулем) иимеющий
//метод set с единственным вещественным параметром a.
//Если y + a > 100, возбуждается исключение типа Ex с данными a*y,
//иначе в y заносится значение a. В функции main завести переменную
//класса Bar и в цикле в блоке try вводить с клавиатуры целое n.
//Использовать его в качестве параметра метода set до тех пор,
//пока не будет введено 0. В обработчике исключения выводить
//сообщение об ошибке, содержащее данные объекта исключения.
//3. Написать класс «робот», моделирующий перемещения робота по
//сетке 10x10, у которого есть метод, означающий задание
//переместиться на соседнюю позицию. Эти методы должны запускать
//классы-исключения OffTheField, если робот должен уйти с сетки,
//и IllegalCommand, если подана неверная команда
//(направление не находится в нужном диапазоне). Объект исключения
//должен содержать всю необходимую информацию — текущую позицию и
//направление движения. Написать функцию main, пользующуюся этим
//классом и перехватывающую все исключения от его методов, а также
//выводящую подробную информацию о всех возникающих ошибках.
template<typename T>
T Div(T d1, T d2)
{
    if ((d2 == 0) or d2 == 0.0) throw 1;
    return d1 / d2;
}

class Ex {
private:
    float x;
public:
    Ex(float xEx): x(xEx) {}
    float Get()
    {
        return x;
    }
};

class Bar {
private:
    float y;
public:
    Bar(float yBar = 0.0)
    { y = yBar; }
    void set(float a)
    {
        if ((y + a) > 100) throw Ex(a * y);
        else y = a;
    }
};

void showMap(char *map)
{
    for (int i = 0; i < 100; i++)
    {
        if (i % 10 == 0) cout << endl;
        cout << map[i] << " ";
    }
    cout << endl;
}
class OffTheField{
private:
    int x, y;
public:
    OffTheField(int xX, int yY): x(xX), y(yY) {}
    const string getPos()
    {
        return "x = " + to_string(x) + " y = " + to_string(y);
    }

};
class IllegalCommand{
private:
    char c;
public:
    IllegalCommand(char command): c(command){}
    const string getCommand()
    {
        return "Command: " + to_string(c);
    }
};

class Robot{
private:
    int x, y;
public:
    Robot(char *map, int xR = 0, int yR = 0)
    {
        x = xR;
        y = yR;
        map[y * 10 + x] = '0';
    }
    void Move(char *map, char command)
    {
        map[y * 10 + x] = '*';
        switch (command) {
        case 'd':
            if (x == 9) throw OffTheField(x + 1, y);
            map[y * 10 + x + 1] = '0';
            x++;
            break;
        case 'a':
            if (x == 0) throw OffTheField(x - 1, y);
            map[y * 10 + x - 1] = '0';
            x--;
            break;
        case 'w':
            if (y == 0) throw OffTheField(x, y - 1);
            map[y * 10 + x - 10] = '0';
            y--;
            break;
        case 's':
            if (y == 9) throw OffTheField(x, y + 1);
            map[y * 10 + x + 10] = '0';
            y++;
            break;
        default: throw IllegalCommand(command);
        }
    }
};

int main() {

    //Task 1
    try {
        cout << Div(1.0, 0.0) << endl;
    }  catch (int) {
        cout << "DivisionByZero!" << endl;
    }
    //Task 2
    Bar bar;
    int n;
    try {
        do {
            cout << "Enter number: ";
            cin >> n;
            bar.set(n);
        } while (n != 0);
    }  catch (Ex& error) {
        cerr << "Error: " << error.Get() << endl;
    }
    //Task 3
    char map[100], com;
    for (int i = 0; i < 100; i++) map[i] = '*';
    Robot robot(map, 9, 5);
    showMap(map);
    do {
        cout << "Move to: ";
        cin >> com;
        try {
            robot.Move(map, com);
        } catch (IllegalCommand& IC) {
              cout << "Wrong command!" << endl;
              cout << IC.getCommand() << endl;
              exit(2);
        } catch (OffTheField& OTF) {
            cout << "Robot out of range!" << endl;
            cout << OTF.getPos() << endl;
            exit(1);
        }
        showMap(map);
    } while (true);

return 0;
}

