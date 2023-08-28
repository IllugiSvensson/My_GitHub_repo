#include "mainwindow.h"
#include "ui_mainwindow.h"

//Создать программу, разместить на поле виджет QPlainTextEdit. Добавить кнопки: для добавления фиксированной строки,
//замены на готовый текст. Разместить QTextEdit. Через метод setHtml(QString) установите текст произвольного html-кода,
//например <font color='red'>Hello</font>.


//Получите QTextDocument из виджета QTextEdit (метод document). С помощью списка методов и переменных выберите, какие наиболее интересны для редактирования текста. Ознакомьтесь с работой подсказчика кода Qt Creator (Ctrl+Space).

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->Html_space->setText("<H1>Шрифтовое выделение фрагментов текста</H1>"
                            "<P>Теперь мы знаем, что фрагменты текста можно выделять "
                            "<B>жирным</B> или <I>наклонным</I> шрифтом. "
                            "Кроме того, можно включать в текст фрагменты с фиксированной шириной символа"
                            "<TT>(имитация пишущей машинки)</TT></P>"
                            "<P>Кроме того, существует ряд логических стилей:</P>"
                            "<P><EM>EM - от английского emphasis - акцент </EM><BR>"
                            "<STRONG>STRONG - от английского strong emphasis -"
                            "сильный акцент </STRONG><BR>"
                            "<CODE>CODE - для фрагментов"
                            "исходных текстов</CODE><BR>"
                            "<SAMP>SAMP - от английского sample -"
                            "образец </SAMP><BR>"
                            "<KBD>KBD - от английского keyboard -"
                            "клавиатура</KBD><BR>"
                            "<VAR>VAR - от английского variable -"
                            "переменная </VAR></P>");

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_calcButton_clicked() {

    QString coef_a;
    QString coef_b;
    QString coef_c;
    qreal D, x1, x2;

        coef_a = ui->Coef_a->text();        //Вынем коэффициенты из полей
        coef_b = ui->Coef_b->text();        //в переменные
        coef_c = ui->Coef_c->text();

    qreal a = coef_a.toDouble();            //Преобразуем переменные в действительные
    qreal b = coef_b.toDouble();
    qreal c = coef_c.toDouble();

        D = qPow(b, 2) - (4 * a * c);       //Считаем дискриминант

        if (a == 0) {                       //Случай неквадратного уравнения

            x1 = -c / b;
            ui->ResultLine->setText(QString("Not a square equation, root: x = %1").arg(QString::number(x1, 'f', 2)));

        } else if (D > 0) {                 //Дискриминант больше нуля

            x1 = (-b + qSqrt(D)) / (2 * a);
            x2 = (-b - qSqrt(D)) / (2 * a);
            ui->ResultLine->setText(QString("Two roots: x1 = %1, x2 = %2").arg(QString::number(x1, 'f', 2)).arg(QString::number(x2, 'f', 2)));

        } else if (D == 0) {                //Дискриминант равен нулю

            x1 = -b / (2 * a);
            ui->ResultLine->setText(QString("One root: x = %1").arg(QString::number(x1, 'f', 2)));

        } else if (D < 0) {

            qreal real;
            qreal image;

                real = -b / (2 * a);
                image = qSqrt(qAbs(D)) / (2 * a);
                ui->ResultLine->setText(QString("Complex roots: real = %1, image = (+-) %2i").arg(QString::number(real, 'f', 2))
                                        .arg(QString::number(image, 'f', 2)));

        }

}

void MainWindow::on_AngleButton_clicked() {

    QString Side_a = ui->Side_A->text();
    QString Side_b = ui->Side_B->text();
    QString angle = ui->Angle->text();
    qreal A = Side_a.toDouble();
    qreal B = Side_b.toDouble();
    qreal Ang = angle.toDouble();
    qreal C;

    if (ui->Degrees->isChecked()) {

        Ang = qDegreesToRadians(Ang);

    }

    if(Ang >= (M_PI)) {

        ui->Side_C->setText("Wrong Angle. Set the angle in [0, 180] or [0, Pi]");

    } else {

        C = qSqrt(qPow(A, 2) + qPow(B, 2) - (2 * A * B) * qCos(qAbs(Ang)));
        ui->Side_C->setText(QString("Side C is %1").arg(QString::number(C)));

    }

}

void MainWindow::on_fixed_string_clicked() {

    QString fixed_sring = "Фиксированная строка\n";
    ui->testing_space->insertPlainText(fixed_sring);

}

void MainWindow::on_simple_text_clicked() {

    QString simple_text = "У Лукоморья дуб зеленый\n"
                          "Златая цепь на дубе том\n"
                          "И днем и ночью кот ученый\n"
                          "Все ходит по цепи кругом\n";
    ui->testing_space->setPlainText(simple_text);

}

void MainWindow::on_transform_clicked() {

    qint32 decimal = ui->dec_space->text().toInt();
    qint32 base = 2;

        if(ui->oct_but->isChecked()) {

            base = 8;

        } else if (ui->hex_but->isChecked()) {

            base = 16;

        }

    ui->Transformed->setText(QString::number(decimal, base));

}
