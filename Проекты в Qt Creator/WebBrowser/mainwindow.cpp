#include "mainwindow.h"
#include <QToolBar>
#include <QFile>
#include <QFileDialog>
#include <QTextStream>
#include <QWebEnginePage>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    webView = new QWebEngineView(this);
    setCentralWidget(webView);
    QUrl q("https://geekbrains.ru/");
    webView->setUrl(q);
    QToolBar *tool = addToolBar("Web Navigation");
    menuButton = new QPushButton(tr("Menu"), this);
    tool->addWidget(menuButton);
    navigateEdit = new QLineEdit(this);
    tool->addWidget(navigateEdit);
    goButton = new QToolButton(this);
    goButton->setText(tr("Go"));
    tool->addWidget(goButton);
    connect(goButton, SIGNAL(clicked()), this, SLOT(goToUrl()));
    addFavorite = new QToolButton(this);
    viewFavorite = new QPushButton(this);
    addFavorite->setText(tr("Add to favorite"));
    viewFavorite->setText(tr("Favorites"));
    tool->addWidget(addFavorite);
    tool->addWidget(viewFavorite);
    connect(addFavorite, SIGNAL(clicked()), this, SLOT(addToFavorite()));
    listFav.clear();
    favList = new QMenu(this);
    viewFavorite->setMenu(favList);
    loadFavorites();
    addMainMenu();
}

void MainWindow::goToUrl()
{
    QString navTxt = navigateEdit->text();
    webView->setUrl(QUrl(navTxt));
}

void MainWindow::addToFavorite()
{
    QString txt = webView->url().toString();
    if (txt.length() == 0) return;
    QString title = webView->title();
    QFile file("./favlist.bin");
    if (file.open(QIODevice::Append))
    {
        QByteArray ar = txt.toUtf8();
        int length = ar.length();
        file.write((char*)&length, sizeof length);
        file.write(ar.data(),length);
        ar = title.toUtf8();
        length = ar.length();
        file.write((char*)&length, sizeof length);
        file.write(ar.data(),length);
        file.close();
        QString key = QString::number(listFav.count() + 1) + ". " + title;
        listFav[key] = txt;
        addToMenuFavorite(key);
    }
}

void MainWindow::addToMenuFavorite(QString& key)
{
    QAction *act = favList->addAction(key);
    connect(act, SIGNAL(triggered()), this, SLOT(openFavoritePage()));
}

void MainWindow::openFavoritePage()
{
    QAction *act = static_cast<QAction*>(sender());
    QString s = listFav[act->text()];
    webView->setUrl(QUrl(s));
}

void MainWindow::addMainMenu()
{
    QMenu *mainMenu = new QMenu(this);
    QAction *act = mainMenu->addAction(tr("Save Page as"));
    connect(act, SIGNAL(triggered()), this, SLOT(savePageAs()));
    act = mainMenu->addAction(tr("Quit"));
    connect(act, SIGNAL(triggered()), this, SLOT(close()));
    menuButton->setMenu(mainMenu);
}

void MainWindow::savePageAs()
{
    QString filename = QFileDialog::getSaveFileName(this, tr("Save this page"),
    QDir::home().path(),
    tr("Hyber text archive") +
    "(*.mht);;" + tr("All files") + "(*.*)");
    if (filename.length() == 0) return;
    webView->page()->save(filename);
}

void MainWindow::loadFavorites()
{
    QFile file("./favlist.txt");
    if (file.open(QIODevice::ReadOnly))
    {
        for(;!file.atEnd();)
        {
            int length = 0;
            file.read((char*)&length, sizeof length);
            QByteArray ar;
            ar.resize(length);
            file.read(ar.data(), length);
            QString url(ar);
            file.read((char*)&length, sizeof length);
            ar.resize(length);
            file.read(ar.data(), length);
            QString key = QString::number(listFav.count() + 1) + ". " +
            QString(ar);
            listFav[key] = url;
            addToMenuFavorite(key);
        }
        file.close();
    }
}
