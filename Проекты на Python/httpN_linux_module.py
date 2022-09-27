#Модуль обработки достижений
from playsound import playsound
from datetime import datetime
from tkinter import *
from sys import argv



script, username, _type, path = argv
path_to_users = path + "/temp/Achievments/"
path_to_resources = path_to_users + "Resources/"
array_achiev = open(path_to_users + username).read().splitlines()



def ShowSplash(jpg, user, _type):
    array_achiev[int(_type) - 1] = int((array_achiev[int(_type) - 1])[0:1]) + 1
    with open(path_to_users + username, "w") as file:
	    print(*array_achiev, file=file, sep="\n")
    splash = Tk()
    splash.title()
    splash.attributes('-type', 'dock')
    splash.geometry("592x98")
    splash.eval('tk::PlaceWindow . center')
    playsound(path_to_resources + "AchievmentEarned.wav", False)
    splash.after(5000, splash.destroy)
    bg = PhotoImage(file = path_to_resources + jpg)
    lab = Label(splash, image = bg)
    lab.pack()
    splash.mainloop()

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