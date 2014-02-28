#!/bin/sh

# Set mouse to left-handed
xmodmap -e "pointer = 3 2 1"

# Change resolution according to office workstation
xrandr --output DP-2 --mode 2560x1440 --pos 2560x0 --rotate left --output DP-1 --mode 2560x1440 --pos 0x488 --rotate normal

