#!/bin/sh

# Refreshes the pacman mirrorlist if it hasn't been updated for over a week.

exec 1>>/var/tmp/refresh-pacman-mirrorlist.log 2>&1

echo "[`date`]"

LAST_REFRESH_TIME=$(grep When /etc/pacman.d/mirrorlist | cut -d":" -f2-)
echo "Last mirrorlist refresh time: ${LAST_REFRESH_TIME}"

LAST_REFRESH_TS=$(date -d "${LAST_REFRESH_TIME}" +%s)
NOW_TS=$(date +%s)
TS_DIFFERENCE="$((${NOW_TS}-${LAST_REFRESH_TS}))"
echo "Last mirrorlist refresh was ${TS_DIFFERENCE} seconds ago"

SECONDS_IN_ONE_WEEK=604800
if [ ${TS_DIFFERENCE} -ge ${SECONDS_IN_ONE_WEEK} ]; then
    echo "Will update the mirrorlist"
    reflector \
        --verbose \
        --latest 100 \
        --sort rate \
        --protocol https \
        --country Germany,Czechia,Poland,Sweden,Denmark,Netherlands \
        --save /etc/pacman.d/mirrorlist
else
    echo "Will not update the mirrorlist"
fi
echo "-------------------------------------------------------------------------"
