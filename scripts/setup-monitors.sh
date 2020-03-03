#!/bin/sh

# Sets up the display(s) as necessary. In order for this script to be called
# automatically, create '/etc/udev/rules.d/95-monitor-hotplug.rules' with the
# following content:
# KERNEL=="card0", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/path/to/.Xauthority", RUN+="/path/to/setup-monitors.sh"

exec 1>>/var/tmp/setup-monitors.log 2>&1

echo "[`date`]"

if xrandr | grep "HDMI-1 disconnected"; then
    # Disconnecting triggers a message automatically, so we don't need an
    # explicit one here.

    xrandr --output eDP-1  --mode 1920x1080 --pos 0x379  --rotate normal --primary \
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

    xrandr --output eDP-1  --mode 1920x1080 --pos 0x379  --rotate normal --primary \
           --output HDMI-1 --mode 1920x1080 --pos 1920x0 --rotate normal \
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
