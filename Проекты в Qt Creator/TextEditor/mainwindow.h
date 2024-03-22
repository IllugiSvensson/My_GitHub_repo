#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QStack>
#include <QFile>
#include <QTextStream>
#include <QMessageBox>
#include <QFileDialog>
#include <QDir>
#include <QTranslator>
#include <QKeyEvent>
#include <QDialog>
#include "settings.h"
#include "filesystem.h"
#include <QMenu>
#include <QMenuBar>
#include <QPrinter>
#include <QPrintDialog>
#include <QMdiSubWindow>
#include <QTextEdit>


QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

struct undo_redo
{
    QString value;
    qint32 index;
    bool direct;
};

struct curWindow
{
    QTextEdit *text;
    QString previous_txt;
    qint32 previous_len;
    bool latch;
    QStack<undo_redo> undo;
    QStack<undo_redo> redo;
};

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_textEdit_textChanged();
    void on_undo_button_clicked();
    void on_redo_button_clicked();
    void on_open_button_clicked();
    void on_save_button_clicked();
    void on_about_button_clicked();
    void on_read_button_clicked();
    void on_create_button_clicked();
    void on_locale_button_clicked();
    void on_settings_button_clicked();
    void on_style_button_clicked();
    void openFile(QString p, bool a);
    void printToFile();
    void on_mdiArea_subWindowActivated(QMdiSubWindow *arg1);
    void setW(QTextEdit *W);

protected slots:
    QMap<QString, QString> readSettings();

private:
    Ui::MainWindow *ui;
    QTextEdit *textEdit;
    undo_redo UR;
    curWindow cW;
    std::vector<curWindow> Windows;
    bool lang = true, style = false;
    QTranslator translator;
    QMap<QString, QString> settings;
    void switchLanguage(QString language);

protected:
    virtual void keyReleaseEvent(QKeyEvent *event);
};
#endif // MAINWINDOW_H
