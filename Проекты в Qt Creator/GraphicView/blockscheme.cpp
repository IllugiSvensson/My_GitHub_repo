#include "blockscheme.h"
#include <QPainter>
#include <QGraphicsSceneMouseEvent>

BlockScheme::BlockScheme(QObject *parent) : QObject(parent), QGraphicsItem()
{
    x = 0;
    y = 0;
    brush.setColor(QColor(rand() % 256, rand() % 256, rand() % 256));
    brush.setStyle(Qt::BrushStyle::SolidPattern);
    geometry = Geometry::ELLIPS;
    setPos(0,0);
    moving = false;
}

void BlockScheme::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    painter->setBrush(brush);
    if (geometry == Geometry::ELLIPS) painter->drawEllipse(x, y, 200, 100);
    if (geometry == Geometry::RECTANGLE) painter->drawRect(x, y, 200, 100);
    Q_UNUSED(option)
    Q_UNUSED(widget)
}

QRectF BlockScheme::boundingRect() const
{
    return QRectF(x, y, 200, 100);
}

void BlockScheme::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
    if (event->button() == Qt::LeftButton)
    {
        moving = true;
        bpoint = event->pos().toPoint();
    }
    if (event->button() == Qt::RightButton)
    {
        if (geometry == Geometry::ELLIPS)
        {
            geometry = Geometry::RECTANGLE;
        } else geometry = Geometry::ELLIPS;
        emit reDraw();
    }
}

void BlockScheme::mouseReleaseEvent(QGraphicsSceneMouseEvent *event)
{
    if (event->button() == Qt::LeftButton)
    {
        moving = false;
        emit reDraw();
    }
}

void BlockScheme::mouseMoveEvent(QGraphicsSceneMouseEvent *event)
{
    if (moving)
    {
        QPoint p = event->pos().toPoint() - bpoint;
        x += p.x();
        y += p.y();
        bpoint = event->pos().toPoint();
        emit reDraw();
    }
}

void BlockScheme::mouseDoubleClickEvent(QGraphicsSceneMouseEvent *event)
{
    if (event->button() == Qt::LeftButton)
    {
        emit dblClick();
    }
}

