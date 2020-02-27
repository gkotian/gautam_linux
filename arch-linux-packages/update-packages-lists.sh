#!/bin/sh

# Automatically updates the list of installed packages.
# Inspired by https://bbs.archlinux.org/viewtopic.php?pid=586731#p586731

exec 1>>/var/tmp/update-packages-lists.log 2>&1

echo "[`date`]"

DIRNAME=$(dirname ${0})

FOREIGN_PKGS_FILE=${DIRNAME}/foreign-packages.txt
PACMAN_PKGS_FILE=${DIRNAME}/pacman-packages.txt

TMPFILE=$(mktemp)

# First deal with the foreign packages
pacman -Qqm > ${TMPFILE}
OUTPUT=$(diff -u ${FOREIGN_PKGS_FILE} ${TMPFILE})
if [ -n "${OUTPUT}" ]; then
    # Note that we copy (and not move) the temp file here, as we need the temp
    # file later when dealing with the explicitly installed packages.
    cp ${TMPFILE} ${FOREIGN_PKGS_FILE}
    echo "Foreign packages list updated with:"
    echo "\`\`\`diff"
    echo "${OUTPUT}"
    echo "\`\`\`"
else
    echo "No changes to the foreign packages list."
fi

# Then deal with the explicitly installed packages. These will contain some of
# the foreign packages, so they must be "subtracted" appropriately.
pacman -Qqe | grep -v "$(cat ${TMPFILE})" > ${TMPFILE}
OUTPUT=$(diff -u ${PACMAN_PKGS_FILE} ${TMPFILE})
if [ -n "${OUTPUT}" ]; then
    mv -f ${TMPFILE} ${PACMAN_PKGS_FILE}
    echo "Pacman packages list updated with:"
    echo "\`\`\`diff"
    echo "${OUTPUT}"
    echo "\`\`\`"
else
    echo "No changes to the pacman packages list."
fi

echo "-------------------------------------------------------------------------"
