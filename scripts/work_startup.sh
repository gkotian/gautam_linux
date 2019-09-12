#!/bin/sh

# Save a log file to analyse if something goes wrong
exec 1>/var/tmp/work_startup.log 2>&1

echo "`date`"
finish()
{
    echo "--------------------------------------------------------------"
}
trap finish EXIT

# Multi-monitor setup:
# --------------------
# The easiest way to set this up is as follows:
#     - run arandr (sudo apt install arandr)
#     - graphically position the two monitors as necessary
#     - save the profile to a temporary file
#     - cat the saved file to get the necessary xrandr line
# xrandr --output eDP-1 --primary --mode 1920x1080 --pos 1920x840 --rotate normal \
#        --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal \
#        --output HDMI-1 --off \
#        --output HDMI-2 --off

# Trackball mouse setup:
# ----------------------
#     To get the order of the buttons:
#         xinput --list "Kensington Expert Mouse" | grep "Button labels"
# Left-handed:
# xinput --set-button-map "Kensington Expert Mouse" 3 2 1 4 5 6 7 8 9
# Right-handed:
# xinput --set-button-map "Kensington Expert Mouse" 1 8 3 4 5 6 7 2 9

# Add the necessary passphrases to ssh agent
ssh-add ~/.ssh/id_rsa_work

# Launch gitk for commonly monitored projects
cd /home/gautam/work/app && gitk --all&
