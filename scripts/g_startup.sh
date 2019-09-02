#!/bin/sh

# Save a log file to analyse if something goes wrong
exec 1>/var/tmp/g_startup.log 2>&1

MACHINE_TYPE="PLAY"
IS_LAPTOP="YES"

PLAY_DIR=/home/gautam/play
WORK_DIR=/home/gautam/work
GL_DIR=$PLAY_DIR/gautam_linux

if [ $MACHINE_TYPE = "PLAY" ]; then
    STARTUP_FILE=$GL_DIR/scripts/g_startup_play.sh
    echo "selecting play startup file '${STARTUP_FILE}'"
else
    STARTUP_FILE=${WORK_DIR}/meta/work_startup.sh
    echo "selecting work startup file '${STARTUP_FILE}'"
fi

if [ -f $STARTUP_FILE ]; then
    echo "startup file exists"
    $STARTUP_FILE &
fi

# The following are common to both WORK & PLAY machines

# Launch the signal messenger
# (assumes that the signal docker image has already been built)
docker-compose -f ${GL_DIR}/docker/signal/docker-compose.yml up -d

# Log latest boot time info.
FILE=$GL_DIR/scripts/boot_times_tracker.sh
if [ -f $FILE ]; then
    $FILE &
fi

if [ ${IS_LAPTOP} = "YES" ]; then
    BATTERY_CHECKER=${GL_DIR}/scripts/check_battery.sh
    [ -f ${BATTERY_CHECKER} ] && ${BATTERY_CHECKER} &
fi
