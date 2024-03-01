#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QWindow>
#include <QOpenGLFunctions>
#include <QOpenGLPaintDevice>

//Меняем родительский класс
//Наследуем методы из OpenGL
class MainWindow : public QWindow, protected QOpenGLFunctions {
   Q_OBJECT

public:

   MainWindow(QWindow *parent = 0);
   ~MainWindow();
   virtual void render(QPainter *painter);
   virtual void render();
   virtual void initialize();

public slots:

   void renderLater();
   void renderNow();

protected:

   bool event(QEvent *event) override;
   void exposeEvent(QExposeEvent *event) override;

private:

   QOpenGLContext *m_context;
   QOpenGLPaintDevice *m_device;

};

#endif // MAINWINDOW_H
