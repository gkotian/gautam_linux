#!/bin/bash

# gitk wrapper that rebinds plain '5' to reload commits (default: Shift+F5).
#
# /usr/bin/gitk is owned by the git package, so patching it in place would be
# silently reverted on every git update. Instead, keep a patched copy fresh
# and run that. This script is symlinked to ~/bin/gitk (which precedes
# /usr/bin in PATH) by initial_setup.sh.
#
# The equivalent rebinding for gitk launched from PowerShell lives in
# gautam_windows/functions.ps1.

set -euo pipefail

SYSTEM_GITK="/usr/bin/gitk"
PATCHED_GITK="${HOME}/.cache/gitk-patched/gitk"

if [[ ! -x "${PATCHED_GITK}" || "${SYSTEM_GITK}" -nt "${PATCHED_GITK}" ]]; then
    mkdir -p "$(dirname "${PATCHED_GITK}")"
    sed 's/bindmodfunctionkey Shift 5 reloadcommits$/bindkey 5 reloadcommits/' \
        "${SYSTEM_GITK}" > "${PATCHED_GITK}"
    chmod +x "${PATCHED_GITK}"
    if ! grep -q 'bindkey 5 reloadcommits' "${PATCHED_GITK}"; then
        echo "gitk_wrapper: patch pattern not found in ${SYSTEM_GITK}," \
            "running unpatched gitk" 1>&2
    fi
fi

exec "${PATCHED_GITK}" "$@"
