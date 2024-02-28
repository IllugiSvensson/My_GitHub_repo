#!/bin/bash

#remount rw
#ifconfig eth1 up
#dhclient eth1

ip route add default via 192.168.46.18 dev eth1

openvpn --config /data/Samara-Horizon/Link/client.ovpn

sleep 10s

route del -net 0.0.0.0 gw 10.28.0.1 netmask 128.0.0.0 dev tun0
route del -net 10.28.0.0 gw 0.0.0.0 netmask 255.255.255.0 dev tun0
