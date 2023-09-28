#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
    , nextPicButton(nullptr), prevPicButton(nullptr) {

    ui->setupUi(this);

    QSharedPointer<MyClass> smartP (new MyClass(10));
    int x = smartP->getValue();
    MyClass* p = smartP.get();

        curPicture = 0;
        setPicture();
        nextPicButton = new QPushButton(this);
        prevPicButton = new QPushButton(this);
        nextPicButton->move(400 - 150, 350);
        prevPicButton->move(50, 350);
        nextPicButton->setText(tr("Next"));
        prevPicButton->setText(tr("Prev"));

    connect(this, SIGNAL(doIt(QString)), this, SLOT(slot(QString)));
    connect(prevPicButton, SIGNAL(clicked()), this, SLOT(prevPicture()));
    connect(nextPicButton, SIGNAL(clicked()), this, SLOT(nextPicture()));
    connect(this, SIGNAL(switchNextPicture()), SLOT(nextPicture()));
    connect(this, SIGNAL(switchPrevPicture()), SLOT(prevPicture()));

    // Инициализациия класса-фильтра
       replaceMouseButtons = QSharedPointer<KeyPressEvent>::create(this);
    // Метод ::create аналогичен new Class (Class указан в объявление <Class>)
    // В нашем случаи Class = KeyPressEvent
       nextPicButton->installEventFilter(replaceMouseButtons.get());
    // ::get() возвращаент ссылку на наш объект
       prevPicButton->installEventFilter(replaceMouseButtons.get());

}

MainWindow::~MainWindow() {

    delete ui;

}

void MainWindow::SendSignal() {

    emit doIt(tr("Hello"));

}

void MainWindow::on_pushButton_clicked() {

    SendSignal();

}

void MainWindow::slot(QString str) {

    ui->lineEdit->setText(str);

}

void MainWindow::setPicture() {

    QPixmap pix(picturelist.at(curPicture));
    QPalette pallete;
    pix = pix.scaled(280, 210, Qt::IgnoreAspectRatio);
    ui->label->setPixmap(pix);

}

void MainWindow::nextPicture() {

    curPicture++;
    if (curPicture > 2) curPicture = 2;
    setPicture();

}

void MainWindow::prevPicture() {

    if (curPicture > 0) curPicture--;
    setPicture();

}

void MainWindow::keyReleaseEvent(QKeyEvent *event) {

    if (event->key() == Qt::Key_Left) {

        emit switchNextPicture();

    } else if(event->key() == Qt::Key_Right) {

        emit switchPrevPicture();

    }

}

void MainWindow::mousePressEvent(QMouseEvent *event) {

    positionX = event->x();

}

void MainWindow::mouseReleaseEvent(QMouseEvent *event) {

    int x = event->x();
    if (x - positionX > 0) {

        emit switchNextPicture();

    } else if (x - positionX < 0) {

        emit switchPrevPicture();
    }

}
