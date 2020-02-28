#!/bin/sh

IS_LAPTOP="YES"

GL_DIR=/home/gautam/play/gautam_linux

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
}

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

launch_one_shot_scripts ${GL_DIR}/arch-linux-packages/update-packages-lists.sh
