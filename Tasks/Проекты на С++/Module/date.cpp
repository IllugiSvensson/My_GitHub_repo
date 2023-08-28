#include "date.hpp"
#include "globals.hpp"

int Date::number = 0;

Date::Date(): day(dayDefault) {

    ++number;

}

Date::~Date() {

    --number;

}

void Date::changeDay(int arg) {

    day = arg;

}

int Date::get_day() const {

    return day;

}

int Date::get_number() const {

    return number;

}
