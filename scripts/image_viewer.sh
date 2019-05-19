#!/bin/bash

POTENTIAL_IMAGE_VIEWERS=(eog feh gthumb ristretto shotwell)

for C in ${POTENTIAL_IMAGE_VIEWERS[@]}
do
    if [ -x "$(command -v ${C})" ]
    then
        ${C} "${1}"
        exit 0
    fi
done

POTENTIAL_IMAGE_VIEWERS_STR="${POTENTIAL_IMAGE_VIEWERS[*]}"
echo "No suitable image viewer found, tried the following: ${POTENTIAL_IMAGE_VIEWERS_STR//${IFS:0:1}/, }"
exit 1
