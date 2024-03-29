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

# Launches gitk for commonly monitored projects.
launch_all_gitk() {
    # When modifying this array, make sure to also set the value of
    # 'NUM_GITK_WINDOWS' appropriately in 'configure_workspaces.sh'.
    GITK_PROJECTS=(
    )

    for P in ${GITK_PROJECTS[@]}
    do
        echo "Launching gitk for ${P}"
        cd ${P} && gitk --all&
    done
}

GL_DIR=/home/gautam/play/gautam_linux

if [ ${IS_LAPTOP} = "YES" ]; then
    BATTERY_CHECKER=${GL_DIR}/scripts/check_battery.sh
    [ -f ${BATTERY_CHECKER} ] && ${BATTERY_CHECKER} &
fi

launch_all_gitk
launch_one_shot_scripts ${GL_DIR}/arch-linux-packages/update-packages-lists.sh
launch_one_shot_scripts ${GL_DIR}/scripts/boot_times_tracker.sh
launch_one_shot_scripts ${GL_DIR}/scripts/refresh_arch_linux_mirrorlist.sh

docker system prune --force

echo "-------------------------------------------------------------------------"
