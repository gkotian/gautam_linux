#!/bin/bash

POTENTIAL_CALCULATORS=(gnome-calculator mate-calculator mate-calc)

for C in ${POTENTIAL_CALCULATORS[@]}
do
    if [ -x "$(command -v ${C})" ]
    then
        ${C} &
        exit 0
    fi
done

exit 1
