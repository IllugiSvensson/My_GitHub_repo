#include "widget.h"
#include <QFile>
#include <QFileDialog>
#include <QtUiTools/QUiLoader>
#include <QLineEdit>
#include <QCommandLinkButton>

Widget::Widget(QWidget *parent) //Экземпляр класса созданной формы
    : QWidget(parent)
{
    uiForm = new Ui_Form();
    uiForm->setupUi(this);
    connect(uiForm->pushButton, SIGNAL(clicked()), this, SLOT(openXMLForm()));
}


Widget::~Widget()
{
    delete uiForm;
}


void Widget::openXMLForm() //Построим форму из содержимого файла
{
    QFile file("/home/woljin1/Projects/Cpp_Prj/WidgetXML.ui");
    if (file.open(QIODevice::ReadOnly)) {

        QUiLoader loader;
        QWidget *w = loader.load(&file);
        w->show();
        file.close();
        QLineEdit *le = w->findChild<QLineEdit*>("lineEdit");
        QCommandLinkButton *clb = w->findChild<QCommandLinkButton*>("commandLinkButton");
        le->setText("Меняем текст");
        clb->setText("Другое действие");

    }
}
