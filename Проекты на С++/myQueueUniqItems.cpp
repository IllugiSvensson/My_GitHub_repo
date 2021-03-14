#include <iostream>
#include <string>
#include <vector>
#include <cassert>
#include <cstring>
using namespace std;
//Реализовать класс, описывающий структуру "Очередь"
//Создать методы push, pop, front, back
//Добавить несколько элементов, посмотреть первый и последний,
//Затем убрать первый элемент и повторить просмотр
class QueueInt {
private:

    int length;
    int *data;

public:

    QueueInt(): length(0), data(nullptr) {} //Пустой массив

    ~QueueInt() {

        delete[] data; //Очищаем память

    }

    void push(int x) { // добавить элемент х в конец очереди

        int *d = new int[length + 1];   //Создаем массив на 1 больше существующего
        memset(d, 0, (length + 1) * sizeof(int));

            for(int i = 0; i < length; i++) { //Копируем элементы в новый массив

                d[i] = data[i];

            }

        d[length] = x;                  //Добавляем новый элемент


        if(data != nullptr) delete [] data; //Удаляем старый массив
        data = d;
        length++;                       //Увеличиваем длинну

    }

    int size() { // узнать количество элементов в очереди

        return length;

    }

    int front() { // вернуть первый элемент в очереди


        return (length == 0)? 0: data[0];

    }

    int back() { // вернуть последний элемент в очереди

        return (length == 0)? 0: data[length - 1];

    }

    void erase() {  //Метод - аналог clear
        //Проверка на нулевой указатель
        memset(data, 0, length * sizeof(int));
        if(data == nullptr) delete[] data;
        data = nullptr;
        length = 0;

    }

    void pop() { // удалить первый элемент в очереди

        if(length <= 1) {

            erase(); //Если один элемент, то обнуляем массив
            return;

        }

        int *d = new int[length - 1];           //Создаем массив на 1 меньше исходного
        memset(d, 0, length * sizeof(int));

            for(int i = 0; i < length; i++) {   //Заполняем его, начиная со второго элемента

                d[i] = data[i + 1];

            }

        if(data != nullptr) delete [] data; //Удаляем старый массив
        data = d;
        length--;                       //Уменьшаем длинну

    }

    int uniq() { //Метод подсчета уникальных элементов для следующего задания

        if(length == 0) {   //Когда нет элементов

            return 0;

        }

        int MAX = data[0];  //Будет использована урезанная сортировка подсчетом
        int MIN = data[0];

            for(int i = 1; i < length; i++) {   //Определяем диапазон значений

                if(MAX < data[i]) MAX = data[i];
                if(MIN > data[i]) MIN = data[i];

            }

        if((MAX - MIN) == 0) MAX++;
        bool *d = new bool[MAX - MIN];           //Создаем вспомогательный массив
        memset(d, 0, length * sizeof(bool));

            for(int i = 0; i < length; i++) {   //Заполняем единицами индексы
                                                //которые являются значениями
                d[data[i] - MIN] = 1;           //исходного массива

            }

        int count = 0;

            for(int i = 0; i < MAX - 1; i++) {

                if(d[i] == 1) count++;

            }

        delete[] d;     //Удаляем старый массив
        d = nullptr;
        return count;

    }

};

int main() {

    QueueInt myQueue;       //создаем пустую очередь
        myQueue.push(1);    //Добавим в очередь несколько элементов
        myQueue.push(2);
        myQueue.push(3);

    cout << "Количество элементов в очереди: " << myQueue.size() << endl;
    cout << "Вот первый: " << myQueue.front() << "\nВот последний: " << myQueue.back() << endl;

        myQueue.pop();     //Удалим один элемент в очереди

    cout << "\nКоличество элементов в очереди: " << myQueue.size();
    cout << "\nВот первый: " << myQueue.front() << "\nВот последний: " << myQueue.back() << endl;

    //Дан вектор чисел (числа вводятся с клавиатуры), требуется выяснить,
    //сколько среди них различных. Постараться использовать максимально быстрый алгоритм.
    int digits = 0;
    cout << "\nВведите числа: ";

        while (true) {

            cin >> digits;
            if(digits == -1) break;
            myQueue.push(digits);

        }

    cout << "Число уникальных чисел: " << myQueue.uniq();

return 0;
}

