#ifndef PARSETEXT_H
#define PARSETEXT_H
#include <QString>


class ParseText {
public:

    ParseText(QString);
    double parse();
    QString getSpecial();

private:

    QString str;
    double term (QString str, quint32 &index);
    double number(QString str, quint32 &index);

};

#endif // PARSETEXT_H
