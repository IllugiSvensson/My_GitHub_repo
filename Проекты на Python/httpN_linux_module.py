#Модуль обработки достижений
from playsound import playsound
from datetime import datetime
from tkinter import *
from tkinter.ttk import Progressbar
from tkinter import ttk
from sys import argv
import re



script, username, _type, path = argv
path_to_users = path + "/temp/Achievments/"
path_to_resources = path_to_users + "Resources/"
array_achiev = open(path_to_users + username).read().splitlines()



def clicked_exit():
	quit()

def clicked_next():
	global cur, string
	if cur != len(string) - 2:
		cur_Achiev.delete("all")
		cur = cur + 1
		cur_logo = PhotoImage(file = path_to_resources + str(string[cur]) + ".png")
		cur_Achiev.create_image(296, 48, image = cur_logo)
		cur_Achiev.image = cur_logo
		prev_button.configure(state=ACTIVE)
		if cur == len(string) - 2:
			next_button.configure(state=DISABLED)

def clicked_prev():
	global cur, string
	if cur != 0:
		cur_Achiev.delete("all")
		cur = cur - 1
		cur_logo = PhotoImage(file = path_to_resources + str(string[cur]) + ".png")
		cur_Achiev.create_image(296, 48, image = cur_logo)
		cur_Achiev.image = cur_logo
		next_button.configure(state=ACTIVE)
		if cur == 0:
			prev_button.configure(state=DISABLED)



def Press(event):
	global start_x, start_y
	start_x = event.x
	start_y = event.y

def Drag(event, mw):
	global start_x, start_y
	rect = re.fullmatch(r'\d+x\d+\+(?P<x>-?\d+)\+(?P<y>-?\d+)', mw.geometry()).groupdict()
	x = int(rect['x']) + (event.x - start_x)
	y = int(rect['y']) + (event.y - start_y)
	mw.geometry(f'+{x}+{y}')



def ShowSplash(jpg, user, _type):
	array_achiev[int(_type) - 1] = int((array_achiev[int(_type) - 1])[0:1]) + 1
	with open(path_to_users + username, "w") as file:
		print(*array_achiev, file=file, sep="\n")
	mainwindow = Tk()
	mainwindow.title()
	mainwindow.attributes('-type', 'dock')
	mainwindow.geometry("592x98+900+700")
	playsound(path_to_resources + "AchievmentEarned.wav", False)
	mainwindow.after(5000, mainwindow.destroy)
	bg = PhotoImage(file = path_to_resources + jpg)
	lab = Label(mainwindow, image = bg)
	lab.pack()
	lab.bind('<Button-1>', Press)
	lab.bind('<B1-Motion>', lambda event: Drag(event, mainwindow))
	mainwindow.mainloop()

def _DateDiff(d1, d2):
	d1 = datetime.strptime(d1, "%Y/%m/%d %H:%M:%S")
	d2 = datetime.strptime(d2, "%Y/%m/%d %H:%M:%S")
	return abs((d2 - d1).days)



if _type == "1":
	if int(array_achiev[0]) == 0:
		ShowSplash("1.png", username, _type)

elif _type == "2":
	a = array_achiev[1]
	dt = datetime.now()
	_NowCalc = dt.strftime("%Y/%m/%d %H:%M:%S")
	if int(a[0:1]) == 4:
		ShowSplash("2.png", username, _type)
	elif int(a[0:1]) < 5:
		if _DateDiff(a[2:], _NowCalc) == 1:
			array_achiev[1] = str(int(a[0:1]) + 1) + " " + _NowCalc
			with open(path_to_users + username, "w") as file:
				print(*array_achiev, file=file, sep="\n")
		elif _DateDiff(a[2:], _NowCalc) > 1:
			array_achiev[1] = "1 " + _NowCalc
			with open(path_to_users + username, "w") as file:
				print(*array_achiev, file=file, sep="\n")

elif _type == "3":
	if int(array_achiev[2]) == 0:
		ShowSplash("3.png", username, _type)
	elif int(array_achiev[2]) == 99:
		ShowSplash("4.png", username, _type)
	elif int(array_achiev[2]) == 999:
		ShowSplash("5.png", username, _type)
	elif int(array_achiev[2]) <= 1000:
		array_achiev[2] = int(array_achiev[2]) + 1
		with open(path_to_users + username, "w") as file:
			print(*array_achiev, file=file, sep="\n")

elif _type == "4":
	if int(array_achiev[3]) == 0:
		ShowSplash("6.png", username, _type)
	elif int(array_achiev[3]) == 99:
		ShowSplash("7.png", username, _type)
	elif int(array_achiev[3]) == 999:
		ShowSplash("8.png", username, _type)
	elif int(array_achiev[3]) <= 1000:
		array_achiev[3] = int(array_achiev[3]) + 1
		with open(path_to_users + username, "w") as file:
			print(*array_achiev, file=file, sep="\n")

elif _type == "5":
	if int(array_achiev[4]) == 0:
		ShowSplash("9.png", username, _type)
	elif int(array_achiev[4]) == 99:
		ShowSplash("10.png", username, _type)
	elif int(array_achiev[4]) == 999:
		ShowSplash("11.png", username, _type)
	elif int(array_achiev[4]) <= 1000:
		array_achiev[4] = int(array_achiev[4]) + 1
		with open(path_to_users + username, "w") as file:
			print(*array_achiev, file=file, sep="\n")

elif _type == "6":
	if int(array_achiev[5]) == 0:
		ShowSplash("12.png", username, _type)

elif _type == "7":
	if int(array_achiev[6]) == 0:
		ShowSplash("13.png", username, _type)
	elif int(array_achiev[6]) == 9:
		ShowSplash("14.png", username, _type)
	elif int(array_achiev[6]) <= 10:
		array_achiev[6] = int(array_achiev[6]) + 1
		with open(path_to_users + username, "w") as file:
			print(*array_achiev, file=file, sep="\n")

elif _type == "8":
	if int(array_achiev[7]) == 0:
		ShowSplash("15.png", username, _type)

elif _type == "9":
	if int(array_achiev[8]) == 0:
		ShowSplash("16.png", username, _type)

elif _type == "show":
	achievments = []
	start_x, start_y, cur, cnt = 0, 0, 0, 0
	x, y = 937, 378
	for i in range(9):
		if (i == 0) and (int(array_achiev[i]) >= 1):
			achievments.append(1)
			cnt = cnt + 10
		elif (i == 1) and (int(array_achiev[i][0:1]) >= 4):
			achievments.append(2)
			cnt = cnt + 50
		elif (i == 2):
			if (int(array_achiev[i]) >= 999):
				achievments.append(3)
				achievments.append(4)
				achievments.append(5)
				cnt = cnt + 85
			elif (int(array_achiev[i]) >= 99):
				achievments.append(3)
				achievments.append(4)
				cnt = cnt + 35
			elif (int(array_achiev[i]) >= 1):
				achievments.append(3)
				cnt = cnt + 10
		elif (i == 3):
			if (int(array_achiev[i]) >= 999):
				achievments.append(6)
				achievments.append(7)
				achievments.append(8)
				cnt = cnt + 85
			elif (int(array_achiev[i]) >= 99):
				achievments.append(6)
				achievments.append(7)
				cnt = cnt + 35
			elif int(array_achiev[i]) >= 1:
				achievments.append(6)
				cnt = cnt + 10
		elif (i == 4):
			if (int(array_achiev[i]) >= 999):
				achievments.append(9)
				achievments.append(10)
				achievments.append(11)
				cnt = cnt + 85
			elif (int(array_achiev[i]) >= 99):
				achievments.append(9)
				achievments.append(10)
				cnt = cnt + 35
			elif (int(array_achiev[i]) >= 1):
				achievments.append(9)
				cnt = cnt + 10
		elif (i == 5) and (int(array_achiev[i]) >= 1):
			achievments.append(12)
			cnt = cnt + 10
		elif (i == 6):
			if (int(array_achiev[i]) >= 9):
				achievments.append(13)
				achievments.append(14)
				cnt = cnt + 60
			elif (int(array_achiev[i]) >= 1):
				achievments.append(13)
				cnt = cnt + 10
		elif (i == 7) and (int(array_achiev[i]) >= 1):
			achievments.append(15)
			cnt = cnt + 10
		elif (i == 8) and (int(array_achiev[i]) >= 1):
			achievments.append(16)
			cnt = cnt + 10

	string = achievments
	string.append("end")
	mainwindow = Tk()
	mainwindow.attributes("-type", "dock")
	mainwindow.geometry("937x378+700+600")
	bckgnd = PhotoImage(file = path_to_resources + "interface/background.png")
	b_label = Label(mainwindow, image = bckgnd)
	b_label.place(x = 0, y = 0, relwidth = 1, relheight = 1)

	cur_Achiev = Canvas(mainwindow, height = 98, width = 592, bd = 0, highlightthickness = 0, bg = "black")
	cur_Achiev.place(x = 294, y = 106)
	ach_logo = PhotoImage(file = path_to_resources + "1.png")
	cur_Achiev.create_image(296, 48, image = ach_logo)

	cnt_label = Canvas(mainwindow, height = 30, width = 147, bd = 0, highlightthickness = 0, bg = "black")
	cnt_label.place(x = 426, y = 40)
	cnt_logo = PhotoImage(file = path_to_resources + "interface/cnt_achiev.png")
	cnt_label.create_image(0, 0, image = cnt_logo, anchor = N + W)
	cnt_label.create_text(65, 15, text = cnt, font = ("Friz Quadrate TT", 11), fill = "white")

	style = ttk.Style()
	style.layout("LabeledProgressbar",
		[('LabeledProgressbar.trough',
			{'children': [('LabeledProgressbar.pbar',
				{'side': 'left', 'sticky': 'ns'}),
					("LabeledProgressbar.label",
					{"sticky": "e"})],
				'sticky': 'nswe'})])
	style.configure("LabeledProgressbar", troughcolor ="#342511", background = "#035d03", darkcolor = "#035903", lightcolor = "#036e03", text = str(len(string) - 1) + str("/16"), foreground = "white")
	p_bar = Progressbar(mainwindow, length = 595, style="LabeledProgressbar", maximum = 16)
	p_bar["value"] = (len(string) - 1)
	p_bar.place(x = 291, y = 234)

	exit_logo = PhotoImage(file = path_to_resources + "interface/exit.png")
	exit_button = Button(mainwindow, command = clicked_exit, image = exit_logo, bd = 0, highlightthickness = 0, bg = "black", activebackgroun = "black")
	exit_button.place(x = 910, y = 52)

	next_logo = PhotoImage(file = path_to_resources + "interface/next.png")
	next_button = Button(mainwindow, command = clicked_next, image = next_logo, bd = 0, highlightthickness = 0, bg = "black", activebackgroun = "black")
	next_button.place(x = 704, y = 86)

	prev_logo = PhotoImage(file = path_to_resources + "interface/prev.png")
	prev_button = Button(mainwindow, command = clicked_prev, image = prev_logo, bd = 0, highlightthickness = 0, bg = "black", activebackgroun = "black")
	prev_button.place(x = 461, y = 86)
	prev_button.configure(state=DISABLED)

	b_label.bind('<Button-1>', Press)
	b_label.bind('<B1-Motion>', lambda event: Drag(event, mainwindow))
	mainwindow.mainloop()