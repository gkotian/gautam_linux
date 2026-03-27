#!/bin/bash

# Use this mapping when opening a file is straightforward (i.e. when it is a
# matter of simply passing the file name as a command line argument to the app).
declare -A EXTENSION_APP_MAPPINGS=(
    ["cs"]="bat"
    ["csv"]="bat"
    ["go"]="bat"
    ["json"]="bat"
    ["log"]="bat"
    ["md"]="bat"
    ["pl"]="bat"
    ["py"]="bat"
    ["sh"]="bat"
    ["txt"]="bat"
    ["xml"]="bat"
    ["yaml"]="bat"
    ["yml"]="bat"

    ["pdf"]="evince"

    ["gif"]="img"
    ["jpg"]="img"
    ["jpeg"]="img"
    ["png"]="img"
    ["svg"]="img"
    ["webp"]="img"

    ["doc"]="libreoffice"
    ["docx"]="libreoffice"
    ["xls"]="libreoffice"
    ["xlsx"]="libreoffice"

    ["m4a"]="mpv"
    ["mkv"]="mpv"
    ["mp4"]="mpv"
)

# Use this mapping when opening a file is a bit more involved (i.e. when it
# needs to be done with the help of a custom function for the specific file
# type.)
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

EXTENSION=${FILE##*.}    # Get the extension
EXTENSION=${EXTENSION,,} # Lowercase it

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
