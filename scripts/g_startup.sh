#!/bin/sh

IS_LAPTOP="YES"

GL_DIR=/home/gautam/play/gautam_linux

# Load the SSH passphrase onto the ssh-agent.
ssh-add ~/.ssh/id_ed25519

# Launch gitk for commonly monitored projects
# cd /home/gautam/play/gautam_linux && gitk --all&

if [ ${IS_LAPTOP} = "YES" ]; then
    BATTERY_CHECKER=${GL_DIR}/scripts/check_battery.sh
    [ -f ${BATTERY_CHECKER} ] && ${BATTERY_CHECKER} &
fi

# Log latest boot time info.
FILE=${GL_DIR}/scripts/boot_times_tracker.sh
if [ -f ${FILE} ]; then
    ${FILE} &
fi
