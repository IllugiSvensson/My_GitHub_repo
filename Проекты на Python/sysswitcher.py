import os
import subprocess
from tkinter import *
from tkinter import Tk, ttk, Button, Label, LabelFrame, messagebox



class MainWindow:
    def __init__(self, window, font, scale):
        self.regtool = "/usr/local/nita/scripts/regtool"
        self.stend = "Stend-Horizon"
        self.samara = "Samara-Horizon"
        self.cfg = self.readConfig()

        self.system = StringVar(value=self.cfg)
        self.infoLabel = Label(text="Текущая система: " + self.cfg, font=("Sans", font), relief="raised", borderwidth=5)
        self.radioButton1 = Radiobutton(text=self.stend, value=self.stend, variable=self.system, font=("Sans", font), command=self.switch, height=2, width=15 * scale, anchor="w")
        self.radioButton2 = Radiobutton(text=self.samara, value=self.samara, variable=self.system, font=("Sans", font), command=self.switch, height=2, width=15 * scale, anchor="w")
        self.infoLabel.pack()
        self.radioButton1.place(x=30, y=90 * scale)
        self.radioButton2.place(x=30, y=240 * scale)
        self.setApp()


    def readConfig(self):
        return subprocess.check_output([self.regtool, "-r", "/soft/etc/system.xml", "/", "Config"]).decode("utf-8")[:-1:]

    def setConfig(self, cfg):
            subprocess.run([self.regtool, "-w", "/soft/etc/system.xml", "/", "Config", cfg])

    def setApp(self):
        if self.cfg == self.samara:
            os.system("killall -9 openvpn")
            os.system("launch openvpn &")
            os.system("mv /soft/lib/libip_st_plugin.so /soft/lib/libip_st_plugin.so.bak")
        else:
            os.system("killall -9 openvpn")
            os.system("mv /soft/lib/libip_st_plugin.so.bak /soft/lib/libip_st_plugin.so")

    def switch(self):
        if self.cfg != self.system.get():
            self.pick = messagebox.askyesno(parent=mainwindow, title="Смена системы", message="Подвердите смену системы на: " + self.system.get())
            if self.pick:
                os.system("blockkill camera_view@WS2")
                os.system("blockkill panorama_desk_controller@no_fullscreen")
                os.system("blockkill panorama_view")
                os.system("killall -9 CameraView")
                os.system("killall -9 PanoramaDeskController")
                os.system("killall -9 PanoramaView")
                self.setConfig(self.system.get())
                os.system("remount rw && system.sh GenerateConfig")
                self.infoLabel.config(text="Текущая система: " + self.system.get())
                self.cfg = self.readConfig()
                self.setApp()
                os.system("unblock all")
            else:
                self.system.set(self.cfg)


if __name__ == "__main__":
    mainwindow = Tk()
    mainwindow.resizable(False, False)
    mainwindow.title("Смена конфигурации рабочего места")

    normal_width = 480
    normal_height = 240
    screen_width = mainwindow.winfo_screenwidth()
    screen_height = mainwindow.winfo_screenheight()
    perc_width = screen_width / (normal_width / 100)
    perc_height = screen_height / (normal_height / 100)
    scale_factor = ((perc_width + perc_height) / 9) / 100
    fontsize = int(12 * scale_factor)

    mainwindow.geometry(str(int(normal_width * scale_factor)) + "x" + str(int(normal_height * scale_factor)) + "+960+540")
    mainwindow.option_add('*Dialog.msg.font', "Sans 24")
    MainWindow(mainwindow, fontsize, int(scale_factor))
    mainwindow.mainloop()
