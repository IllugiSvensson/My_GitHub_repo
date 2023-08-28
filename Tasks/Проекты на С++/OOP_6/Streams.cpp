#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
using namespace std;

int main() {
//Примеры использования istream
    char name[12]; //11 символов + нуль-терминатор
    cout << "Введите ваше имя: ";
    cin >> setw(5) >> name; //Ограничиваем считываемые символы до 5
    cout << "Ваше имя: " << name << endl;
    //Если поток не пуст, то cin.get() считает один символ и вернет его код
    cout << "Первый оставшийся символ в потоке: " << (char)cin.get() << endl;
    //Можно указать, сколько символов из оставшегося потока считать
    cout << "Оставшиеся символы: "; cin.get(name, 5); cout << name << endl;
    //Если поток пуст, то cin.get попросит произвести ввод данных
    cout << "Введите ваше имя и фамилию: ";
    char fio[15];   //Если поток не пуст, то последующий cin>> захватит его и пропустит пользовательский ввод!!
    cin >> setw(2) >> fio;
    cout << "Имя и Фамилия: "; cin.getline(fio, 20); cout << fio << endl;
    //Работает как и get, но захватывает и символ перевода строки
    cout << "Символов считано: " <<  cin.gcount() << endl;

    string str; //Специальная версия getline из библиотеки string
    cout << "Введите данные еще раз: "; getline(cin, str);
    cout << "Имя и Фамилия: " << str << endl;

//Пример использования ostream
    cout << "Введите ваш Возраст: ";
    int age;
    cin >> age;
        if(age <= 0) {

            cerr << "Error" << endl;    //Поток ошибок
            exit(1);

        }

    cout.setf(ios::showpos);    //Флаг, включающий отображение знака +
    cout << "Showpos: " << age << endl;
    cout.unsetf(ios::showpos) ; //Отключаем флаг
    cout << "Noshowpos: " << age << endl;
    cout.unsetf(ios::dec);  //Флаги нужно выключать перед использованием аналогичных флагов
    cout.setf(ios::hex);
    cout << "Hex: " << age << endl;
    cout << "Dec: " << dec << age << endl; //Использование манипулятора

    bool f = true;  //Буквенное/циферное обозначение логики
    cout << "Bool: " << boolalpha << f << noboolalpha << " " << f << endl;

    double d = 100.12345;
    double c = -100.12345;
    cout.fill('x');     //Заполнитель поля
    cout << "3 знака после запятой в exp форме: " << setprecision(2) << scientific << d << endl;
    cout << "Ширина поля 15 с разделением знака: " << setw(15) << left << fixed << internal << c << endl;
    //Манипуляторы вставляются в поток и влияют на вывод

//Пример использования потоковых классов для строк
//Конвертация чисел и строк

    stringstream myString;
    //myString << "Hello World!" << endl; //Заносим данные в строковый поток
    myString.str("Hello World!");   //Можно и так
    cout << myString.str() << endl;

    int nValue = 336000;
    double dValue = 12.14;
    string strValue1, strValue2;
    myString << nValue << " " << dValue; //загружаем числа в поток
    myString >> strValue1 >> strValue2; //Выгружаем их в строку
    cout << "Символьная строка: " << strValue1 << " " << strValue2 << endl;
    myString << "336000 12.14"; //загружаем строку в поток
    myString >> nValue >> dValue; //выгружаем её в числа
    cout << "Циферная строка: " << nValue << " " << dValue << endl;

return 0;
}
