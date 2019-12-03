#include <vector>
#include <iostream>
#include <algorithm>
#include <string>
using namespace std;
//Основные методы вектора
void print(vector<int> &a) {

    cout << "The length is: " << a.size() << endl; //Длина вектора

        for(unsigned int i = 0; i < a.size(); i++) {

            cout << a.at(i) << ' '; //Надежнее, чем a[i]

        }

    cout << endl << endl;

}

int main() {

    vector<int> array = {10, 8, 6, 4, 2, 0}; //Объявляем вектор из целочисленных значений
    print(array);

    array.resize(7); //Растягиваем длину до 7 элементов
    print(array);
    array.resize(3); //Сжимаем длину до 3 элементов
    print(array);

    array.push_back(-4); //Добавляем значение в конец
    array.push_back(-3);
    print(array);

    array.pop_back();   //Убираем последний элемент
    print(array);

    cout << "Capacity is " << array.capacity() << endl; //Показать объем выделенной памяти
    array.shrink_to_fit();          //Убрать запас выделенной памяти
    cout << "Capacity is " << array.capacity() << endl;
    array.clear();   //Полностью очищаем вектор
        //Проверка на пустоту
        if(array.empty()) {

            cout << "Vector is empty" << endl;

        }

    for(int i = 1; i < 9; i++) {

        array.push_back(i);

    }

    cout << endl;

//Итератор STL
vector<int>::iterator it; // объявляем итератор

    for(it = array.begin(); it != array.end(); it++) {

        cout << *it << " "; //Begin и end задает начало и конец вектора

    }

    cout << endl;

    sort(array.begin(), array.end());   //Сортировка по возрастанию
    for(it = array.begin(); it != array.end(); it++) {

        cout << *it << " "; //Begin и end задает начало и конец вектора

    }

    cout << endl;

    sort(array.rbegin(), array.rend());   //Сортировка по убыванию (реверс)
    for(it = array.begin(); it != array.end(); it++) {

        cout << *it << " ";

    }

    cout << endl;

return 0;
}

