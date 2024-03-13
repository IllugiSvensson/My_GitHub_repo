#include "finddialog.h"

finddialog::finddialog(QWidget* parent) : QDialog(parent),
    textEdit(nullptr), layout(nullptr)
{
    setWindowTitle(tr("Find"));
    setFixedSize(600, 100);
    layout = new QGridLayout();
    setLayout(layout);
    label = new QLabel(this);
    label->setText(tr("Find string"));
    layout->addWidget(label, 1, 1, 1, 4);
    lineEdit = new QLineEdit(this);
    layout->addWidget(lineEdit, 2, 1, 1, 7);
    findButtons[0] = new QPushButton(this);
    findButtons[1] = new QPushButton(this);
    findButtons[0]->setText(tr("Find previous"));
    findButtons[1]->setText(tr("Find next"));
    connect(findButtons[0], SIGNAL(clicked()), this, SLOT(findPrev()));
    connect(findButtons[1], SIGNAL(clicked()), this, SLOT(findNext()));
    layout->addWidget(findButtons[0], 4, 1, 1, 3);
    layout->addWidget(findButtons[1], 4, 5, 1, 3);
}

finddialog::~finddialog()
{}

void finddialog::setTextEdit(QTextEdit *textEdit)
{
    this->textEdit = textEdit;
}
void finddialog::findPrev()
{
    QString str = lineEdit->text();
    int pos = textEdit->textCursor().position();
    QString txt = textEdit->toPlainText();
    QString p = txt.mid(0, pos);
    int last = -1;
    int ps = 0;
    for (bool b = true;b;)
    {
        int index = p.indexOf(str, ps);
        if (index == -1) b = false;
        else {
            last = index;
            ps = index + str.length();
        }
    }
    close();
    if (last != -1)
    {
        emit setCursorPos(last, str.length(), last);
    }
}

void finddialog::findNext()
{
    QString str = lineEdit->text();
    QString txt = textEdit->toPlainText();
    int pos = textEdit->textCursor().position();
    int index = txt.indexOf(str, pos);
    close();
    if (index != -1) {
        emit setCursorPos(index, str.length(), str.length() + index);
    }
}
