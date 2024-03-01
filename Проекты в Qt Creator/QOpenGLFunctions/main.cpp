#include "mainwindow.h"
#include <QApplication>
#include <QScreen>
#include <QtGui/QOpenGLShaderProgram>


class DrawPoligon : public MainWindow {
public:

   DrawPoligon();
   ~DrawPoligon();
   void initialize() override;
   void render() override;

private:

   QOpenGLShaderProgram *m_program;
   GLuint buff;
   GLint pos, wsizes;

};

DrawPoligon::DrawPoligon()
   : m_program(0)
   ,buff(0) {

}

int main(int argc, char *argv[]) {

   QGuiApplication app(argc, argv);

   QSurfaceFormat format;
   format.setSamples(16);

   DrawPoligon window;
   window.setFormat(format);
   window.resize(640, 480);
   window.show();

return app.exec();
}

static const char *vertexShaderSource =
   "attribute vec2 input1;"
   "void main(){"
   "gl_Position = vec4(input1, 0., 1.0);"
   "}";

static const char *fragmentShaderSource =
   "uniform int sizes[2];"
   "void main(){"
   "vec2 coord = gl_FragCoord.xy;"
   "gl_FragColor = vec4(coord.x / float(sizes[0]), 0.5, coord.y / float(sizes[1]), 1.0);"
   "}";

void DrawPoligon::initialize() {

   m_program = new QOpenGLShaderProgram(this);
   m_program->addShaderFromSourceCode(QOpenGLShader::Vertex, vertexShaderSource);
   m_program->addShaderFromSourceCode(QOpenGLShader::Fragment, fragmentShaderSource);
   bool rez = m_program->link();

    if (!rez) qApp->quit();

        glGenBuffers(1, &buff);

    if (!buff) qApp->quit();

        pos = m_program->attributeLocation("input");
        wsizes = m_program->uniformLocation("sizes");

   float vert[] = {-1.0f, -1.0f,
                   1.0f, -1.0f,
                   1.0f, 1.0f,
                   -1.0f, 1.0f,
                  };

   glBindBuffer(GL_ARRAY_BUFFER, buff);
   glBufferData(GL_ARRAY_BUFFER, sizeof vert, vert, GL_STATIC_DRAW);
   glVertexAttribPointer(pos, 2, GL_FLOAT, GL_FALSE, 0, 0);
   glEnableVertexAttribArray(pos);
   glBindBuffer(GL_ARRAY_BUFFER, 0);

}

void DrawPoligon::render() {

   const qreal retinaScale = devicePixelRatio();
   int sizes[] = {int(width() * retinaScale), int(height() * retinaScale)};

   glViewport(0, 0, sizes[0], sizes[1]);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   m_program->bind();
   m_program->setUniformValueArray(wsizes, sizes, 2);
   glBindBuffer(GL_ARRAY_BUFFER, buff);
   glDrawArrays(GL_QUADS, 0, 4);
   glBindBuffer(GL_ARRAY_BUFFER, 0);
   m_program->release();

}

DrawPoligon::~DrawPoligon() {

   if (buff) glDeleteBuffers(1, &buff);

}
