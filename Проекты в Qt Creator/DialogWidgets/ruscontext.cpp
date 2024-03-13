#include "ruscontext.h"

RusContext::RusContext(QWidget* parent) : QTextEdit(parent)
{
    menu = new QMenu(this);
    QAction *copyAction = menu->addAction("copy");
    QAction *pasteAction = menu->addAction("paste");
    connect(copyAction, SIGNAL(triggered(bool)), this, SLOT(copyText()));
    connect(pasteAction, SIGNAL(triggered(bool)), this, SLOT(pasteText()));
}


void RusContext::copyText()
{
    QString str = QTextCursor().selectedText();
    qApp->clipboard()->setText(str);
}

void RusContext::pasteText()
{
    QString str = qApp->clipboard()->text();
    QTextCursor().insertText(str);
}

void RusContext::contextMenuEvent(QContextMenuEvent *e)
{
    menu->exec(e->globalPos());
}
