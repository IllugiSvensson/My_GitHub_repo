import os
import subprocess
from tkinter import *
from tkinter import Tk, ttk, Button, Label, LabelFrame, messagebox



class MainWindow:
    def __init__(self, window, scale):
        self.regtool = "/usr/local/nita/scripts/regtool"
        self.stend = "Stend-Horizon"
        self.samara = "Samara-Horizon"
        self.cfg = self.readConfig()

        self.system = StringVar(value=self.cfg)
        self.infoLabel = Label(text="Текущая система: " + self.cfg, font=("Sans", int(32 * scale)), width=33, height=2, relief="raised", borderwidth=5)
        self.radioButton1 = Radiobutton(text=self.stend, value=self.stend, variable=self.system, font=("Sans", int(48 * scale)), command=self.switch, height=2, width=19, anchor="w")
        self.radioButton2 = Radiobutton(text=self.samara, value=self.samara, variable=self.system, font=("Sans", int(48 * scale)), command=self.switch, height=2, width=19, anchor="w")
        self.infoLabel.place(x=30, y=30)
        self.radioButton1.place(x=30, y=150)
        self.radioButton2.place(x=30, y=300)


    def readConfig(self):
        return subprocess.check_output([self.regtool, "-r", "/soft/etc/system.xml", "/", "Config"]).decode("utf-8")[:-1:]


    def setConfig(self, cfg):
            subprocess.run([self.regtool, "-w", "/soft/etc/system.xml", "/", "Config", cfg])


    def switch(self):
        if self.cfg != self.system.get():
            self.pick = messagebox.askyesno(parent=mainwindow, title="Смена системы", message="Подвердите смену системы на: " + self.system.get())
            if self.pick:
                os.system("blockkill all")
                os.system("killall -9 CameraView")
                os.system("killall -9 PanoramaDeskController")
                os.system("killall -9 PanoramaView")
                self.setConfig(self.system.get())
                os.system("remount rw && system.sh GenerateConfig")
                os.system("unblock all")
                self.infoLabel.config(text="Текущая система: " + self.system.get())
                self.cfg = self.readConfig()
            else:
                self.system.set(self.cfg)


if __name__ == "__main__":
    mainwindow = Tk()
    scrx = mainwindow.winfo_screenwidth()
    mainwindow.resizable(False, False)
    mainwindow.title("Смена конфигурации рабочего места")
    mainwindow.geometry("960x540+960+540")
    mainwindow.option_add('*Dialog.msg.font', "Sans 24")
    MainWindow(mainwindow, 3840 / scrx)
    mainwindow.mainloop()
