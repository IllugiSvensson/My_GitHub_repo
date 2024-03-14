#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    previous_len = 0;
    previous_txt = "";
    latch = 0;
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
    QString txt = ui->textEdit->toPlainText();
    qint32 current_pos = ui->textEdit->textCursor().position();
    qint32 current_len = txt.length();
    if (!latch)
    {
        if (current_pos && (current_len > previous_len))
        {
            U_R.index = current_pos - (current_len - previous_len);
            U_R.value = txt.mid(U_R.index, current_len - previous_len);
            U_R.direct = 1;
            undo.push(U_R);
            if (!undo.isEmpty()) ui->undo_button->setDisabled(0);
            if (!redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                redo.clear();
            }
        }
        else if (current_pos >= 0 && (current_len < previous_len))
        {
            U_R.index = current_pos;
            U_R.value = previous_txt.mid(U_R.index, previous_txt.length() - current_len);
            U_R.direct = 0;
            undo.push(U_R);
            if (!redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                redo.clear();
            }
        }
        else if (!current_pos && !current_len && previous_txt.length())
        {
            U_R.index = 0;
            U_R.value = previous_txt.mid(U_R.index, previous_txt.length());
            U_R.direct = 0;
            undo.push(U_R);
            if (!redo.isEmpty())
            {
                ui->redo_button->setDisabled(1);
                redo.clear();
            }
        }
        previous_len = current_len;
        previous_txt = txt;
    }
    else latch = 0;
}

void MainWindow::on_undo_button_clicked()
{
    undo_redo tmp = undo.pop();
    latch = 1;
    if (tmp.direct)
    {
        previous_txt.remove(tmp.index, tmp.value.length());
        ui->textEdit->setText(previous_txt);
    }
    else
    {
        previous_txt.insert(tmp.index, tmp.value);
        ui->textEdit->setText(previous_txt);
    }
    redo.push(tmp);
    if (undo.isEmpty()) ui->undo_button->setDisabled(1);
    if (!redo.isEmpty()) ui->redo_button->setDisabled(0);
}

void MainWindow::on_redo_button_clicked()
{
    undo_redo tmp = redo.pop();
    latch = 1;
    if (tmp.direct)
    {
        previous_txt.insert(tmp.index, tmp.value);
        ui->textEdit->setText(previous_txt);
    }
    else
    {
        previous_txt.remove(tmp.index, tmp.value.length());
        ui->textEdit->setText(previous_txt);
    }
    undo.push(tmp);
    if (redo.isEmpty()) ui->redo_button->setDisabled(1);
    if (!undo.isEmpty()) ui->undo_button->setDisabled(0);
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
            stream << ui->textEdit->toPlainText();
        }
        else
        {
            QDataStream stream(&file);
            stream << ui->author_lineEdit->text() << " ";
            stream << ui->textEdit->toPlainText();
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

void MainWindow::on_create_button_clicked()
{
    ui->textEdit->setReadOnly(false);
    ui->textEdit->clear();
    undo.clear();
    redo.clear();
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

void MainWindow::openFile(QString p, bool a)
{
    QString s = p;
    QFile file(s);
    if (file.open(QFile::ReadOnly | QFile::ExistingOnly))
    {
        QTextStream stream(&file);
        ui->textEdit->setPlainText(stream.readAll());
        undo.clear();
        redo.clear();
        ui->redo_button->setDisabled(1);
        ui->undo_button->setDisabled(1);
        ui->textEdit->setReadOnly(a);
        file.close();
    }
}

void MainWindow::printToFile()
{
    QPrinter printer;
    QPrintDialog dlg(&printer, this);
    dlg.setWindowTitle("Print");
    if(dlg.exec() != QDialog::Accepted) return;
    ui->textEdit->print(&printer);
}
