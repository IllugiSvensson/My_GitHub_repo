#!/bin/bash

while true
do

	sleep 3h
	killall -9 targets.bin
	sleep 70s
	killall -9 stand_control_panel.bin
	pkill socat
	pkill Socat
	echo "Socat killed"
	sleep 30s
	killall stand_control_panel.bin
	echo "Control panel reloaded"

done