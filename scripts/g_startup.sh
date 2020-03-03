#!/bin/sh

# Performs various startup operations.

exec 1>>/var/tmp/g_startup.log 2>&1

echo "[`date`]"

IS_LAPTOP="YES"

launch_one_shot_scripts() {
    FILE=${1}

    if ! [ -f ${FILE} ]; then
        echo "One-shot script '${FILE}' not found."
        return 1
    fi

    ${FILE}
    RET_CODE=$?

    if [ ${RET_CODE} -ne 0 ]; then
        echo "One-shot script '${FILE}' returned ${RET_CODE}."
        return ${RET_CODE}
    fi

    echo "One-shot script '`basename ${FILE}`' ran successfully."
}

echo "Loading '~/.ssh/id_ed25519' onto the ssh-agent."
ssh-add ~/.ssh/id_ed25519

# Launch gitk for commonly monitored projects
# cd /home/gautam/play/gautam_linux && gitk --all&

GL_DIR=/home/gautam/play/gautam_linux

if [ ${IS_LAPTOP} = "YES" ]; then
    BATTERY_CHECKER=${GL_DIR}/scripts/check_battery.sh
    [ -f ${BATTERY_CHECKER} ] && ${BATTERY_CHECKER} &
fi

launch_one_shot_scripts ${GL_DIR}/arch-linux-packages/update-packages-lists.sh
launch_one_shot_scripts ${GL_DIR}/scripts/boot_times_tracker.sh

echo "-------------------------------------------------------------------------"
