#!/bin/bash

# When opening a file is a matter of simply passing the file name as a command
# line argument to the app.
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

# When opening a file is a bit more involved and needs to be done with the help
# of a custom function for the specific file type.
declare -A EXTENSION_FUNCTION_MAPPINGS=(
    ["pfx"]="show_pfx_info"
)

show_pfx_info() {
    openssl pkcs12 -in ${1} -info
}

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
    FUNCTION=${EXTENSION_FUNCTION_MAPPINGS[${EXTENSION}]}
    if [ -z "${FUNCTION}" ]; then
        echo "Don't know how to open '${FILE}'..."
        exit 1
    fi

    ${FUNCTION} "${FILE}"
fi

${APP} "${FILE}"
