#include <iostream>
#include <regex>
using namespace std;

// # - любая цифра
// @ - любая буква
// _ - пробел
// ? - любой символ
//Валидация номера телефона
bool InputMatches(string str, string temp) {

    if(str.length() != temp.length()) return false; //Проверяем длину номера

    for(unsigned int i = 0; i < temp.length(); ++i) {

        switch(temp[i]) {   //Проверяем поэлементно введенную строку
            case '#':
                if(!isdigit(str[i])) return false;
                break;
            case '_':
                if(!isspace(str[i])) return false;
                break;
            case '@':
                if(!isalpha(str[i])) return false;
                break;
            case '?':
                break;
            default:
                if(str[i] != temp[i]) return false;

        }

    }

return true;
}

int main() {

    string s;

        while(1) {

            cout << "Введите номер телефона: ";
            getline(cin, s);
                            //Шаблон номера телефона
                if(InputMatches(s, "(###)###-####")) {

                    break;

                }

        }

    //Использование регулярных выражений
    string str = "email@host.ru";
    cmatch result;   //Шаблон
    regex regular("([\\w-]+)"
                  "(@)"
                  "([\\w-]+)"
                  "(\\.)"
                  "([a-z]{2,5})");

        //match ищет полное совпадение
        //search выделяет совпадение из строки
        if(regex_match(str.c_str(), result, regular)) {

            cout << "true" << endl;

        }

        for(int i = 0; i < result.size(); ++i) {
            //Показывает блоки совпадений
            cout << result[i] << endl;

        }

return 0;
}
