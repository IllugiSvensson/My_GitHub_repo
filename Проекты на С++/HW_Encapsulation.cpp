#include <iostream>
#include <cmath>
using namespace std;

//������� ����� Power, ������� �������� ��� ������������ �����.
//���� ����� ������ ����� ��� ����������-����� ��� �������� ���� ������������ �����.
//��� ������� ��� ������: ���� � ������ set, ������� �������� ����������� �������� ����������,
//������ � calculate, ������� ����� �������� ��������� ���������� ������� ����� � ������� �������
//�����. ������ �������� ���� ���� ����� �� ���������.
class Power {
private:

    float A = 1;
    float B = 1;

public:

    Power ()  {     //����������� �� ��������� ����������������� ����������

    }

    void set(float a, float b) {

        A = a;
        B = b;

    }

    void calculate() {

        cout << "A ^ B = " << pow(A, B) << endl;

    }

};

//�������� ����� � ������ RGBA, ������� �������� 4 ����������-����� ����
//std::uint8_t: m_red, m_green, m_blue � m_alpha (#include cstdint ��� ������� � ����� ����).
//������ 0 � �������� �������� �� ��������� ��� m_red, m_green, m_blue � 255 ��� m_alpha.
//������� ����������� �� ������� ������������� ������, ������� �������� ������������
//���������� �������� ��� m_red, m_blue, m_green � m_alpha. �������� ������� print(),
//������� ����� �������� �������� ����������-������.
class RGBA {
private:

    uint8_t m_red;
    uint8_t m_green;
    uint8_t m_blue;
    uint8_t m_alpha;

public:
                            //���������� ����������� �� ������� �������������
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

//�������� �����, ������� ��������� ���������������� �����. ����� Stack ������ �����:
//private-������ ����� ����� ������ 10;
//private ������������� �������� ��� ������������ ����� �����;
//public-����� � ������ reset(), ������� ����� ���������� ����� � ��� �������� ��������� �� 0;
//public-����� � ������ push(), ������� ����� ��������� �������� � ����.
//public-����� � ������ pop() ��� ����������� � �������� �������� �� �����. ���� � ����� ��� ��������,
//�� ������ ���������� ��������������;
//public-����� � ������ print(), ������� ����� �������� ��� �������� �����.
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

            array[track] = data;    //��������� ������
            track++;                        //�������� ������

        } else

            cout << "Stack is full" << endl;

    }

    int pop() {

        int arr = NULL;
        if(track > 0) {

            arr = array[track];     //�������� �������� �� �������
            track--;                        //�������� ������

        } else {

            cout << "Stack is empty" << endl;

        }

    return arr;
    }

    void print() {

    cout << "(";

        for(int i = 0; i < track; i++) {    //������� ����������� ���������� ���������

            cout << array[i] << " ";

        }

    cout << ")" << endl;

    }

};

int main() {

    Power pw;
    float a, b;
        cout << "������� ����� ��� ���������� � �������: ";
        cin >> a;
        cout << "������� �������: ";
        cin >> b;

            pw.set(a, b);
            pw.calculate();
            cout << endl;

    uint8_t r, g, bl, al;
        cout << "������� �������� ������� ������������: ";
        cin >> r;
        cout << "������� �������� ������� ������������: ";
        cin >> g;
        cout << "������� �������� ����� ������������: ";
        cin >> bl;
        cout << "������� �������� �����: ";
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
