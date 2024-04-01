#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLineEdit>
#include <QtWebEngineWidgets/QWebEngineView>
#include <QToolButton>
#include <QPushButton>
#include <QHash>
#include <QMenu>

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    QLineEdit *navigateEdit;
    QWebEngineView *webView;
    QToolButton *goButton;

    QToolButton *addFavorite;
    QPushButton *viewFavorite;
    QPushButton *menuButton;
    QMenu *favList;
    QHash<QString, QString>listFav;

private slots:
    void goToUrl();
    void addToFavorite();
    void addToMenuFavorite(QString&);

    void openFavoritePage();
    void savePageAs();

private:
    void loadFavorites();
    void addMainMenu();

};
#endif // MAINWINDOW_H
