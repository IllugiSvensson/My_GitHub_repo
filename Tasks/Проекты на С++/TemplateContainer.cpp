#include <iostream>
#include <string>
#include <vector>
#include <cassert>
#include <cstring>
using namespace std;
//Можно определить данный класс в заголовочном файле .h

template <class T>
class ArrayTemplate {
private:

    int length;
    T *data;

public:

    ArrayTemplate(): length(0), data(nullptr) {
    //Пустой массив
    }

    ArrayTemplate(int l): length(l) {

        assert(l >= 0);
        if (l > 0) {
            //Выделяем память для заданной длины массива
            data = new T[l];

        } else {

            data = nullptr;

        }

    }

    ~ArrayTemplate() {
            //Очищаем память
        delete[] data;

    }

    void erase() {  //Метод - аналог clear
        //Проверка на нулевой указатель
        memset(data, 0, length * sizeof(T));
        if(data == nullptr) delete[] data;
        data = nullptr;
        length = 0;

    }

    T size() {    //Длина вектора

        return length;

    }

    T& operator[] (int index) {   //Перегрузка индексации
    //Ссылка на элемент, чтобы можно было изменять значения
        assert(index >= 0 && index < length);
        return data[index];

    }

    void resize(int newLength) {

        if (length == newLength) return;    //Проверка на равенство длины

        if (newLength <= 0) {       //Проверка на нулевую длину

            erase();
            return;

        }

        T *d = new T[newLength];    //Создаем новый массив
        memset(d, 0, newLength * sizeof(T));    //Обнуляем ячейки памяти

        if (length > 0) {

            int elements = (newLength > length) ? length : newLength;
                //Копируем все элементы в новый массив
            for (int index = 0; index < elements; ++index) {

                d[index] = data[index];

            }

        }

        delete[] data;  //Удаляем старый массив
        data = d;
        length = newLength;

    }

    void insertBefore(T value, int index) {
            //Метод для вставки элемента в заданную позицию
        assert(index >= 0 && index <= length);
        T *d = new T[length + 1]; //Создаем массив больше старого на элемент
        memset(d, 0, (length + 1) * sizeof(T));

            for (int i = 0; i < index; ++i) {
                    //Копируем все элементы до заданной позиции
                d[i] = data[i];

            }

        d[index] = value;   //Вставляем новый элемент

            for(int i = index; i < length; ++i) {
                //Вставляем остальные элементы
                d[i + 1] = data[i];

            }

        //assert(data != nullptr);      Вызовет исключение, если указатель = нулю
        if(data != nullptr) delete[] data;  //Удаляем старый массив
        data = d;
        ++length;

    }

    void push_back(T value) { //На основе метода реализуем аналог push_back

        insertBefore(value, length);

    }

    void removeBefore(int index) {  //Аналогично реализуем удаление элемента

        assert(index >= 0 && index < length);
        if(length <= 0) return;

        if(length == 1) {

            erase();
            return;

        } else {


            T *d = new T[length - 1];
            memset(d, 0, (length - 1) * sizeof(T));

                for(int i = 0; i < index; i++) {

                    d[i] = data[i];

                }

                for(int i = index; i < length - 1; ++i) {

                    d[i] = data[i + 1];

                }

            delete[] data;
            data = d;
            --length;

        }

    }

    void pop_back() {

        removeBefore(length - 1);

    }

    void insertArray(T array[], int index, int quantity) {
        //Добавляем массив аналогично элементу
        assert(index >= 0 && index <= length);
        assert(quantity >= 0);
        T *d = new T[length + quantity];
        memset(d, 0, (length + quantity) * sizeof(T));
            //Заполняем элементами до позиции
            for(int i = 0; i < index; ++i) {

                d[i] = data[i];

            }
            //Заполняем элементами массива
            for(int i = 0; i < quantity; ++i) {

                d[i + index] = array[i];

            }
            //Заполняем оставшимися элементами после массива
            for(int i = index + quantity; i < length + quantity; ++i) {

                d[i] = data[i - quantity];

            }

        if(data != nullptr) delete[] data;
        data = d;
        length += quantity;

    }

    void removeArray(int index, int quantity) {
        //Убираем элементы из массива
        assert(index >= 0 && index < length);
        assert(quantity > 0 && quantity <= length - index);

        if(length <= 0) return;

        if(length <= quantity) {

            erase();
            return;

        } else {

            T *d = new T[length - quantity];
            memset(d, 0, (length - quantity) * sizeof(T));
                //Заполняем элементами до позиции
                for(int i = 0; i < index; ++i) {

                    d[i] = data[i];

                }
                //Заполняем оставшимися элементами
                for(int i = index; i < length - quantity; ++i) {

                    d[i] = data[i + quantity];

                }

            delete[] data;
            data = d;
            length -= quantity;

        }

    }

    T begin() {

        assert(data != nullptr);
        T c = data[0];

            for(int i = 0; i < length; ++i) {

                if(c > data[i]) {

                    c = data[i];

                }

            }

        return c;

    }

    T end() {

        assert(data != nullptr);
        T c = data[0];

            for(int i = 0; i < length; ++i) {

                if(c < data[i]) {

                    c = data[i];

                }

            }

        return c;

    }

    void sort(T begin, T end) {

        if(data == nullptr) return;

        if (begin >= end) {

            for(int i = 1; i < length; ++i) {

                for(int r = 0; r < length - i; r++) {

                    if(data[r] < data[r + 1]) {

                        int temp = data[r];

                            data[r] = data[r + 1];
                            data[r + 1] = temp;

                    }

                }

            }

        } else if(begin < end) {

            for(int i = 1; i < length; ++i) {

                for(int r = 0; r < length - i; r++) {

                    if(data[r] > data[r + 1]) {

                        int temp = data[r];

                            data[r] = data[r + 1];
                            data[r + 1] = temp;

                    }

                }

            }

        }

    }

};

int main() {

    ArrayTemplate<int> arr;
    for(int i = 1; i <= 10; i++) {

        arr.push_back(i * 3 / 2);   //Заполняем массив

    }

    cout << "Pushback:      ";
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";  //Выводим массив

    }

    cout << endl << "Resize:        ";
    arr.resize(7);
    arr.resize(12);
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    cout << endl << "InsertBefore:  ";
    arr.insertBefore(99, 3);     //Добавим 99 в позицию 4
    arr.insertBefore(99, 11);
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    cout << endl << "RemoveBefore:  ";
    arr.removeBefore(0);       //Уберем элемент с позиции 1
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    cout << endl << "Popback:       ";
    arr.pop_back();       //Уберем элемент с конца массива
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    int A[5] = {111, 122, 133, 144, 155};

    cout << endl << "InsertArray:   ";
    arr.insertArray(A, 0, 3);   //Вставим 3 элементов массива, начиная с позиции 1
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    cout << endl << "RemoveArray:   ";
    arr.removeArray(2, 7);   //Уберем 7 элементов массива, начиная с позиции 3
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    cout << endl << "ArraySortUp:   ";  //Отсортируем по возрастанию
    arr.sort(arr.begin(), arr.end());
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    cout << endl << "ArraySortDown: ";  //Отсортируем по убыванию
    arr.sort(arr.end(), arr.begin());
    for(int i = 0; i < arr.size(); i++) {

        cout << arr[i] << " ";

    }

    arr.erase();
    cout << endl << "Erase. Size:   " << arr.size() << endl;

return 0;
}
