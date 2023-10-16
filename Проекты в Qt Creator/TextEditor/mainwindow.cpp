#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <iostream>
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
    previous_len = 0;
    previous_txt = "";
    ui->undo_button->setDisabled(1);
    ui->redo_button->setDisabled(1);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_textEdit_textChanged()
{
    QString txt = ui->textEdit->toPlainText();
    qint32 current_pos = ui->textEdit->textCursor().position();
    qint32 current_len = txt.length();
    if (current_pos && (current_len > previous_len))
    {
        U_R.index = current_pos - (current_len - previous_len);
        U_R.value = txt.mid(U_R.index, current_len - previous_len);
        undo.push(U_R);
        if (!redo.isEmpty())
        {
            ui->redo_button->setDisabled(1);
            redo.clear();
        }
        if (!undo.isEmpty()) ui->undo_button->setDisabled(0);
    }
    else if (current_pos && (current_len < previous_len))
    {
        U_R.index = current_pos;
        U_R.value = previous_txt.mid(U_R.index, previous_txt.length() - current_len);
        redo.push(U_R);
        for (qint32 i = 0; i < U_R.value.length(); i++) undo.pop();
        if (!redo.isEmpty()) ui->redo_button->setDisabled(0);
        if (!undo.isEmpty()) ui->undo_button->setDisabled(1);
    }
//    else if (!current_pos && !current_len)
//    {
//        U_R.index = 0;
//        U_R.value = previous_txt.mid(0, previous_len);
//        undo.push(U_R);
//        if (!redo.isEmpty())
//        {
//            ui->redo_button->setDisabled(1);
//            redo.clear();
//        }
//        if (!undo.isEmpty()) ui->undo_button->setDisabled(0);
//    }
    previous_len = current_len;
    previous_txt = txt;
}

void MainWindow::on_undo_button_clicked()
{
    undo_redo tmp = undo.pop();
    previous_txt.remove(tmp.index, tmp.value.length());
    ui->textEdit->setText(previous_txt);
    redo.push(tmp);
    if (undo.isEmpty()) ui->undo_button->setDisabled(1);
    if (!redo.isEmpty()) ui->redo_button->setDisabled(0);
}

void MainWindow::on_redo_button_clicked()
{
    undo_redo tmp = redo.pop();
    previous_txt.insert(tmp.index, tmp.value);
    ui->textEdit->setText(previous_txt);
    undo.push(tmp);
    if (redo.isEmpty()) ui->redo_button->setDisabled(1);
    if (!undo.isEmpty()) ui->undo_button->setDisabled(0);
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
