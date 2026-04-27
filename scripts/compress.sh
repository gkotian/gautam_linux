#!/bin/bash

set -u

PROGRAM_NAME=$(basename "$0")

usage() {
    cat <<EOF
Usage: ${PROGRAM_NAME} [--tarxz|--targz|--tarbz2|--tar|--zip] [-o ARCHIVE] file1 [file2 ...]

Create an archive from one or more files/directories.

Options:
    --tarxz       Create a .tar.xz archive (default)
    --targz       Create a .tar.gz archive
    --tarbz2      Create a .tar.bz2 archive
    --tar         Create an uncompressed .tar archive
    --zip         Create a .zip archive
    -o, --output  Write to ARCHIVE instead of a temporary file
    -h, --help    Show this help text
EOF
}

error() {
    echo "ERROR: $*" >&2
}

require_command() {
    local cmd="${1}"

    if ! command -v "${cmd}" >/dev/null 2>&1; then
        error "Required command '${cmd}' not found"
        exit 1
    fi
}

set_format() {
    local requested_format="${1}"

    if [ "${FORMAT_SPECIFIED}" = "true" ] && [ "${FORMAT}" != "${requested_format}" ]; then
        error "Multiple archive formats specified"
        exit 1
    fi

    FORMAT="${requested_format}"
    FORMAT_SPECIFIED=true
}

FORMAT=tarxz
FORMAT_SPECIFIED=false
OUTPUT=""
declare -a INPUTS=()

while [ "$#" -gt 0 ]; do
    case "${1}" in
        --tarxz)
            set_format tarxz
            ;;
        --targz)
            set_format targz
            ;;
        --tarbz2)
            set_format tarbz2
            ;;
        --tar)
            set_format tar
            ;;
        --zip)
            set_format zip
            ;;
        -o|--output)
            shift
            if [ "$#" -eq 0 ]; then
                error "Missing argument for --output"
                usage >&2
                exit 1
            fi
            OUTPUT="${1}"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            while [ "$#" -gt 0 ]; do
                INPUTS+=("${1}")
                shift
            done
            break
            ;;
        -*)
            error "Unknown option '${1}'"
            usage >&2
            exit 1
            ;;
        *)
            INPUTS+=("${1}")
            ;;
    esac
    shift
done

if [ "${#INPUTS[@]}" -lt 1 ]; then
    error "No input files/directories given"
    usage >&2
    exit 1
fi

for item in "${INPUTS[@]}"; do
    if [ ! -e "${item}" ]; then
        error "Cannot access '${item}': No such file or directory"
        exit 1
    fi
done

case "${FORMAT}" in
    tarxz)
        SUFFIX=.tar.xz
        ;;
    targz)
        SUFFIX=.tar.gz
        ;;
    tarbz2)
        SUFFIX=.tar.bz2
        ;;
    tar)
        SUFFIX=.tar
        ;;
    zip)
        SUFFIX=.zip
        ;;
    *)
        error "Unsupported archive format '${FORMAT}'"
        exit 1
        ;;
esac

if [ -n "${OUTPUT}" ]; then
    ARCHIVE="${OUTPUT}"
    if [ -e "${ARCHIVE}" ]; then
        error "Output file '${ARCHIVE}' already exists"
        exit 1
    fi
else
    # zip updates an existing archive, so an empty mktemp file is treated as a
    # corrupt zip. Give it a fresh path inside a temporary directory instead.
    if [ "${FORMAT}" = "zip" ]; then
        TEMP_DIR=$(mktemp -d)
        if [ -z "${TEMP_DIR}" ]; then
            error "Could not create temporary directory"
            exit 1
        fi
        ARCHIVE="${TEMP_DIR}/archive${SUFFIX}"
    else
        ARCHIVE=$(mktemp --suffix="${SUFFIX}")
        if [ -z "${ARCHIVE}" ]; then
            error "Could not create temporary file"
            exit 1
        fi
    fi
fi

case "${FORMAT}" in
    tarxz)
        require_command tar
        tar --create --xz --file="${ARCHIVE}" -- "${INPUTS[@]}"
        ;;
    targz)
        require_command tar
        tar --create --gzip --file="${ARCHIVE}" -- "${INPUTS[@]}"
        ;;
    tarbz2)
        require_command tar
        tar --create --bzip2 --file="${ARCHIVE}" -- "${INPUTS[@]}"
        ;;
    tar)
        require_command tar
        tar --create --file="${ARCHIVE}" -- "${INPUTS[@]}"
        ;;
    zip)
        require_command zip
        zip --recurse-paths --quiet "${ARCHIVE}" -- "${INPUTS[@]}"
        ;;
esac

if [ "$?" -ne 0 ]; then
    error "Failed to create archive"
    exit 1
fi

echo "Created archive '${ARCHIVE}'"
