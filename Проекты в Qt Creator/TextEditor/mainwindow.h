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


QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

struct undo_redo
{
    QString value;
    qint32 index;
    bool direct;
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

protected slots:
    QMap<QString, QString> readSettings();

private:
    Ui::MainWindow *ui;
    undo_redo U_R;
    QStack<undo_redo> undo;
    QStack<undo_redo> redo;
    qint32 previous_len;
    bool latch = true, lang = true;
    QString previous_txt;
    QTranslator translator;
    QMap<QString, QString> settings;

    void switchLanguage(QString language);

protected:
    virtual void keyReleaseEvent(QKeyEvent *event);
};
#endif // MAINWINDOW_H
