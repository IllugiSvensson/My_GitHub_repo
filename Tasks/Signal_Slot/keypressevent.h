#ifndef KEYPRESSEVENT_H
#define KEYPRESSEVENT_H

#include <QObject>
#include <QEvent>
#include <QMouseEvent>

class KeyPressEvent : public QObject {
   Q_OBJECT

public:

   explicit KeyPressEvent(QObject *parent = nullptr);

protected:

    bool eventFilter(QObject *obj, QEvent *event) override;

signals:


public slots:

private:
};

#endif // KEYPRESSEVENT_H
