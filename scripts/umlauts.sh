#!/bin/bash

if [ $# -eq 0 ]; then
    echo "ä    ö    ü    ß    €    ₹"
else
    case $1 in
        a) CHAR="ä" ;;
        o) CHAR="ö" ;;
        u) CHAR="ü" ;;
        s) CHAR="ß" ;;
        e) CHAR="€" ;;
        r) CHAR="₹" ;;
        *) echo "unrecognized option '$1'... [ä, ö, ü, ß, €, ₹]"
           exit 1 ;;
    esac

    echo -n "${CHAR}" | xclip -selection clipboard
    echo "Copied ${CHAR} to the clipboard"
fi
