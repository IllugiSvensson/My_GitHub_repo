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
//QLineEdit, а если в текстовом виде - запись в этом поле игнорировать.


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    previous_len = 0;
    previous_txt = "";
    latch = 0;
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
    if (!latch)
    {
        if (current_pos && (current_len > previous_len))
        {
            U_R.index = current_pos - (current_len - previous_len);
            U_R.value = txt.mid(U_R.index, current_len - previous_len);
            U_R.direct = 1;
            undo.push(U_R);
            if (!undo.isEmpty()) ui->undo_button->setDisabled(0);
            if (!redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                redo.clear();
            }
        }
        else if (current_pos >= 0 && (current_len < previous_len))
        {
            U_R.index = current_pos;
            U_R.value = previous_txt.mid(U_R.index, previous_txt.length() - current_len);
            U_R.direct = 0;
            undo.push(U_R);
            if (!redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                redo.clear();
            }
        }
        else if (!current_pos && !current_len && previous_txt.length())
        {
            U_R.index = 0;
            U_R.value = previous_txt.mid(U_R.index, previous_txt.length());
            U_R.direct = 0;
            undo.push(U_R);
            if (!redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                redo.clear();
            }
        }
        previous_len = current_len;
        previous_txt = txt;
    }
    else latch = 0;
}

void MainWindow::on_undo_button_clicked()
{
    undo_redo tmp = undo.pop();
    latch = 1;
    if (tmp.direct)
    {
        previous_txt.remove(tmp.index, tmp.value.length());
        ui->textEdit->setText(previous_txt);
    }
    else
    {
        previous_txt.insert(tmp.index, tmp.value);
        ui->textEdit->setText(previous_txt);
    }
    redo.push(tmp);
    if (undo.isEmpty()) ui->undo_button->setDisabled(1);
    if (!redo.isEmpty()) ui->redo_button->setDisabled(0);
}

void MainWindow::on_redo_button_clicked()
{
    undo_redo tmp = redo.pop();
    latch = 1;
    if (tmp.direct)
    {
        previous_txt.insert(tmp.index, tmp.value);
        ui->textEdit->setText(previous_txt);
    }
    else
    {
        previous_txt.remove(tmp.index, tmp.value.length());
        ui->textEdit->setText(previous_txt);
    }
    undo.push(tmp);
    if (redo.isEmpty()) ui->redo_button->setDisabled(1);
    if (!undo.isEmpty()) ui->undo_button->setDisabled(0);
}

void MainWindow::on_open_button_clicked()
{
    QString s = QFileDialog::getOpenFileName(this,"Открыть файл",
    QDir::current().path(), tr("Текстовый файл(*.txt)"));
    QFile file(s);
    if (file.open(QFile::ReadOnly | QFile::ExistingOnly))
    {
        QTextStream stream(&file);
        ui->textEdit->setPlainText(stream.readAll());
        undo.clear();
        redo.clear();
        ui->redo_button->setDisabled(1);
        ui->undo_button->setDisabled(1);
        file.close();
    }
}

void MainWindow::on_save_button_clicked()
{
    QString s = QFileDialog::getSaveFileName(this, "Сохранить файл",
    QDir::current().path(), tr("Текстовый файл(*.txt);;Двоичный файл(*.original)"));
    int index = s.indexOf(".txt");
    QFile file(s);
    if (file.open(QFile::WriteOnly))
    {
        if (index != -1)
        {
            QTextStream stream(&file);
            stream << ui->textEdit->toPlainText();
        }
        else
        {
            QDataStream stream(&file);
            stream << ui->author_lineEdit->text() << " ";
            stream << ui->textEdit->toPlainText();
        }
        file.close();
    }
}

void MainWindow::on_about_button_clicked()
{
    QFile file(":/.txt/about.txt");
    if (file.open(QFile::ReadOnly | QFile::ExistingOnly))
    {
        QTextStream stream(&file);
        QMessageBox::information(this, "О программе", stream.readAll());
        file.close();
    }
    else
    {
        QMessageBox::warning(this, "О программе", "Файл описания не найден!");
    }
}
