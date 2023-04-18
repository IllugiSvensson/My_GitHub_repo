import os
import subprocess
import re
import sys
from threading import Thread
from tkinter import *
from tkinter import Tk, ttk, Button, Label, Canvas, messagebox
from ping3 import ping




def exit_button():
    quit(0)

def clear_all(widget):
   for item in widget.get_children():
      widget.delete(item)

class MainWidget:

    def __init__(self, window, coord_x, coord_y):
        self.online_product_label = None
        self.online_product_combo = None
        self.online_hosts_tree = None
        self.offline_product_label = None
        self.offline_product_combo = None
        self.offline_hosts_tree = None
        self.info_text = None
        self.info_label = None

        self.exit_button = Button(window, command=exit_button, text="Выход")
        self.exit_button.place(x=coord_x, y=coord_y)

    def help_widget(self, window, text):
        self.info_label = Label(window, text=text, anchor="center", font="Sans 14", fg="red", relief="raised", padx=10)
        self.info_label.pack()

        self.info_text = Canvas(window, height=580, width=380, bg="white", relief="sunken", borderwidth=1)
        self.info_text.place(x=10, y=30)
        self.info_text.create_text(10, 10, anchor="nw", font="Sans 12",
                                   text="Скрипт предназначен дня смены роли\n"
                                        "локальных и удаленных компьютеров.\n\n"
                                        "Для корректной работы необходимо:\n"
                                        "1. Проверить, что Config и Product из\n"
                                        "   system.xml существуют в /soft/etc\n\n"
                                        "2. В ZIP.xml в графе NetConf добавить\n"
                                        "   необходимый продукт и пары адресов.\n"
                                        "   Левые адреса - для пингов ЗИПом\n"
                                        "   Правые адреса - для самого ЗИПа\n"
                                        "   Хотя бы один адрес должен пинговаться!\n\n"
                                        "3. Для запуска приложения нужно указать\n"
                                        "   аргумент - продукт из ZIP.xml\n"
                                        "   Обязательно прописать продукт в\n"
                                        "   аргумент для ЗИП в launch.xml\n\n"
                                        "4. Распространить настройки по хостам,\n"
                                        "   включая зиповые хосты.\n\n"
                                        "   Пример работы:\n"
                                        "При включении ЗИП хоста по launch\n"
                                        "запускается приложение. Оно зачитывает\n"
                                        "из launch.xml продукт и ищет его в ZIP.xml.\n"
                                        "Найдя продукт, назначается адрес из\n"
                                        "правой колонки и пингуется адрес из\n"
                                        "левой. Так до тех пор, пока один из\n"
                                        "адресов не ответит. После этого можно\n"
                                        "задать роль локально или удаленно.\n")

    def main_widget(self, window, product_list):
        columns = ("#1", "#2")
        style = ttk.Style()
        style.map("TCombobox", fieldbackground=[("readonly", "white")])
        style.map("TCombobox", selectbackground=[("readonly", "transparent")])
        style.map("TCombobox", selectforeground=[("readonly", "black")])
        style.map("TCombobox", fieldbackground=[("disabled", "lightgray")])
        style.configure("TCombobox", arrowsize=0)
        style.configure("Treeview", font="Sans 10")
        style.configure("Treeview.Heading", font="Sans 12")
        window.option_add("*TCombobox*Listbox*font", "Sans 12")

        self.online_product_label = Label(window, text="Выберите продукт и хост для смены роли:", anchor="w",
                                          font="Sans 12")
        self.online_product_label.place(x=10, y=10)
        self.offline_product_label = Label(window, text="Выберите продукт и роль для хоста:", anchor="e",
                                           font="Sans 12")
        self.offline_product_label.place(x=510, y=10)

        self.online_product_combo = ttk.Combobox(window, font="Sans 12", width=38, state="readonly",
                                                 values=product_list)
        self.online_product_combo.place(x=10, y=40)
        self.offline_product_combo = ttk.Combobox(window, font="Sans 12", width=38, state="disable",
                                                  values=product_list, justify="right")
        self.offline_product_combo.place(x=435, y=40)

        self.online_hosts_tree = ttk.Treeview(window, show="headings", columns=columns, selectmode="browse")
        self.online_hosts_tree.heading("#1", text="Имя")
        self.online_hosts_tree.heading("#2", text="Описание")
        self.online_hosts_tree.column("#1", width=100)
        self.online_hosts_tree.column("#2", width=300)
        self.online_hosts_tree.place(x=10, y=80)

        self.offline_hosts_tree = ttk.Treeview(window, show="headings", columns=columns, selectmode="browse")
        self.offline_hosts_tree.heading("#1", text="Имя")
        self.offline_hosts_tree.heading("#2", text="Описание")
        self.offline_hosts_tree.column("#1", width=100)
        self.offline_hosts_tree.column("#2", width=300)
        self.offline_hosts_tree.place(x=420, y=80)

        self.main_cycle()

    def main_cycle(self):
        self.online_product_combo.bind("<<ComboboxSelected>>", lambda _: self.choose_product())
        self.online_hosts_tree.bind("<<TreeviewSelect>>", lambda  _: self.choose_host())

    def choose_product(self):
        self.pick = messagebox.askyesno(title="Выбор продукта",
                                           message="Подтвердите выбор продукта \"" + self.online_product_combo.get() + "\"")

        if self.pick:
            a = XmlParser()
            clear_all(self.online_hosts_tree)
            self.offline_product_combo.config(state="disable")

            a.ping_host(self.online_product_combo.get(), 0, self.online_hosts_tree)


        else:
            self.online_product_combo.set('')
            clear_all(self.online_hosts_tree)
            self.offline_product_combo.config(state="disable")

    def choose_host(self):
        self.offline_product_combo.config(state='readonly')

    def progress(self):
        print("thread with progress started")
        mw = Tk()
        mw.resizable(False, False)
        mw.title("Пинг")
        mw.geometry("200x300+960+540")
        p = ttk.Progressbar(self, orient="horizontal", length=100, mode="indeterminate")
        p.pack()
        mw.mainloop()

class XmlParser:

    def __init__(self):
        self.XML = ""
        self.ETC = "/soft/etc"
        if os.system('cat /etc/redhat-release | grep "release 8."') == 0:
            self.REGTOOL = "/usr/local/nita/scripts/regtool"
            self.CONFIG = subprocess.check_output([self.REGTOOL, "-r", self.ETC + "/system.xml", "/", "Config"]).decode(
                "utf-8")
            self.confXML = self.ETC + "/" + self.CONFIG[:-1] + "/hardware"
        else:
            self.REGTOOL = "/system/scripts/regtool.sh"
            self.CONFIG = subprocess.check_output([self.REGTOOL, "-r", self.ETC + "/system.xml", "/", "Config"]).decode(
                "utf-8")
            self.confXML = self.ETC + "/" + self.CONFIG[:-1]

        for i in (subprocess.check_output(["grep", ".xml"], stdin=subprocess.Popen(["ls", self.confXML],
                                                                                   stdout=subprocess.PIPE).stdout).decode(
            "utf-8")).split():
            self.XMl_check = subprocess.check_output(
                [self.REGTOOL, "-r", self.confXML + "/" + i, "/Config /UseGenConf"]).decode("utf-8")
            if self.XMl_check[:-1] == "1":
                self.XML = self.XML + " " + i
            self.XML = self.XML.replace(".xml", '')
        self.check_hosts = subprocess.check_output(
            [self.REGTOOL, "-n", self.confXML + "/ZIP.xml", "/Hosts/ZIP/NetConf"]).decode("utf-8")

    #def asd(self,a):
       # answer = ping(a)
        #return answer

    def ping_host(self, host, status, output):
        if status == 0:
            for HostProd in subprocess.check_output([self.REGTOOL, "-n", self.confXML + "/" + host + ".xml", "/Hosts"]).decode("utf-8").split():
                if subprocess.check_output([self.REGTOOL, "-r", self.confXML + "/" + host + ".xml", "/Hosts/" + HostProd, "Alien"]).decode("utf-8") == 1:
                    continue
                ADDRESSES = subprocess.check_output([self.REGTOOL, "-l", self.confXML + "/" + host + ".xml", "/Hosts/" + HostProd + "/Network/Addresses"]).decode("utf-8")
                for ADDRESS in ADDRESSES.split():
                    th = Thread(target=ping(ADDRESS))
                    th.start()
                    answer = th.join()
                    #print(answer)
                    #answer = ping(ADDRESS)
                    #if str(answer) != "None":
                        #DESCRIPTION = subprocess.check_output([self.REGTOOL, "-r", self.confXML + "/" + host + ".xml", "/Hosts/" + HostProd, "Description", HostProd]).decode("utf-8")
                        #th = Thread(target=self.asd(output, HostProd, DESCRIPTION))
                        #th.start()
                        #output.insert("", END, text=HostProd, values=(HostProd, DESCRIPTION))
                        #break


if __name__ == "__main__":
    mainwindow = Tk()
    mainwindow.resizable(False, False)
    mainwindow.title("Смена роли рабочего места")

    if len(sys.argv) < 2:
        mainwindow.geometry("400x670+960+540")
        mainwidget_object = MainWidget(mainwindow, 300, 630)
        mainwidget_object.help_widget(mainwindow, "Не указан продукт в аргументе.")

    elif sys.argv[1] == "--help":
        mainwindow.geometry("400x670+960+540")
        mainwidget_object = MainWidget(mainwindow, 300, 630)
        mainwidget_object.help_widget(mainwindow, "Справка по программе.")

    else:
        xml_parser = XmlParser()
        for i in (xml_parser.check_hosts[:-1] + "endline").split():
            if i == sys.argv[1]:
                mainwindow.geometry("830x670+960+540")
                mainwidget_object = MainWidget(mainwindow, 730, 630)
                mainwidget_object.main_widget(mainwindow, xml_parser.XML)
                break

            elif i == "endline":
                mainwindow.geometry("400x670+960+540")
                mainwidget_object = MainWidget(mainwindow, 300, 630)
                mainwidget_object.help_widget(mainwindow, "Продукт не найден в конфигурации.")

    mainwindow.mainloop()
