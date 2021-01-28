#!/bin/sh

exec 1>>/var/tmp/refresh-pacman-mirrorlist.log 2>&1

echo "[`date`]"

OLD_REFRESH_TIME=$(grep When /etc/pacman.d/mirrorlist | cut -d":" -f2-)
echo "Old mirrorlist refresh time: ${OLD_REFRESH_TIME}"

reflector \
    --verbose \
    --latest 100 \
    --sort rate \
    --protocol https \
    --country Germany,Austria,Belgium,Czechia,Denmark,France,Luxembourg,Netherlands,Poland,Sweden,Switzerland \
    --save /etc/pacman.d/mirrorlist

NEW_REFRESH_TIME=$(grep When /etc/pacman.d/mirrorlist | cut -d":" -f2-)
echo "New mirrorlist refresh time: ${NEW_REFRESH_TIME}"

echo "-------------------------------------------------------------------------"
