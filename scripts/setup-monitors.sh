#!/bin/sh

# Sets up the display(s) as necessary. In order for this script to be called
# automatically, create '/etc/udev/rules.d/95-monitor-hotplug.rules' with the
# following content:
# KERNEL=="card0", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/path/to/.Xauthority", RUN+="/path/to/setup-monitors.sh"

LAPTOP_SIDE=right

exec 1>>/var/tmp/setup-monitors.log 2>&1

echo "[`date`]"

if xrandr | grep "HDMI-1 disconnected"; then
    # Disconnecting triggers a message automatically, so we don't need an
    # explicit one here.

    xrandr --output eDP-1  --mode 1920x1080 --rotate normal --pos 0x0 --primary \
           --output HDMI-1 --off \
           --output DP-1   --off \
           --output HDMI-2 --off

    echo "Moving all workspaces to the laptop screen"

    i3-msg --quiet '[workspace=1] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=2] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=3] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=4] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=5] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=6] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=7] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=8] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=9] move workspace to output eDP-1'
    i3-msg --quiet '[workspace=10] move workspace to output eDP-1'
else
    echo "HDMI-1 connected"

    if [ "${LAPTOP_SIDE}" = "right" ]; then
        LAPTOP_POS=1920x550
        MONITOR_POS=0x0
    else
        LAPTOP_POS=0x550
        MONITOR_POS=1920x0
    fi

    xrandr --output eDP-1  --mode 1920x1080 --rotate normal --pos ${LAPTOP_POS} --primary \
           --output HDMI-1 --mode 1920x1080 --rotate normal --pos ${MONITOR_POS} \
           --output DP-1   --off \
           --output HDMI-2 --off

    echo "Moving selected workspaces to the monitor"

    i3-msg --quiet '[workspace=1] move workspace to output HDMI-1'
    i3-msg --quiet '[workspace=2] move workspace to output HDMI-1'
    i3-msg --quiet '[workspace=5] move workspace to output HDMI-1'
    i3-msg --quiet '[workspace=7] move workspace to output HDMI-1'
    i3-msg --quiet '[workspace=8] move workspace to output HDMI-1'
fi

echo "-------------------------------------------------------------------------"
