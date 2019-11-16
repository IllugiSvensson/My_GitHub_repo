#include <iostream>
using namespace std;

class Time {
public:

    Time()  {

        cout << "Construct Time class" << endl;

    }

    ~Time()  {

        cout << "Destruct Time class" << endl;

    }

};

class Date {        //������ ������� �� ���������
private:            //������ ����� ������ ����� ������

    int m_day;      //m_day = 1; ����������� �� ��������� �������� ��������
    int m_month;    //���� �� ����� ������� ������������ ���� �� ����������
    int m_year;
    Time m_time;

public:             //������ ����� ����� ������

    Date() {        //���������� �� ���������

        cout << "Construct Date class" << endl;

    }

    Date(int d, int m, int y = 2000) : m_day(d), m_month(m), m_year(y)  { //������ �������������
        //�������� �������������� ����������-����� ������
    }

    void setDate(int day, int month, int year)  {
        //����� �������� �������� ������
        m_day = day;
        m_month = month;
        m_year = year;

    }

    int getDay()  {

        return m_day;

    }

    const int &getYear()  {     //����������� �������� �� ����������� ������ ��������

        return m_year;

    }

    void print()  {

        cout << m_day << "/" << m_month << "/" << m_year << endl;

    }

    void copyFrom(const Date &b)  {	//����� ������ ������ � �������� ������ ������� b

        m_day = b.m_day;
        m_month = b.m_month;
        m_year = b.m_year;

    }

    ~Date() {

        cout << "Destruct Date class" << endl;

    }

};

int main()  {

    Date today; //today(1, 1); ���� ��� ����������, �� ��������� ����������� �� ���������

        today.setDate(12, 12, 2018);
        cout << today.getYear() << endl;

    Date copy;

        copy.copyFrom(today);
        copy.print();
        	//������������ � ����������� ����������� �� �������� �����
return 0;
}
