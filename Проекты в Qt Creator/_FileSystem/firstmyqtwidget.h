#ifndef FIRSTMYQTWIDGET_H
#define FIRSTMYQTWIDGET_H

#include <QWidget>
#include <QGridLayout>
#include <QTreeView>
#include <QComboBox>
#include <QPushButton>
#include <QStandardItemModel>
#include <QApplication>

Q_PROPERTY(QStandardItemModel *model READ getCurrentModel WRITE setNewModel)

class FirstMyQtWidget : public QWidget {

    Q_OBJECT

public:

    explicit FirstMyQtWidget(QWidget *parent = nullptr);
    void clearTree();
    QStandardItemModel *getCurrentModel()const {

       return model;
    }

    void setNewModel(QStandardItemModel *newmodel);
    void rebuildModel(QString str);

private:

    QGridLayout *gridLay;
    QTreeView *tree;
    QPushButton *mainPath;
    QComboBox *disckSelBox;

private slots:

    void chgDisk(int index); // получаем индекс выбранного диска
    void goMainPath();       // Для UNIX-подобных ОС верхним уровнем является
                            // путь /
private:

    QStandardItemModel *model;
    QString curretnPath;

};

#endif // FIRSTMYQTWIDGET_H
