#!/bin/sh

# Configures the i3 workspaces as necessary.

# This value should match the number of entries in the 'GITK_PROJECTS' array in
# the 'launch_all_gitk()' function in 'g_startup.sh'.
NUM_GITK_WINDOWS=0

exec 1>>/var/tmp/configure_workspaces.log 2>&1

configure_workspace() {
    local WORKSPACE_NUM=${1}
    local NUM_WINDOWS=${2:-1}
    local LAYOUT=${3:-default}

    echo -n "Moving to workspace ${WORKSPACE_NUM}... "
    i3-msg "workspace ${WORKSPACE_NUM}"

    # Shift focus to all windows one-by-one in order to turn off their urgency.
    # (Just moving to the workspace automatically focusses on the first window.)

    # The number of iterations of this loop should be one less than the number
    # of windows (as the first window has already been focussed upon).
    for (( i = 1; i < ${NUM_WINDOWS}; i++ ))
    do
        echo -n "Focussing on the next window... "
        i3-msg "focus right"
    done

    echo -n "Setting layout to ${LAYOUT}... "
    i3-msg "layout ${LAYOUT}"
}

echo "[`date`]"

# Sleep in the beginning for some time to allow all application windows to be
# launched.
sleep 3

# For workspaces with multiple windows, we need to focus upon each individual
# window and turn off its urgency, and also set the desired layout of the
# workspace. On the other hand, for workspaces with a single window, just moving
# there is sufficient.

configure_workspace 5 ${NUM_GITK_WINDOWS} "tabbed"

configure_workspace 8

# Move to workspace 7 at the end as I normally look at slack first.
configure_workspace 7

echo "-------------------------------------------------------------------------"
