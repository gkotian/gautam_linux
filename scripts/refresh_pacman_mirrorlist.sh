#!/bin/sh

# Refreshes the pacman mirrorlist if it hasn't been updated for over a week.

exec 1>>/var/tmp/refresh_pacman_mirrorlist.log 2>&1

echo "[`date`]"

OLD_REFRESH_TIME=$(grep When /etc/pacman.d/mirrorlist | cut -d":" -f2-)
echo "Old mirrorlist refresh time: ${OLD_REFRESH_TIME}"

OLD_REFRESH_TS=$(date -d "${OLD_REFRESH_TIME}" +%s)
NOW_TS=$(date +%s)
TS_DIFFERENCE="$((${NOW_TS}-${OLD_REFRESH_TS}))"
echo "Last mirrorlist refresh was ${TS_DIFFERENCE} seconds ago"

SECONDS_IN_ONE_WEEK=604800
if [ ${TS_DIFFERENCE} -lt ${SECONDS_IN_ONE_WEEK} ]; then
    echo "Will not update the mirrorlist"
    exit 0
fi

echo "Will update the mirrorlist"

# Simply sleep for the first 10 minutes. This is to allow for any VPN
# connection, if present, to get activated.
sleep 600

echo -n "Checking if the internet is reachable... "
wget --quiet --tries=10 --timeout=20 --spider archlinux.org
if [[ $? -ne 0 ]]; then
    echo "NO"
    exit 1
fi
echo "YES"

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
