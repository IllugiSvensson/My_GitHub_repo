#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    mdiArea = new QMdiArea(this);
    QWidget *centralW = new QWidget(this);
    setCentralWidget(centralW);
    QGridLayout *lay = new QGridLayout(this);
    centralW->setLayout(lay);
    lay->addWidget(mdiArea, 1, 0, 10, 1);
    mdiArea->addSubWindow(new QTextEdit(this));
    mdiArea->addSubWindow(new RusContext(this));
    QPushButton *button = new QPushButton("button", this);
    lay->addWidget(button, 0, 0, 1, 1);
    connect(button, SIGNAL(clicked()), this, SLOT(printToField()));
    curEdit = new QTextEdit(this);
    lay->addWidget(curEdit, 0, 5, 1, 5);

    QToolBar* tbar = addToolBar("TB");
    QAction *act = tbar->addAction("print");
    connect(act, SIGNAL(triggered(bool)), this, SLOT(printToField()));

    QStatusBar *statusbar = this->statusBar();
    xlab = new QLabel(this);
    xlab->setText("X label");
    ylab = new QLabel(this);
    ylab->setText("Y label");
    progrBar = new QProgressBar(this);
    statusbar->addWidget(xlab);
    statusbar->addWidget(ylab);
    statusbar->addWidget(progrBar);
    progrBar->setValue(50);

    QMenu* fileMenu = menuBar()->addMenu("File");
    fileMenu->addAction("About", qApp, SLOT(aboutQt()), Qt::CTRL + Qt::Key_Q);
    QAction* checkabkeAction = fileMenu->addAction("check");
    checkabkeAction->setCheckable(true);
    fileMenu->addAction(QPixmap(":/new/prefix1/C++.png"), "picture");
    QMenu* subMenu = new QMenu("Sub", fileMenu);
    fileMenu->addMenu(subMenu);
    subMenu->addAction("1.1");
    QAction* disAct = fileMenu->addAction(("Disable"));
    disAct->setEnabled(false);
    fileMenu->addSeparator();
    fileMenu->addAction("Exit", qApp, SLOT(quit()));
    button->setMenu(fileMenu);
    QAction *find = fileMenu->addAction("Find");
    connect(find, SIGNAL(triggered(bool)), this, SLOT(findText()));
}

MainWindow::~MainWindow()
{
}

void MainWindow::printToField()
{
    //((QTextEdit*)mdiArea->activeSubWindow()->widget())->setText("Hello");
    QMdiSubWindow *activeSubWindow = mdiArea->activeSubWindow();
    QWidget *wgt = activeSubWindow->widget();
    QTextEdit * txt = (QTextEdit*)wgt;
    curEdit->setText(txt->toPlainText());

    QPrinter printer;
    QPrintDialog dlg(&printer, this);
    dlg.setWindowTitle("Print");
    if(dlg.exec() != QDialog::Accepted) return;
    curEdit->print(&printer);
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    QMessageBox msgBox(this);
    msgBox.setText("confirm");
    msgBox.setIcon(QMessageBox::Question);
    msgBox.addButton("Yes", QMessageBox::YesRole);
    msgBox.addButton("No", QMessageBox::NoRole);
    int result = msgBox.exec();
    if (result == 0)
        event->accept();
    else
        event->ignore();
}

void MainWindow::findText()
{
    if (!findDialog)
    {
        findDialog = QSharedPointer<finddialog>::create(this);
        findDialog->setTextEdit(curEdit);
        connect(findDialog.get(), SIGNAL(setCursorPos(int, int, int)), this,
        SLOT(setNewPosition(int, int, int)));
    }
    findDialog->exec();
}

void MainWindow::setNewPosition(int start, int lenght, int npos)
{
    QTextCursor tcursor = curEdit->textCursor();
    if (npos > start)
    {
        tcursor.setPosition(start, QTextCursor::MoveAnchor);
        tcursor.setPosition(npos, QTextCursor::KeepAnchor);
    }
    else
    {
        tcursor.setPosition(start + lenght, QTextCursor::MoveAnchor);
        tcursor.setPosition(start, QTextCursor::KeepAnchor);
    }
    curEdit->setTextCursor(tcursor);
}
