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
    GITK_PROJECTS=(
        ${HOME}/work/enercity/dashboard
        ${HOME}/work/enercity/db_checker
    )

    for P in ${GITK_PROJECTS[@]}
    do
        echo "Launching gitk for ${P}"
        cd ${P} && gitk --all&
    done
}

create_tags_files() {
    TAGS_PROJECTS=(
        ${HOME}/work/enercity/dashboard
        ${HOME}/work/enercity/db_checker
    )

    for P in ${TAGS_PROJECTS[@]}
    do
        echo "Generating tags for ${P}"
        cd ${P} && ctags -R
    done
}

GL_DIR=/home/gautam/play/gautam_linux

if [ ${IS_LAPTOP} = "YES" ]; then
    BATTERY_CHECKER=${GL_DIR}/scripts/check_battery.sh
    [ -f ${BATTERY_CHECKER} ] && ${BATTERY_CHECKER} &
fi

launch_one_shot_scripts ${GL_DIR}/arch-linux-packages/update-packages-lists.sh
launch_one_shot_scripts ${GL_DIR}/scripts/boot_times_tracker.sh
launch_all_gitk
create_tags_files

echo "-------------------------------------------------------------------------"
