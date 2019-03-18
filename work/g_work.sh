# Save a log file to analyse if something goes wrong
exec 1>/var/tmp/g_work.log 2>&1

# Set up the multiple monitors
# The easiest way to set this up is as follows:
#     - run arandr
#     - graphically position the two monitors as necessary
#     - save the profile to a temporary file
#     - cat the saved file to get the necessary xrandr line
xrandr --output DP-2-1 --off --output DP-2-2 --mode 2560x1440 --pos 1440x408 --rotate normal --output DP-2-3 --off --output eDP-1 --primary --mode 1920x1080 --pos 4000x1024 --rotate normal --output DP-1-2 --mode 2560x1440 --pos 0x0 --rotate left --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output DP-1-3 --off --output DP-2 --off --output DP-1-1 --off

# check in the next reboot if the below config works
# xrandr --output eDP-1  --mode 1920x1080 --pos 4000x1024 --rotate normal --primary \
#        --output DP-2-2 --mode 2560x1440 --pos 1440x408  --rotate normal \
#        --output DP-1-2 --mode 2560x1440 --pos 0x0       --rotate left \
#        --output HDMI-1 --off \
#        --output HDMI-2 --off \
#        --output DP-1   --off \
#        --output DP-1-1 --off \
#        --output DP-1-3 --off \
#        --output DP-2   --off \
#        --output DP-2-1 --off \
#        --output DP-2-3 --off

# Add the necessary passphrases to ssh agent
ssh-add ~/.ssh/id_rsa_work

# Launch gitk for commonly monitored projects
cd /home/gautam/work/thruster  && gitk --all&
cd /home/gautam/work/propulsor && gitk --all&
cd
