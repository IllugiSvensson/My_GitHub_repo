import os

os.system('iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE')
os.system('iptables -t nat -A POSTROUTING -s 192.168.11.0/24 -j MASQUERADE')
flag = 0

f = open('/soft/HOSTNAME', 'r')
HOSTNAME = f.read(4)
f.close()

if HOSTNAME == "SRV1":
    EXT_IP1 = "192.168.100.218"
    EXT_IP2 = "192.168.199.72"
    INT_IP1 = "192.168.10.72"
    INT_IP2 = "192.168.11.72"
    flag = 2

elif HOSTNAME == "SRV2":
    EXT_IP1 = "192.168.100.222"
    EXT_IP2 = "192.168.199.74"
    INT_IP1 = "192.168.10.74"
    INT_IP2 = "192.168.11.74"
    flag = 2

LAN_IP1 = "192.168.10.12"
LAN_IP2 = "192.168.11.12"
LAN_IP3 = "192.168.10.13"
LAN_IP4 = "192.168.11.13"

if flag == 2:
    for i in LAN_IP1, LAN_IP2, LAN_IP3, LAN_IP4:
        for j in INT_IP1, INT_IP2:
            if i[0:10] == j[0:10]:
                for k in EXT_IP1, EXT_IP2:
                    os.system('iptables -t nat -A PREROUTING --dst ' + k + ' -j DNAT --to-destination ' + i)
                    os.system('iptables -t nat -A POSTROUTING --dst ' + i + ' -j SNAT --to-source ' + j)
                    os.system('iptables -t nat -A OUTPUT --dst ' + k + ' -j DNAT --to-destination ' + i)
                    INT_ETH = os.popen('ip addr show | egrep ' + j + ' | egrep -o "eth[0-9]"').read().split()
                    EXT_ETH = os.popen('ip addr show | egrep ' + k + ' | egrep -o "eth[0-9]"').read().split()
                    os.system('iptables -I FORWARD 1 -i ' + str(EXT_ETH) + ' -o ' + str(INT_ETH) + ' -d ' + str(i) + ' -j ACCEPT')

INT_IP1 = "192.168.100.0"
INT_IP2 = "192.168.199.0"
LAN_IP1 = "192.168.11.72"
LAN_IP2 = "192.168.11.74"
LAN_IP3 = "192.168.10.72"
LAN_IP4 = "192.168.10.74"

while True:
    if HOSTNAME == "KRP1" or HOSTNAME == "KRP2":
        flag = 0
        for net in LAN_IP1, LAN_IP2, LAN_IP3, LAN_IP4:
            ETH = os.popen('ip addr show | egrep ' + net[0:10] + ' | egrep -o "eth[0-9]"').read()
            while os.popen('ping -c 1 -w 10 ' + net + ' > /dev/null; echo $?').read().split() == ['0']:
                if flag == 0:
                    os.system('route add -net ' + str(INT_IP1) + ' netmask 255.255.255.0 gateway ' + str(net) + ' ' + str(ETH))
                    os.system('route add -net ' + str(INT_IP2) + ' netmask 255.255.255.0 gateway ' + str(net) + ' ' + str(ETH))
                    flag=1

            flag=0
            os.system('route del -net ' + str(INT_IP1) + ' netmask 255.255.255.0 gateway ' + str(net) + ' ' + str(ETH))
            os.system('route del -net ' + str(INT_IP2) + ' netmask 255.255.255.0 gateway ' + str(net) + ' ' + str(ETH))