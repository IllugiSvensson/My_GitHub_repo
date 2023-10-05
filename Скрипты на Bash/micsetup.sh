#!/bin/bash

amixer -D default -- sset PCM 0dB
amixer -D default -- sset Surround -4dB
amixer -D default -- sset Center -4dB
amixer -D default -- sset LFE -4dB
amixer -D default -- sset Side -4dB
amixer -D default -- sset Line 8dB
amixer -D default sset 'Line Boost' 20dB
amixer -D default sset Capture 12dB
amixer -D default sset Digital 10dB
amixer -D default sset 'Input Source' 'Rear Mic'

remount rw
alsactl store
remount ro