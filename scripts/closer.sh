#!/bin/sh

BASE_DIR=$(dirname $0)
ICONS_DIR=${BASE_DIR}/../misc/images/icons
LOCK_SCREEN_IMG=${BASE_DIR}/../misc/images/archlinux/arch07.png

# Buttons are arranged in increasing order of the "severity" of the operation.
yad \
    --button=" Lock!${ICONS_DIR}/lock.png":1 \
    --button=" Suspend!${ICONS_DIR}/suspend.png":2 \
    --button=" Logout!${ICONS_DIR}/logout.png":3 \
    --button=" Reboot!${ICONS_DIR}/reboot.png":4 \
    --button=" Shutdown!${ICONS_DIR}/shutdown.png":5 \
    --on-top \
    --width=500 \
    --buttons-layout=spread \
    --timeout=4 --timeout-indicator=top
RET=$?

case ${RET} in
    1) CMD="i3lock --tiling --image=${LOCK_SCREEN_IMG}" ;;
    2) CMD="systemctl suspend" ;;
    3) CMD="i3-msg exit" ;;
    4) CMD="reboot" ;;
    5) CMD="poweroff" ;;
    *) CMD="" ;;
esac

${CMD}
