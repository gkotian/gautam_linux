#!/bin/sh

exec 1>>/var/tmp/refresh-pacman-mirrorlist.log 2>&1

# Simply sleep for the first 10 minutes. This is to allow for any VPN
# connection, if present, to get activated.
sleep 600

echo "[`date`]"

echo -n "Checking if the internet is reachable... "
wget --quiet --tries=10 --timeout=20 --spider archlinux.org
if [[ $? -ne 0 ]]; then
    echo "NO"
    exit 1
fi
echo "YES"

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
