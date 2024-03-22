#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <iostream>
MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->undo_button->setDisabled(1);
    ui->redo_button->setDisabled(1);
    settings = readSettings();
    QMenu *filemenu = menuBar()->addMenu("File");
    QAction *create = filemenu->addAction("Create");
    QAction *open = filemenu->addAction("Open");
    QAction *save = filemenu->addAction("Save");
    QAction *prnt = filemenu->addAction("Print");
    connect(create, SIGNAL(triggered(bool)), this, SLOT(on_create_button_clicked()));
    connect(open, SIGNAL(triggered(bool)), this, SLOT(on_open_button_clicked()));
    connect(save, SIGNAL(triggered(bool)), this, SLOT(on_save_button_clicked()));
    connect(prnt, SIGNAL(triggered(bool)), this, SLOT(printToFile()));

}

MainWindow::~MainWindow()
{
    delete ui;
}

QMap<QString, QString> MainWindow::readSettings()
{
    QFile file(":/.txt/config.txt");
    if (file.open(QFile::ReadOnly | QFile::ExistingOnly))
    {
        QTextStream stream(&file);
        QMap<QString, QString> SL;
        QStringList text;
        while(!stream.atEnd())
        {
            text = stream.readLine().split(QLatin1Char(':'));
            SL.insert(text.at(0), text.at(1));
        }
        file.close();
        settings = SL;
        return SL;
    }
    else
    {
        QMessageBox::warning(this, tr("settings"), tr("file not found"));
        exit(1);
    }
}

void MainWindow::on_textEdit_textChanged()
{
    QString txt = textEdit->toPlainText();
    qint32 current_pos = textEdit->textCursor().position();
    qint32 current_len = txt.length();
    if (!cW.latch)
    {
        if (current_pos && (current_len > cW.previous_len))
        {
            UR.index = current_pos - (current_len - cW.previous_len);
            UR.value = txt.mid(UR.index, current_len - cW.previous_len);
            UR.direct = 1;
            cW.undo.push(UR);
            if (!cW.undo.isEmpty()) ui->undo_button->setDisabled(0);
            if (!cW.redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                cW.redo.clear();
            }

        }
        else if (current_pos >= 0 && (current_len < cW.previous_len))
        {
            UR.index = current_pos;
            UR.value = cW.previous_txt.mid(UR.index, cW.previous_txt.length() - current_len);
            UR.direct = 0;
            cW.undo.push(UR);
            if (!cW.redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                cW.redo.clear();
            }
        }
        else if (!current_pos && !current_len && cW.previous_txt.length())
        {
            UR.index = 0;
            UR.value = cW.previous_txt.mid(UR.index, cW.previous_txt.length());
            UR.direct = 0;
            cW.undo.push(UR);
            if (!cW.redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                cW.redo.clear();
            }
        }
        cW.previous_len = current_len;
        cW.previous_txt = txt;
    }
    else cW.latch = false;
    setW(cW.text);
}

void MainWindow::on_undo_button_clicked()
{
    undo_redo tmp = cW.undo.pop();
    cW.latch = true;
    if (tmp.direct)
    {
        cW.previous_txt.remove(tmp.index, tmp.value.length());
        textEdit->setText(cW.previous_txt);
    }
    else
    {
        cW.previous_txt.insert(tmp.index, tmp.value);
        textEdit->setText(cW.previous_txt);
    }
    cW.redo.push(tmp);
    if (cW.undo.isEmpty()) ui->undo_button->setDisabled(1);
    if (!cW.redo.isEmpty()) ui->redo_button->setDisabled(0);
    setW(cW.text);
}

void MainWindow::on_redo_button_clicked()
{
    undo_redo tmp = cW.redo.pop();
    cW.latch = true;
    if (tmp.direct)
    {
        cW.previous_txt.insert(tmp.index, tmp.value);
        textEdit->setText(cW.previous_txt);
    }
    else
    {
        cW.previous_txt.remove(tmp.index, tmp.value.length());
        textEdit->setText(cW.previous_txt);
    }
    cW.undo.push(tmp);
    if (cW.redo.isEmpty()) ui->redo_button->setDisabled(1);
    if (!cW.undo.isEmpty()) ui->undo_button->setDisabled(0);
    setW(cW.text);
}

void MainWindow::on_create_button_clicked()
{
    textEdit = new QTextEdit();
    textEdit->setAttribute(Qt::WA_DeleteOnClose);
    QMdiSubWindow *subW = new QMdiSubWindow(this);
    subW->setAttribute(Qt::WA_DeleteOnClose);
    subW->setWidget(textEdit);
    ui->mdiArea->addSubWindow(subW);
    cW.text = textEdit;
    cW.previous_len = 0;
    cW.previous_txt = "";
    cW.latch = false;
    cW.undo.clear();
    cW.redo.clear();
    Windows.push_back(cW);
    ui->undo_button->setDisabled(1);
    ui->redo_button->setDisabled(1);
    textEdit->show();
}

void MainWindow::openFile(QString p, bool a)
{
    QString s = p;
    QFile file(s);
    if (file.open(QFile::ReadOnly | QFile::ExistingOnly))
    {
        QTextStream stream(&file);
        on_create_button_clicked();
        textEdit->setPlainText(stream.readAll());
        textEdit->setReadOnly(a);
        file.close();
    }
}

void MainWindow::on_mdiArea_subWindowActivated(QMdiSubWindow *arg1)
{
    QWidget *a = arg1->widget();
    textEdit = qobject_cast<QTextEdit*>(a);
    connect(textEdit, SIGNAL(textChanged()), this, SLOT(on_textEdit_textChanged()));
    for (int index = 0; index < Windows.size(); ++index)
    {
        if (Windows[index].text == textEdit)
        {
            cW = Windows[index];
            if (!cW.redo.isEmpty()) ui->redo_button->setDisabled(0);
            if (!cW.undo.isEmpty()) ui->undo_button->setDisabled(0);
            break;
        }
    }
}

void MainWindow::setW(QTextEdit *W)
{
    for (int index = 0; index < Windows.size(); ++index)
    {
        if (Windows[index].text == W)
        {
            Windows[index] = cW;
            break;
        }
    }
}

void MainWindow::on_open_button_clicked()
{
    filesystem* FSWindow = new filesystem(false);
    connect(FSWindow, SIGNAL(approve_clicked(QString, bool)), this, SLOT(openFile(QString, bool)));
    FSWindow->setAttribute(Qt::WA_DeleteOnClose);
    FSWindow->setWindowModality(Qt::ApplicationModal);
    FSWindow->show();
}

void MainWindow::on_save_button_clicked()
{
    QString s = QFileDialog::getSaveFileName(this, tr("Save file"),
    QDir::current().path(), tr("Text file(*.txt);;binary file(*.original)"));
    int index = s.indexOf(".txt");
    QFile file(s);
    if (file.open(QFile::WriteOnly))
    {
        if (index != -1)
        {
            QTextStream stream(&file);
            stream << textEdit->toPlainText();
        }
        else
        {
            QDataStream stream(&file);
            stream << ui->author_lineEdit->text() << " ";
            stream << textEdit->toPlainText();
        }
        file.close();
    }
}

void MainWindow::on_about_button_clicked()
{
    QFile file(":/.txt/about.txt");
    if (file.open(QFile::ReadOnly | QFile::ExistingOnly))
    {
        QTextStream stream(&file);
        QMessageBox::information(this, tr("about programm"), stream.readAll());
        file.close();
    }
    else
    {
        QMessageBox::warning(this, tr("about programm"), tr("file not found"));
    }
}

void MainWindow::on_read_button_clicked()
{
    filesystem* FSWindow = new filesystem(true);
    connect(FSWindow, SIGNAL(approve_clicked(QString, bool)), this, SLOT(openFile(QString, bool)));
    FSWindow->setAttribute(Qt::WA_DeleteOnClose);
    FSWindow->setWindowModality(Qt::ApplicationModal);
    FSWindow->show();
}

void MainWindow::switchLanguage(QString language)
{
    translator.load(":/.qm/QtLanguage_" + language);
    qApp->installTranslator(&translator);
    ui->undo_button->setToolTip(tr("undo"));
    ui->redo_button->setToolTip(tr("redo"));
    ui->create_button->setToolTip(tr("crate"));
    ui->open_button->setToolTip(tr("open"));
    ui->read_button->setToolTip(tr("read mode"));
    ui->save_button->setToolTip(tr("save"));
    ui->locale_button->setToolTip(tr("switch lang"));
    ui->about_button->setToolTip(tr("about programm"));
    ui->settings_button->setToolTip(tr("settings"));

}

void MainWindow::on_locale_button_clicked()
{
    if (lang)
    {
        switchLanguage("ru.qm");
        ui->locale_button->setText("🇷🇺");
        lang = false;
    }
    else
    {
        switchLanguage("en.qm");
        ui->locale_button->setText("🇬🇧");
        lang = true;
    }
}

void MainWindow::keyReleaseEvent(QKeyEvent *event)
{
    if (event->key() ==  settings.value("Open").toInt()) on_open_button_clicked();
    else if (event->key() ==  settings.value("Save").toInt()) on_save_button_clicked();
    else if (event->key() ==  settings.value("Create").toInt()) on_create_button_clicked();
    else if (event->key() ==  settings.value("Quit").toInt()) exit(0);
}

void MainWindow::on_settings_button_clicked()
{
    Settings* setWindow = new Settings(this->readSettings());
    connect(setWindow, SIGNAL(approve_clicked()), this, SLOT(readSettings()));
    setWindow->setAttribute(Qt::WA_DeleteOnClose);
    setWindow->setWindowModality(Qt::ApplicationModal);
    setWindow->show();
}

void MainWindow::on_style_button_clicked()
{
    if (style)
    {
        qApp->setStyleSheet("QMainWindow { background-color: #EFEFEF }"
                            "QWidget { background-color: #EFEFEF }"
                            "QLineEdit { background-color: #FFFFFF; color: black }"
                            "QTextEdit { background-color: #FFFFFF; color: black }"
                            "QTableWidget { background-color: #FFFFFF; color: black }"
                            "QPushButton { background-color: #FAFAFA }");
        ui->style_button->setText("🌚");
        style = false;
    }
    else
    {
        qApp->setStyleSheet("QMainWindow { background-color: #4E5754 }"
                            "QWidget { background-color: #4E5754 }"
                            "QLineEdit { background-color: #18171C; color: white }"
                            "QTextEdit { background-color: #18171C; color: white }"
                            "QTableWidget { background-color: #18171C; color: white }"
                            "QPushButton { background-color: #A5A5A5 }");
        ui->style_button->setText("🌝");
        style = true;
    }
}

void MainWindow::printToFile()
{
    QPrinter printer;
    QPrintDialog dlg(&printer, this);
    dlg.setWindowTitle("Print");
    if(dlg.exec() != QDialog::Accepted) return;
    textEdit->print(&printer);
}
