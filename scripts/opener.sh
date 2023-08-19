#!/bin/bash

declare -A EXTENSION_APP_MAPPINGS=(
    ["go"]="bat"
    ["pl"]="bat"
    ["py"]="bat"
    ["sh"]="bat"
    ["txt"]="bat"

    ["pdf"]="evince"

    ["gif"]="img"
    ["jpg"]="img"
    ["jpeg"]="img"
    ["png"]="img"
    ["webp"]="img"

    ["xls"]="libreoffice"
    ["xlsx"]="libreoffice"

    ["mp4"]="mpv"
)

if [ $# -ne 1 ]; then
    echo "Expected exactly one argument - the file to open, got $#. Aborting."
    exit 1
fi

FILE="${1}"
if [ ! -f "${FILE}" ] ; then
    echo "'${FILE}' is not a valid file. Aborting."
    exit 1
fi

EXTENSION=${FILE##*.}

APP=${EXTENSION_APP_MAPPINGS[${EXTENSION}]}
if [ -z "${APP}" ]; then
    echo "Don't know how to open '${FILE}'..."
    exit 1
fi

${APP} "${FILE}"
