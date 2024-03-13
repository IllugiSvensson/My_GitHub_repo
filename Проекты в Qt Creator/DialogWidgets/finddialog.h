#ifndef FINDDIALOG_H
#define FINDDIALOG_H

#include <QDialog>
#include <QWidget>
#include <QTextEdit>
#include <QGridLayout>
#include <QLineEdit>
#include <QLabel>
#include <QPushButton>

class finddialog : public QDialog
{
    Q_OBJECT
    Q_PROPERTY(QTextEdit *textEdit WRITE setTextEdit)
public:
    explicit finddialog(QWidget *parent = nullptr);
    virtual ~finddialog();
    void setTextEdit(QTextEdit *);
signals:

public slots:
    void findPrev();
    void findNext();
private:
    QTextEdit *textEdit;
    QGridLayout *layout;
    QLabel *label;
    QLineEdit *lineEdit;
    QPushButton *findButtons[2];
signals:
    void setCursorPos(int, int, int);
};

#endif // FINDDIALOG_H
