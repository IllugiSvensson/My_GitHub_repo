#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    tEdit = new QTextEdit(this);
    tEdit->setGeometry(300, 300, 200, 300);
    //setCentralWidget(tEdit);
    QToolBar *tBar = addToolBar("Formated");
    QMenu *menu = new QMenu(this);
    QAction *action = menu->addAction(tr("Random size of font"));
    connect(action, SIGNAL(triggered()), this, SLOT(randomSizeOfFont()));
    action = menu->addAction(tr("set font"));
    connect(action, SIGNAL(triggered()), this, SLOT(setFont()));
    action = menu->addAction(tr("convert to HTML"));
    connect(action, SIGNAL(triggered()), this, SLOT(convertToHTML()));
    action = menu->addAction(tr("convert from HTML"));
    connect(action, SIGNAL(triggered()), this, SLOT(convertFromHTML()));
    QPushButton *button = new QPushButton(tr("Formated menu"), this);
    tBar->addWidget(button);
    button->setMenu(menu);
    srand(clock());

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::paintEvent(QPaintEvent *event)
{
    QPainter painter(this);
    painter.drawPoint(50, 50);
    QPoint thPoint(50, 50);
    painter.drawPoint(thPoint);
    QPointF thPointf(50., 50.);
    painter.drawPoint(thPointf);

    painter.drawLine(0,0, 100, 100);
    QPoint p1 (0,0);
    QPoint p2 (100,100);
    painter.drawLine(p1,p2);
    QLineF line(0,0,100,100);
    painter.drawLine(line);

    painter.drawRect(QRect(0,0,100,100));
    painter.drawRect(0, 20, 50, 50);
    painter.drawRect(QRectF(100, 120, 200, 200));

    QPolygon polygon;
    polygon << QPoint(0, height() - 10);
    polygon << QPoint(width() >> 1, 0);
    polygon << QPoint(width(), height() - 5);
    painter.drawPolygon(polygon);
    QPointF points[] = {
    QPointF(0,0),
    QPointF(0,height() >> 1),
    QPointF(width() >> 1, height() >> 2),
    QPointF(width(),height()),
    QPointF(0,height()),
    };
    painter.drawPolygon(points, sizeof(points) / sizeof(points[0]));

    painter.drawEllipse(50, 50, 50, 50);
    painter.drawEllipse(QRectF(50.0, 50.0, 50.0, 50.0));
    painter.drawEllipse(QRect(50, 50, 50, 50));
    painter.drawEllipse(QPoint(50,50), 50, 50);
    painter.drawEllipse(QPointF(50.0,50.0), 50.0, 50.0);

    int h = height() / 3;
    painter.drawRect(5, h, width() - 10, height() - h - 10);
    int w = width() >> 1;
    polygon << QPoint(w, 5);
    polygon << QPoint(5, h);
    polygon << QPoint(width() - 5, h);
    painter.drawPolygon(polygon);
    h = height() >> 1;
    painter.drawRect(w - 50, h, 100, 100);
    painter.drawLine(w, h, w, h + 100);

    QBrush br(QColor(5, 255, 0));
    br.setStyle(Qt::BrushStyle::VerPattern);
    painter.setBrush(br);
    painter.drawRect(5, h, width() - 10, height() - h - 10);
    w = width() >> 1;
    QPen pen(QColor(0, 0, 250));
    pen.setStyle(Qt::PenStyle::DashLine);
    painter.setPen(pen);
    h = height() >> 1;
    painter.drawRect(w - 50, h, 100, 100);
    painter.drawLine(w, h, w, h + 100);
    painter.end();
}

void MainWindow::randomSizeOfFont()
{
    QTextCharFormat fmt;
    fmt.setForeground(QBrush(QColor(rand() %256, rand()%256, rand()%256)));
    fmt.setBackground(QBrush(QColor(rand() %256, rand()%256, rand()%256)));
    tEdit->textCursor().setCharFormat(fmt);
}

void MainWindow::setFont()
{
    QFont font = tEdit->textCursor().charFormat().font();
    QFontDialog fntDlg(font, this);

    bool b[] = {true};
    font = fntDlg.getFont(b);
    if (b[0])
    {
        QTextCharFormat fmt = tEdit->textCursor().charFormat();
        fmt.setFont(font);
        tEdit->textCursor().setCharFormat(fmt);
    }
}

void MainWindow::convertToHTML()
{
    QString str = tEdit->document()->toHtml();
    tEdit->document()->setPlainText(str);
}

void MainWindow::convertFromHTML()
{
    QString str = tEdit->document()->toPlainText();
    tEdit->document()->setHtml(str);
}
