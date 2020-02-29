#!/bin/sh

# Automatically updates the list of installed packages.
# Inspired by https://bbs.archlinux.org/viewtopic.php?pid=586731#p586731

exec 1>>/var/tmp/update-packages-lists.log 2>&1

echo "[`date`]"

# cd to the 'gautam_linux' directory and only work with relative paths from
# there. This makes it is easier to add an autocommit later if necessary.
cd /home/gautam/play/gautam_linux

FOREIGN_PKGS_FILE="arch-linux-packages/foreign-packages.txt"
PACMAN_PKGS_FILE="arch-linux-packages/pacman-packages.txt"

TMPFILE=$(mktemp)

NO_CHANGES_1="false"
NO_CHANGES_2="false"

# First deal with the foreign packages
pacman -Qqm > ${TMPFILE}
OUTPUT=$(diff -u ${FOREIGN_PKGS_FILE} ${TMPFILE})
if [ -n "${OUTPUT}" ]; then
    # Note that we copy (and not move) the temp file, as we need the temp file
    # later when dealing with the explicitly installed packages.
    cp ${TMPFILE} ${FOREIGN_PKGS_FILE}
    echo "Foreign packages list updated with:"
    echo "\`\`\`diff"
    echo "${OUTPUT}"
    echo "\`\`\`"
else
    echo "No changes to the foreign packages list."
    NO_CHANGES_1="true"
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
    NO_CHANGES_2="true"
fi

if [ ${NO_CHANGES_1} = "true" ] && [ ${NO_CHANGES_2} = "true" ]; then
    echo "-------------------------------------------------------------------------"
    exit 0
fi

# Add an autocommit if either of the package lists are modified. But only
# do that if nothing is already staged in order to avoid inadvertently
# auto-committing something unrelated.
git diff --cached --quiet
if [ $? -eq 0 ]; then
    git diff --exit-code --no-patch ${FOREIGN_PKGS_FILE}
    if [ $? -ne 0 ]; then
        git add ${FOREIGN_PKGS_FILE}
    fi

    git diff --exit-code --no-patch ${PACMAN_PKGS_FILE}
    if [ $? -ne 0 ]; then
        git add ${PACMAN_PKGS_FILE}
    fi

    git commit --no-gpg-sign \
        --message="[AUTOCOMMIT] update lists of installed packages"

    # A nice message about the commit gets logged automatically, so we don't
    # need to explicitly echo anything. How convenient!
else
    echo "Will not add an autocommit as staged files exist."
fi

echo "-------------------------------------------------------------------------"
