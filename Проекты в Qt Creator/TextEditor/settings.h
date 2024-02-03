#ifndef SETTINGS_H
#define SETTINGS_H

#include <QWidget>
#include <QFile>
#include <QTextStream>
#include <QKeyEvent>

namespace Ui {
class Settings;
}

class Settings : public QWidget
{
    Q_OBJECT

public:
    explicit Settings(QMap<QString, QString> settings, QWidget *parent = nullptr);
    ~Settings();

    void initialTable(QMap<QString, QString> strL);
    void keyReleaseEvent(QKeyEvent *event);

signals:
    void approve_clicked();

private slots:
    void on_approve_clicked();
    void on_cancel_clicked();

private:
    Ui::Settings *ui;
    QMap<QString, QString> set;
};

#endif // SETTINGS_H
