#!/bin/sh

# Refreshes the Arch Linux mirrorlist if it hasn't been updated for over a week.

SCRIPT_NAME=$(basename ${0})
LOG_FILE=/var/tmp/${SCRIPT_NAME%.sh}.log
exec 1>>${LOG_FILE} 2>&1

echo "[`date`]"

if [ $# -gt 1 ]; then
    echo "ERROR: Expected at most 1 argument, got $#"
    exit 1
fi

# During automatic runs, we sleep for 10 minutes in the beginning to allow for
# any VPN connection, if present, to get activated.
INITIAL_SLEEP_TIME=600

if [ $# -eq 1 ]; then
    if [ "$1" != "--manual" ]; then
        echo "ERROR: Invalid argument '$1'. Only '--manual' is accepted."
        exit 1
    else
        echo "Performing a manual run"
        INITIAL_SLEEP_TIME=0
    fi
fi

MIRRORLIST=${HOME}/.config/arch_linux_mirrorlist

if [ -f "${MIRRORLIST}" ]; then
    OLD_REFRESH_TIME=$(grep When ${MIRRORLIST} | cut -d":" -f2-)
    echo "Old mirrorlist refresh time: ${OLD_REFRESH_TIME}"

    OLD_REFRESH_TS=$(date -d "${OLD_REFRESH_TIME}" +%s)
    NOW_TS=$(date +%s)
    TS_DIFFERENCE="$((${NOW_TS}-${OLD_REFRESH_TS}))"
    echo "Last mirrorlist refresh was ${TS_DIFFERENCE} seconds ago"

    SECONDS_IN_ONE_WEEK=604800
    if [ ${TS_DIFFERENCE} -lt ${SECONDS_IN_ONE_WEEK} ]; then
        echo "Will not update the mirrorlist"
        echo "-------------------------------------------------------------------------"
        exit 0
    fi
else
    echo "Mirrorlist file '${MIRRORLIST}' not found"
fi

echo "Will update the mirrorlist"

sleep ${INITIAL_SLEEP_TIME}

echo -n "Checking if the internet is reachable... "
wget --quiet --tries=10 --timeout=20 --spider archlinux.org
if [[ $? -ne 0 ]]; then
    echo "NO"
    echo "-------------------------------------------------------------------------"
    exit 1
fi
echo "YES"

reflector \
    --verbose \
    --latest 100 \
    --sort rate \
    --protocol https \
    --country Germany,Austria,Belgium,Czechia,Denmark,France,Luxembourg,Netherlands,Poland,Sweden,Switzerland \
    --save ${MIRRORLIST}

NEW_REFRESH_TIME=$(grep When ${MIRRORLIST} | cut -d":" -f2-)
echo "New mirrorlist refresh time: ${NEW_REFRESH_TIME}"

echo "-------------------------------------------------------------------------"
