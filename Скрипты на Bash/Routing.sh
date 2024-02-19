#!/bin/bash


function Mask {
	case `echo $1 | egrep -o "/\w{2}"` in
		"/24")
			[ "$2" == "0" ] && { echo 255.255.255.0;  }
			a=`echo $1 | egrep -o "\w{1,3}\.\w{1,3}\.\w{1,3}"`
			[ "$2" != "0" ] && { echo $a.0/24; }
			;;
		"/16")
			[ "$2" == "0" ] && { echo 255.255.0.0; }
			a=`echo $1 | egrep -o "\w{1,3}\.\w{1,3}"`
			[ "$2" != "0" ] && { echo $a.0.0/16; }
			;;
	esac
}


#Задаем правило для шлюза, как маршрутизировать трафик
if [ "GW" == "$1" ]
then

	EXT_IP="$2"	#Адрес шлюза в сети, которую нужно получить
	INT_IP="$3"	#Адрес шлюза в сети, по которой пойдет трафик
	LAN_IP="$4"	#Адрес цели, которая будет получать трафик

	sysctl net.ipv4.ip_forward=1
	iptables -t nat -A POSTROUTING -s `Mask $3 $2` -j MASQUERADE
	iptables -t nat -A PREROUTING --dst $EXT_IP -j DNAT --to-destination $LAN_IP
	iptables -t nat -A POSTROUTING --dst $LAN_IP -j SNAT --to-source ${INT_IP::-3}
	iptables -t nat -A OUTPUT --dst $EXT_IP -j DNAT --to-destination $LAN_IP
	INT_ETH=`ip addr show | egrep ${INT_IP::-3} | egrep -o 'eth[0-9]'`
	EXT_ETH=`ip addr show | egrep $EXT_IP | egrep -o 'eth[0-9]'`
	iptables -I FORWARD 1 -i $EXT_ETH -o ${INT_ETH::-3} -d $LAN_IP -j ACCEPT

#Задаем маршрут для клиента, как получать трафик
elif [ "CLIENT" == "$1" ]
then

	EXT_IP="$2"	#не нужен, поставить нолик
	INT_IP="$3"	#Сеть, которую нужно получить на клиенте
	LAN_IP="$4"	#адрес клиента
	route add -net ${INT_IP::-3} netmask `Mask $3 $2` gateway $LAN_IP $ETH

fi