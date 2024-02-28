#!/bin/bash

modprobe 8021q
remount rw

ip link add link eth0 name eth0.3999 type vlan id 3999
ip addr add 192.168.190.90/24 brd 192.168.190.255 dev eth0.3999

ip link add link eth0 name eth0.3998 type vlan id 3998
ip addr add 192.168.191.90/24 brd 192.168.191.255 dev eth0.3998

ip link add link eth0 name eth0.30 type vlan id 30
ip addr add 192.168.30.105/23 brd 192.168.30.255 dev eth0.30

ifconfig eth0 up
ip link set dev eth0.3999 up
ip link set dev eth0.3998 up
ip link set dev eth0.30 up
