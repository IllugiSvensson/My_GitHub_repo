#ifndef FILESYSTEM_H
#define FILESYSTEM_H

#include <QWidget>
#include <QFileSystemModel>

namespace Ui {
class filesystem;
}

class filesystem : public QWidget
{
    Q_OBJECT

public:
    explicit filesystem(bool a = true, QWidget *parent = nullptr);
    ~filesystem();

signals:
    void approve_clicked(QString, bool);

private slots:
    void on_approve_clicked();
    void on_FSNO_button_clicked();

    void on_FStree_clicked(const QModelIndex &index);

private:
    Ui::filesystem *ui;
    QString path;
    bool reg = true;
};

#endif // FILESYSTEM_H
