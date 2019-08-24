#!/bin/bash

# gitk often gets reset to its original version during an update. This script
# makes the small tweaks that I need.

# Check super-user privileges
if [[ ${EUID} -ne 0 ]]; then
   echo "This script must be run as root. Aborting." 1>&2
   exit 2
fi

# Save a copy of the original
cp /usr/bin/gitk /usr/bin/gitk.orig

# Use 5 instead of <Shift-F5> to reload commits
sed -i 's/bindmodfunctionkey Shift 5 reloadcommits$/bindkey 5 reloadcommits/g' /usr/bin/gitk

echo "Done!"
