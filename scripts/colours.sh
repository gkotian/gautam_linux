#!/bin/bash

# Script to show the colours used for different file types

# This is just a more readable version of the 'eval' code at:
#     http://askubuntu.com/a/17300/309899

# A nice description of the colour codes is here:
#     http://askubuntu.com/a/466203/309899

IFS=:
for SET in $LS_COLORS
do
    TYPE=$(echo $SET | cut -d"=" -f1)
    COLOUR=$(echo $SET | cut -d"=" -f2)

    case $TYPE in
        no) TEXT="Global default";;
        fi) TEXT="Normal file";;
        di) TEXT="Directory";;
        ln) TEXT="Symbolic link";;
        pi) TEXT="Named pipe";;
        so) TEXT="Socket";;
        do) TEXT="Door";;
        bd) TEXT="Block device";;
        cd) TEXT="Character device";;
        or) TEXT="Orphaned symbolic link";;
        mi) TEXT="Missing file";;
        su) TEXT="Set UID";;
        sg) TEXT="Set GID";;
        tw) TEXT="Sticky other writable";;
        ow) TEXT="Other writable";;
        st) TEXT="Sticky";;
        ex) TEXT="Executable";;
        *) TEXT="${TYPE} (TODO: get description)";;
    esac

    echo -e "\e[${COLOUR}m${TEXT}\e[0m"
done
