#!/bin/bash

#Output sound without Master
amixer -D default -- sset Headphone 0dB
amixer -D default -- sset PCM 0dB
amixer -D default -- sset Front 0dB
amixer -D default -- sset Surround 0dB
amixer -D default -- sset Center 0dB
amixer -D default -- sset LFE 0dB
amixer -D default -- sset Side 0dB
amixer -D default sset 'Auto-Mute Mode' 'Enabled'


#Input sound
amixer -D default -- sset Line 0dB
amixer -D default sset 'Line Boost' 10dB
amixer -D default sset Capture 30%
amixer -D default sset Digital 40%
#amixer -D default sset 'Input Source' 'Line'

amixer -D default sset 'Input Source' 'Rear Mic'
amixer -D default sset 'Rear Mic Boost' 20dB
amixer -D default -- sset 'Rear Mic' 0dB


#Exclude sound
amixer -D default -- sset 'Front Mic' -35dB
amixer -D default sset 'Front Mic Boost' 0dB
amixer -D default -- sset CD -35dB
amixer -D default -- sset 'Beep' '-35dB'
amixer -D default sset 'Capture 1' 0%
amixer -D default sset 'Input Source',1 'CD'
amixer -D default sset 'Loopback Mixing' 'Disabled'


remount rw
alsactl store
remount ro