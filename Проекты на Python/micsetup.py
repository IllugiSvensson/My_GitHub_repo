import os

os.system('amixer -D default -- sset PCM 0dB')
os.system('amixer -D default -- sset Surround -4dB')
os.system('amixer -D default -- sset Center -4dB')
os.system('amixer -D default -- sset LFE -4dB')
os.system('amixer -D default -- sset Side -4dB')
os.system('amixer -D default -- sset Line 8dB')
os.system("amixer -D default sset 'Line Boost' 20dB")
os.system('amixer -D default sset Capture 12dB')
os.system('amixer -D default sset Digital 10dB')
os.system("amixer -D default sset 'Input Source' 'Rear Mic'")

os.system('remount rw')
os.system('alsactl store')
os.system('remount ro')