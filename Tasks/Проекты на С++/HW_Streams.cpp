#include <iostream>
#include <string>
#include <sstream>
#include <cctype>
#include <vector>
#include <iomanip>
#include <limits>
using namespace std;

//1. Добавить перегрузку операторов ввода-вывода для класса Fraction
//из предыдущих заданий так, чтобы при выполнении этого кода:
//int main() {
//    Fraction f1;
//    cout << "Enter fraction 1: ";
//    cin >> f1;
//    Fraction f2;
//    cout << "Enter fraction 2: ";
//    cin >> f2;
//    cout << f1 << " * " << f2 << " is " << f1 * f2 << '\n';
//    return 0; }
//... выводилось на экран:
//Enter fraction 1: 3/4
//Enter fraction 2: 4/9
//3/4 * 4/9 is 1/3
class Fraction {
private:

    int num;
    int den;

public:

    Fraction(int n = 0, int d = 1): num(n), den(d) {

        if (d == 0) {

            cout << "Denominator equal zero! Increased to 1" << endl;
            den = 1;

        }

    }

    void getFraction() {

        cout << num << "/" << den << endl;

    }

    int getNum() const {

        return num;

    }

    int getDen() const {

        return den;

    }

    friend ostream& operator<< (ostream &out, const Fraction &fr);
    friend istream& operator>> (istream &in, Fraction &fr);
    friend string operator* (Fraction &fr1, Fraction &fr2);

};

int gcd (int a, int b) { //НОД двух чисел

    return b ? gcd (b, a % b) : a;

}

ostream& operator<< (ostream &out, const Fraction &fr) {

    out << fr.num << "/" << fr.den;
    return out;

}

istream& operator>> (istream &in, Fraction &fr) {

    in >> fr.num;
    in >> fr.den;
    return in;

}

string operator* (Fraction &fr1, Fraction &fr2) {

    int num = fr1.num * fr2.num;
    int den = fr1.den * fr2.den;
    int d = gcd(num, den);
    return to_string(num/d) + "/" + to_string(den/d);

}

//4. Создать собственный манипулятор endll для стандартного потока
//вывода, который выводит два перевода строки и сбрасывает буфер.
ostream& endll(ostream &stream) {

    cout << "\n" << "\n";
    cout.flush();

return stream;
}

int main() {

    Fraction f1;
    cout << "Enter fraction 1: ";
    cin >> f1;
    Fraction f2;
    cout << "Enter fraction 2: ";
    cin >> f2;
    cout << f1 << " * " << f2 << " is " << f1 * f2 << '\n';
    cin.ignore(32767, '\n');
//2. Создать программу, которая бы запрашивала у пользователя строки
//до тех пор, пока он не введет пустую строку. После этого программа
//должна вывести список введенных строк в два столбца, первый из
//которых выровнен по левому краю, а второй — по правому краю.
    string input;
    vector<string> vec;

        cout << endl << "Enter strings: " << endl;
        while (getline(cin, input)) {

            vec.push_back(input);
            if (input.empty()) break;

        }

    cout << "Table of inputs: " << endl;

        for (int i = 0; i < (vec.size() - 1); i++) {

            if (i%2 == 0) {

                cout.setf(ios::left);
                cout << setw(15) << vec.at(i) << " ";

            } else {

                cout.setf(ios::right);
                cout << setw(15) << vec.at(i) << " " << endl;
                cout.unsetf(ios::right);

            }

        }

    cout << endl;
//3. Создать программу, которая считывает целое число типа int. И
//поставить «защиту от дурака»: если пользователь вводит что-то
//кроме одного целочисленного значения, нужно вывести сообщение
//об ошибке и предложить ввести число еще раз. Пример неправильных
//введенных строк:
//rbtrb
//nj34njkn
//1n

    int n;
    cout << endl << "Enter a number: ";
    while (!(cin >> n) || (cin.peek() != '\n')) {

        cin.clear();
        while (cin.get() != '\n');
        cout << "Error! Try again: ";

    }
    cout << "number is: " << n << endll;
//4.Используется flush

    cout << "This is: " << endll << "a Joke!";

return 0;
}








