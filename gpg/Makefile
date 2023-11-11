# ---- Variables ---------------------------------------------------------------

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))


# ---- Targets -----------------------------------------------------------------

## Makes a fresh backup of a GPG key
backup:
	@set -e; \
	read -p "Enter the ID of the key to backup: " KEY_ID; \
	KEY_ID_SHORT=$${KEY_ID: -8}; \
	DATE_TODAY=`date +%Y-%m-%d`; \
	BACKUP_DIR=${MAKEFILE_DIR}/$${DATE_TODAY}_$${KEY_ID_SHORT}; \
	mkdir $${BACKUP_DIR}; \
	gpg --armor --export $${KEY_ID} > $${BACKUP_DIR}/public-gpg.key; \
	gpg --armor --export-secret-keys $${KEY_ID} > $${BACKUP_DIR}/secret-gpg.key; \
	gpg --export-ownertrust > $${BACKUP_DIR}/ownertrust-gpg.txt; \
	echo "GPG files backed-up to '$${BACKUP_DIR}'"

## Restore a GPG key previously backed-up using this Makefile
restore:
	@set -e; \
	read -p "Enter the directory to use for restoring the GPG key: " DIR; \
	RESTORE_DIR=${MAKEFILE_DIR}/$${DIR}
	gpg --import $${RESTORE_DIR}/secret-gpg.key; \
	gpg --import-ownertrust $${RESTORE_DIR}/ownertrust-gpg.txt; \
	echo "Restore complete (check the notes.md file to verify if everything went well)"

.PHONY: backup \
	restore


# ---- Included files ----------------------------------------------------------

# Include 'extras.Makefile' to get additional convenience variables & targets.
# (The include statement is intentionally prefixed with a '-' so it doesn't
# throw an error if 'extras.Makefile' doesn't exist.)
-include ${HOME}/.config/gkotian/extras.Makefile
