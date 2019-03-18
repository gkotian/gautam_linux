#!/bin/sh

# Save a log file to analyse if something goes wrong
exec 1>/var/tmp/g_startup.log 2>&1

MACHINE_TYPE="WORK"
IS_LAPTOP="NO"

PLAY_DIR=/home/gautam/play
GL_DIR=$PLAY_DIR/gautam_linux

if [ $MACHINE_TYPE = "PLAY" ]; then
    STARTUP_FILE=$GL_DIR/scripts/g_startup_play.sh
else
    STARTUP_FILE=/path/to/g_startup_work.sh
fi

if [ -f $STARTUP_FILE ]; then
    $STARTUP_FILE &
fi

# Log latest boot time info.
FILE=$GL_DIR/scripts/boot_times_tracker.sh
if [ -f $FILE ]; then
    $FILE &
fi

if [ ${IS_LAPTOP} = "YES" ]; then
    BATTERY_CHECKER=${GL_DIR}/scripts/check_battery.sh
    [ -f ${BATTERY_CHECKER} ] && ${BATTERY_CHECKER} &
fi
