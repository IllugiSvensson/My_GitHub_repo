#include <iostream>
using namespace std;

template <int x>
class Bar {
public:

    static const int value = x * Bar<x - 1>::value;

};
template <>
class Bar<1> {
public:

    static const int value = 1;

};

int main() {
	//Рекурсивно вычисляем факториал, используя специализацию шаблона класса
    int value = Bar<5>::value;
    cout << value << endl;

return 0;
}
