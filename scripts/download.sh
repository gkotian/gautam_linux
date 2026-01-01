#!/bin/bash

# Run using:
#   $> /path/to/download.sh file_containing_links.txt

declare -a LINKS

mapfile -t LINKS < ${1}

for L in ${LINKS[@]}
do
    curl --remote-name ${L}
    sleep 1
done
