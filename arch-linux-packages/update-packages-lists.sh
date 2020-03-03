#!/bin/sh

# Automatically updates the list of installed packages.
# Inspired by https://bbs.archlinux.org/viewtopic.php?pid=586731#p586731

exec 1>>/var/tmp/update-packages-lists.log 2>&1

echo "[`date`]"

MACHINE_ID=$(cat /var/lib/dbus/machine-id)
if [ -z "${MACHINE_ID}" ]; then
    echo "Unable to get a machine ID. Aborting."
    exit 1
else
    echo "Machine ID: ${MACHINE_ID}"
fi

# cd to the 'gautam_linux' directory and only work with relative paths from
# there. This makes it is easier to add an autocommit later if necessary.
cd /home/gautam/play/gautam_linux

PKGS_DIR="arch-linux-packages/${MACHINE_ID}"

# Create the directory to store this computer's packages.
mkdir -p ${PKGS_DIR}

UNAME_FILE="${PKGS_DIR}/uname.txt"
FOREIGN_PKGS_FILE="${PKGS_DIR}/foreign-packages.txt"
PACMAN_PKGS_FILE="${PKGS_DIR}/pacman-packages.txt"

# If the files don't already exist (e.g. first run on a new computer), then we
# need to do an initial 'git add' so the files start getting tracked. An
# additional '--intent-to-add' flag is passed so that the files don't get staged
# immediately. This is necessary because the autocommit at the end will not work
# if there are any staged files.
[ -e "${UNAME_FILE}" ] || uname -a > ${UNAME_FILE} && git add --intent-to-add ${UNAME_FILE}
[ -e "${FOREIGN_PKGS_FILE}" ] || touch ${FOREIGN_PKGS_FILE} && git add --intent-to-add ${FOREIGN_PKGS_FILE}
[ -e "${PACMAN_PKGS_FILE}" ] || touch ${PACMAN_PKGS_FILE} && git add --intent-to-add ${PACMAN_PKGS_FILE}

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
    # At this point, it is guaranteed that at least one of the files in
    # 'PKGS_DIR' is modified, so we can simply run 'git add' on the whole
    # directory.
    git add -A ${PKGS_DIR}

    git commit --no-gpg-sign \
        --message="[AUTOCOMMIT] update lists of installed packages"

    # A nice message about the commit gets logged automatically, so we don't
    # need to explicitly echo anything. How convenient!
else
    echo "Will not add an autocommit as staged files exist."
fi

echo "-------------------------------------------------------------------------"
