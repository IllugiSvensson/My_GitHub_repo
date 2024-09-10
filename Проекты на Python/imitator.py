from tkinter import Tk, Button, Label
import subprocess, os, time, threading
from datetime import datetime



class MainWindow:
    def __init__(self):
        #Make mainwidget GUI
        self.mainwindow = Tk()
        self.mainwindow.resizable(False, False)
        self.mainwindow.title("Emulator control panel")
        self.mainwindow.geometry("300x350+600+50")
        self.mainwindow.attributes('-topmost', True)

        Label(text="Targets Monitor", font=("Sans", 11), anchor="sw").place(x=65, y=5)
        Label(text="Emul's Panel", font=("Sans", 11), anchor="w").place(x=65, y=44)
        Label(text="MR/5P control", font=("Sans", 11), anchor="w").place(x=65, y=81)
        Label(text="Socat Kama 1", font=("Sans", 11), anchor="w").place(x=65, y=119)
        Label(text="Socat Kama 2", font=("Sans", 11), anchor="w").place(x=65, y=157)
        Label(text="Socat Sev 1", font=("Sans", 11), anchor="w").place(x=65, y=195)
        Label(text="Socat Sev 2", font=("Sans", 11), anchor="w").place(x=65, y=233)
        Label(text="Socat Harakter 1", font=("Sans", 11), anchor="w").place(x=65, y=271)
        Label(text="Socat Harakter 2", font=("Sans", 11), anchor="w").place(x=65, y=309)
        Label(text="Work time", font=("Sans", 11), anchor="w", relief="raised", borderwidth=3).place(x=200, y=105)
        Label(text="Reload at", font=("Sans", 11), anchor="w", relief="raised", borderwidth=3).place(x=200, y=181)

        self.targetsButton = Button(text="Stop", font=("Sans", 11), anchor="w", relief="sunken", command=lambda: self.mLauncher(self.targetsButton, "targets"))
        self.emulsButton = Button(text="Stop", font=("Sans", 11), anchor="w", relief="sunken", command=lambda: self.mLauncher(self.emulsButton, "stand_control_panel"))
        self.controlButton = Button(text="Stop", font=("Sans", 11), anchor="w", relief="sunken",command=lambda: self.mLauncher(self.controlButton, "emul_control_panel"))
        self.kama1Button = Label(text="On", font=("Sans", 11), anchor="w", relief="groove", bd=3, bg="green")
        self.kama2Button = Label(text="On", font=("Sans", 11), anchor="w", relief="groove", bd=3, bg="green")
        self.sev1Button = Label(text="On", font=("Sans", 11), anchor="w", relief="groove", bd=3, bg="green")
        self.sev2Button = Label(text="On", font=("Sans", 11), anchor="w", relief="groove", bd=3, bg="green")
        self.hara1Button = Label(text="On", font=("Sans", 11), anchor="w", relief="groove", bd=3, bg="green")
        self.hara2Button = Label(text="On", font=("Sans", 11), anchor="w", relief="groove", bd=3, bg="green")
        self.worktime = Label(text="000:00:00", font=("Sans", 11), anchor="w",relief="solid")
        self.reloadat = Label(text="5400 s", font=("Sans", 11), anchor="w", relief="solid")

        self.targetsButton.place(x=5, y=5)
        self.emulsButton.place(x=5, y=43)
        self.controlButton.place(x=5, y=81)
        self.kama1Button.place(x=5, y=119)
        self.kama2Button.place(x=5, y=157)
        self.sev1Button.place(x=5, y=195)
        self.sev2Button.place(x=5, y=233)
        self.hara1Button.place(x=5, y=271)
        self.hara2Button.place(x=5, y=309)
        self.worktime.place(x=200, y=143)
        self.reloadat.place(x=200, y=219)

        #Make mainloop
        self.p1 = self.mStartSocat("192.168.111.52", "14101", "tty1")
        self.p2 = self.mStartSocat("192.168.111.52", "14102", "tty2")
        self.p3 = self.mStartSocat("192.168.111.52", "14103", "tty3")
        self.p4 = self.mStartSocat("192.168.121.52", "14101", "tty4")
        self.p5 = self.mStartSocat("192.168.121.52", "14102", "tty5")
        self.p6 = self.mStartSocat("192.168.121.52", "14103", "tty6")
        self.mStartApp("stand_control_panel")
        self.mStartApp("emul_control_panel")

        self.th = threading.Thread(target=self.mCycle)
        self.th.setDaemon(True)
        self.th.start()

        self.mainwindow.mainloop()
        self.mStopApp("targets")
        self.mStopApp("stand_control_panel")
        self.mStopApp("emul_control_panel")
        self.mStopSocat()


    #Methods
    def mCycle(self):
        self.cooldown = 5400
        self.starttime = datetime.now()
        while True:
            time.sleep(1)
            if self.cooldown == 5400:
                self.mStartApp("targets")

            if self.cooldown == 0:
                self.cooldown = 5401
                self.mStopApp("targets")

            self.worktime['text'] = str(datetime.now() - self.starttime)[:7]
            self.reloadat['text']= str(self.cooldown - 1) + " s"
            self.cooldown = self.cooldown - 1

            self.checkApp(self.targetsButton, "targets")
            self.checkApp(self.emulsButton, "stand_control_panel")
            self.checkApp(self.controlButton, "emul_control_panel")

            self.p1 = self.checkSocat("192.168.111.52", "14101", "tty1", self.p1, self.kama1Button)
            self.p2 = self.checkSocat("192.168.111.52", "14102", "tty2", self.p2, self.sev1Button)
            self.p3 = self.checkSocat("192.168.111.52", "14103", "tty3", self.p3, self.hara1Button)
            self.p4 = self.checkSocat("192.168.121.52", "14101", "tty4", self.p4, self.kama2Button)
            self.p5 = self.checkSocat("192.168.121.52", "14102", "tty5", self.p5, self.sev2Button)
            self.p6 = self.checkSocat("192.168.121.52", "14103", "tty6", self.p6, self.hara2Button)

    def mLauncher(self, button, app):
        if button.cget('text') == 'Start':
            self.mStartApp(app)
            button["text"] = "Stop"
            button["relief"] = "sunken"
        else:
            self.mStopApp(app)
            button["text"] = "Start"
            button["relief"] = "groove"

    def mStartApp(self, app):
        os.system("unblock " + app)
        subprocess.Popen(["launch", app])

    def mStopApp(self, app):
        os.system("blockkill " + app)
        os.system("killall " + app + ".bin")

    def checkApp(self, button, app):
        self.answer = os.system("pgrep -f " + app)
        if self.answer != 0:
            button["text"] = "Start"
            button["relief"] = "groove"

    def checkSocat(self, host, port, tty, pid, button):
        if os.system("pgrep -f socat | grep " + str(pid)) != 0:
            if self.ping(host):
                self.start = self.mStartSocat(host, port, tty)
                button["bg"] = "green"
                button["text"] = "On"
                return self.start
            else:
                button["bg"] = "red"
                button["text"] = "Off"
                return pid
        else:
            return pid

    def mStartSocat(self, host, port, tty):
        self.arg = " -u -u pty,raw,echo=0,link=/dev/" + tty + " TCP:" + host + ":" + port + " & echo $!"
        self.pid = os.system("socat" + self.arg )
        os.system("ssh " + host + " blockkill cnct_nmea@" + str(port)[4:])
        os.system("ssh " + host + " unblock cnct_nmea@" + str(port)[4:])
        return self.pid

    def mStopSocat(self):
        os.system("killall -9 socat")

    def ping(self, host):
        self.ans = os.system("ping -c 2 -W 1 " + host)
        if self.ans == 0:
            return True
        else:
            return False


if __name__ == "__main__":
    MainWindow()
