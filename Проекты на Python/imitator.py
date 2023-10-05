import subprocess
import threading
import signal
import time
import os


def launch_targets():
    proc = subprocess.Popen(["launch", "targets"])
    print(proc.pid)
    time.sleep(10)
    #os.killpg(proc.pid, signal.SIGKILL)
    print("killed")

def launch_socatAZN1():
    pass

def launch_socatAZN2():
    pass

def launch_socatSRV1():
    pass

def launch_socatSRV2():
    pass

def ping(host):
    return os.system("ping -c 1 -w 10 " + host + " >/dev/null 2>&1")


if __name__ == "__main__":
    latch = 0
    while True:
        if latch == 0:
            proc = subprocess.Popen(["launch", "targets"])
            latch = 1
        elif bool(os.path.exists('/proc/' + str(proc))) == True:
            latch = 0
        time.sleep(1)

#    cnt = 0
#    while True:
#        cnt += 1
#        time.sleep(1)
#        if cnt == 10:
#            break


#targets
#stand_control
#socat


    #pass
#    targets = threading.Thread(target=launch_targets, args=())
#    targets.start()
#    launch_targets()
#    time.sleep(20)
#    os.system("killall targets.bin")
#    print(ping("srv1"))