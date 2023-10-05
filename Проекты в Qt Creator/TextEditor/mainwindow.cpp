#include "mainwindow.h"
#include "ui_mainwindow.h"

//1. Написать программу "Текстовый редактор", используя виджет QTextEdit,
//с возможностью отмены изменений. Информацию об изменениях хранить в
//контейнере (например, в QStack). Постарайтейсь не использовать встроенные
//возможности виджета, а именно методы redo(), undo().
//2. Добаить в Текстовый редактор файл описания. Текстовый файл с описанием
//разместить в ресурсах программы. Для вызова описания разместить на
//форме соответствующую кнопку (о программе).
//3. Добавить в Текстовый редактор возможность открывать текстовые файлы
//(с расширением .txt).
//4. Добавить в Текстовый редактор возможность сохранить содержимое текстового поля.
//Если оно сохраняется в бинарный файл, сохранять имя автора, разместив поле
//QLineEdit, а если в тестовом виде - запись в этом поле игнорировать.


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_textEdit_textChanged()
{
    QString txt = ui->textEdit->toPlainText();
    U_R.index = ui->textEdit->textCursor().columnNumber();
    //U_R.value = txt.at();
    undo.push(U_R);
}

void MainWindow::on_undo_button_clicked()
{
    QString txt = ui->textEdit->toPlainText();
    txt.remove(undo.top().index - 1, 1);
    undo.pop();
    //
//    //ui->label->setText(QString::number(ui->textEdit->textCursor().columnNumber()));
//    ui->label->clear();
//    //ui->label->setText(txt);
    ui->label->setText(undo.top().value + " " + QString::number(undo.top().index));
ui->textEdit->setPlainText(txt);
}

void MainWindow::on_redo_button_clicked()
{

}

void MainWindow::on_open_button_clicked()
{

}

void MainWindow::on_save_button_clicked()
{

}

void MainWindow::on_about_button_clicked()
{

}
