#!/bin/sh

# Sets up the i3 workspace layouts as necessary.

# This value should match the number of entries in the 'GITK_PROJECTS' array in
# the 'launch_all_gitk()' function in 'g_startup.sh'.
NUM_GITK_WINDOWS=2

exec 1>>/var/tmp/set_workspace_layouts.log 2>&1

echo "[`date`]"

# Sleep in the beginning for some time to allow all application windows to be
# launched.
sleep 3

echo -n "Moving to workspace 5... "
i3-msg "workspace 5"

# Shift focus to all windows one-by-one in order to turn off their urgency.
# (Just moving to the workspace automatically focusses on the first window.)
echo 'Focussing on the first window... [{"success":true}]'

# The number of iterations of this loop should be one less than the number of
# gitk windows (as the first window has already been focussed upon).
for (( i = 1; i < ${NUM_GITK_WINDOWS}; i++ ))
do
    echo -n "Focussing on the next window... "
    i3-msg "focus right"
done

echo -n "Changing layout of workspace 5 to tabbed... "
i3-msg "layout tabbed"

echo -n "Moving to workspace 8... "
i3-msg "workspace 8"

# Move to workspace 7 at the end as I normally look at slack first.
echo -n "Moving to workspace 7... "
i3-msg "workspace 7"

# OLD WAY START
# Just moving to a workspace is used to turn off the "urgency" of the window on
# that workspace (or else the workspace number in the tray will have a red
# background). On workspace 5, there will be multiple gitk windows. Just moving
# there turns off the urgency of the first one. We then need to shift focus onto
# the other gitk windows to turn off their urgency. Accordingly, the number of
# 'focus right' lines under workspace 5 should probably be one less than the
# number of gitk windows there.
# i3-msg " \
#     workspace 5; \
#     focus right; \
#     layout tabbed; \
#     workspace 7; \
#     workspace 8; \
#     workspace 1; \
# "
# OLD WAY END
