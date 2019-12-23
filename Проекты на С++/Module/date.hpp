#ifndef __Date_H__
#define __Date_H__

class Date {
private:
    int day;
    static int number;  //Общий член для всех экземпляров класса

public:

    Date();
    ~Date();

    void changeDay(int arg);
    int get_day() const;
    int get_number() const;

};

#endif // __Date_H__
