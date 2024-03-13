#ifndef RUSCONTEXT_H
#define RUSCONTEXT_H

#include <QMainWindow>
#include <QObject>
#include <QTextEdit>
#include <QContextMenuEvent>
#include <QMenu>
#include <QApplication>
#include <QClipboard>

class RusContext : public QTextEdit
{
    Q_OBJECT
public:
    RusContext(QWidget *parent = nullptr);

protected:
    void contextMenuEvent(QContextMenuEvent *e) override;

public slots:
    void copyText();
    void pasteText();

private:
    QMenu *menu;
};

#endif // RUSCONTEXT_H
