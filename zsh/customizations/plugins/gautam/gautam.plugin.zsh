#
# Functions
#

# Ask for confirmation before running a command.
function ask-for-confirmation() {
    readonly CMD=${1:?"A command must be specified."}
    readonly PROMPT_STR="${2:-Are you sure?}"

    read "RESPONSE?${PROMPT_STR} [y/N] "

    if [[ "${RESPONSE}" =~ ^[Yy]$ ]]; then
        eval ${CMD}
        return $? # propagate the command's exit code
    else
        echo "Cancelled."
        return 1 # return non-zero code to signal cancellation
    fi
}

# Rebase interactively
function reb() {
    git rebase -i HEAD~${1}
}

function gitResetBranch() {
    local branch_name="${1}"
    local current_branch
    local default_remote_branch
    local commit_hash

    current_branch=$(git branch --show-current 2>/dev/null)
    if [ $? != "0" ]; then
        return 1
    fi

    if [ -z "${branch_name}" ]; then
        read "branch_name?Enter the name of the branch to reset (leave empty for '${current_branch}'): "
        if [ -z "${branch_name}" ]; then
            branch_name="${current_branch}"
        fi
    fi

    if [ -z "${branch_name}" ]; then
        echo "Could not determine a branch name. Aborting."
        return 1
    fi

    default_remote_branch="origin/${branch_name}"
    read "commit_hash?Enter the commit hash to set '${branch_name}' to (leave empty for '${default_remote_branch}'): "
    if [ -z "${commit_hash}" ]; then
        commit_hash="${default_remote_branch}"
    fi

    git checkout -B "${branch_name}" "${commit_hash}"
}

function rbm() {
    local branch_name

    if git rev-parse --verify --quiet main >/dev/null || git rev-parse --verify --quiet origin/main >/dev/null; then
        branch_name="main"
    elif git rev-parse --verify --quiet master >/dev/null || git rev-parse --verify --quiet origin/master >/dev/null; then
        branch_name="master"
    else
        echo "Could not find 'main' or 'master'. Aborting."
        return 1
    fi

    gitResetBranch "${branch_name}"
}

function changeFilePermissionsWindowsToWSL() {
    chmod -x ${1}
    chmod go-w ${1}
}

compare_files() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: compare_files <file1> <file2>"
        return 1
    fi

    if [[ ! -f "$1" || ! -f "$2" ]]; then
        echo "Error: Both arguments must be valid files"
        return 1
    fi

    hash1=$(tr -d '\r' < "$1" | md5sum | cut -d' ' -f1)
    hash2=$(tr -d '\r' < "$2" | md5sum | cut -d' ' -f1)

    if [[ "$hash1" == "$hash2" ]]; then
        echo "The files are identical"
        return 0
    else
        echo "The files are different"
        return 1
    fi
}

# Git cherry-pick one or more commits
function custom-git-cherry-pick() {
    # Confirm that we are in a git repository
    GIT_TOP=$(git rev-parse --show-toplevel)
    RC=$?
    if [ $RC != "0" ]
    then
        return $RC
    fi

    if [ $# -lt 1 ]
    then
        echo "Need at least one commit to cherry-pick. Aborting."
        return 1
    fi

    # Validate all given commits
    for COMMIT in "$@"
    do
        DUMMY=$(git rev-parse --quiet --short --verify ${COMMIT})
        if [ $? != "0" ]
        then
            echo "'${COMMIT}' is not a valid git object. Aborting."
            return 1
        fi
    done

    for COMMIT in "$@"
    do
        git cherry-pick ${COMMIT}
        if [ $? != "0" ]
        then
            echo "That cherry-pick failed. Aborting."
            return 2
        fi
    done
}

function dcinspect() {
    if [ $# -ne 1 ]; then
        echo "Expected exactly one argument (the container name), got $#"
        return 1
    fi
    docker container inspect ${1} | bat
}

function dninspect() {
    if [ $# -ne 1 ]; then
        echo "Expected exactly one argument (the network name), got $#"
        return 1
    fi
    docker network inspect ${1} | bat
}

# TODO: figure out why 'gd' still points to the 'git difftool --no-prompt' alias
# and not this function.
function gd () {
    if [ $# -lt 2 ]
    then
        echo "Too few arguments"
        return 1
    elif [ $# -gt 3 ]
    then
        echo "Too many arguments"
        return 1
    fi

    REF1=${1}
    REF2=${2}

    if [ $# -eq 3 ]
    then
        if [ ${3} != "copy" ]
        then
            echo "If present, the third argument can only be 'copy'"
        else
            COPY=true
        fi
    fi

    git difftool --no-prompt ${REF1} ${REF2}

    if [ ${COPY} = true ]
    then
        git diff ${REF1} ${REF2} | github-diff
    fi
}

function get_docker_image() {
    local REPOSITORY=${1}

    IMG=$(docker image ls | grep -w "^${REPOSITORY}" | head -1)
    if [ -z "${IMG}" ]; then
        echo ""
        return
    fi

    TAG=$(echo ${IMG} | awk '{ print $2 }')

    IMG_WITH_TAG=${REPOSITORY}:${TAG}

    echo ${IMG_WITH_TAG}
}

# gtb => git test branch
# This is not just an alias as I sometimes need to pass arguments to
# 'git-test-branch'
function gtb() {
    git-test-branch $@
    alert "git test-branch done"
}

# de => docker exec
function de() {
    CONTAINER_NAME=${1}

    if [ $# -eq 2 ]
    then
        CMD=${2}
    else
        CMD="bash"
    fi

    docker exec -it ${CONTAINER_NAME} ${CMD}
}

# dcipaddr => docker container IP address
function dcipaddr() {
    CONTAINER_NAME=${1}

    docker container inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME}
}

# dcexecsh => docker container exec shell
function dcexecsh() {
    CONTAINER_NAME=${1}

    # First try 'bash' as the shell, and if it doesn't exist, try 'sh'.
    docker container exec --interactive --tty ${CONTAINER_NAME} bash
    if [ "$?" != "0" ]; then
        docker container exec --interactive --tty ${CONTAINER_NAME} sh
    fi
}

function sortinplace() {
    FILE_NAME=${1}
    sort ${FILE_NAME} -o ${FILE_NAME}
}

function venv() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "Already in virtual environment '${VIRTUAL_ENV}', nothing to do."
        return
    fi

    if [ $# -gt 1 ]; then
        echo "ERROR: too many arguments, expected at most one."
        return
    fi

    if [ -n "${1}" ]; then
        VENV_NAME=${1}
    else
        # TODO: ask user for confirmation
        VENV_NAME=$(basename ${PWD})
    fi
    VENV_PATH=/tmp/venv_${VENV_NAME}

    if [ -d "${VENV_PATH}" ]; then
        echo "Using the existing virtual environment '${VENV_PATH}'"
    else
        echo "Creating a new virtual environment '${VENV_PATH}'"
        python -m venv ${VENV_PATH}
    fi

    source ${VENV_PATH}/bin/activate
}

function delete_current_venv() {
    if [ -z "${VIRTUAL_ENV}" ]; then
        echo "Not currently in a virtual environment, nothing to do."
        return
    fi

    ask-for-confirmation \
        "deactivate; rm -rf ${VIRTUAL_ENV}" \
        "Are you sure you want to delete the virtual environment '${VIRTUAL_ENV}'?" \
    && echo "Virtual environment deleted."
}

#
# Aliases
# (sorted alphabetically)
#

alias b='bat'
alias batttery='upower -i $(upower -e | grep "BAT") | grep -E "state|time\ to|percentage"'

alias cdt='cd /tmp'
alias cdtt='mkdir -p /tmp/tmp && cd /tmp/tmp'
alias cet='TZ=Europe/Berlin date'
alias cest='TZ=Europe/Berlin date'

alias dclogs='docker container logs'
alias dcexec='docker container exec'
alias dcps='docker container ps'
alias dcpsa='docker container ps -a'
alias dcrm='docker container rm'
alias dcrun='docker container run'
alias dcstop='docker container stop'
alias dils='docker image ls'
alias dirm='docker image rm'
alias dncreate='docker network create'
alias dnls='docker network ls'
alias dnrm='docker network rm'

alias FindFilesWithTrailingWhitespace='grep --binary-files=without-match -rlP "\s+$" .'
alias FindFilesWithDosLineEndings="grep --binary-files=without-match -rl $'\r' ."

alias gca='git commit --amend --no-edit'
alias gcae='git commit --amend'
alias gcf='git commit --fixup'
alias gcp='custom-git-cherry-pick'
alias gct='git commit -m "tmp"'

alias gd_gui='git difftool --no-prompt'

alias gk='\gitk --all --branches&'

# git latest tag
alias glt='git tag --list "v*" --sort=v:refname | tail -1'

alias gopass='docker run --rm -it -v ${HOME}:/root gopass'

alias gpf='git push fork'
alias gpff='git push fork -f'
alias gpo='git push origin'
alias gpof='git push origin -f'

alias gr='git rebase -i HEAD~'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grm='git remote -v'
alias grma='git remote add'
alias grmr='git remote remove'
alias grmset='git remote set-url'
alias grmu='git remote update -p'
alias grom='git rebase origin/master'
alias groot='cd $(git rev-parse --show-toplevel || echo ".")'
alias grs='git rebase --skip'
alias grsh='git reset HEAD'
alias grshh='git reset HEAD --hard'

alias gs='git status -s'
alias gss='git submodules-status; alert "git submodules-status done"'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='ask-for-confirmation "git stash drop stash@{0}" "Are you sure you want to drop the most recent stash?"'
alias gsui='git submodule update --init'
alias gsuir='git submodule update --init --recursive'

alias ist='TZ=Asia/Kolkata date'

alias laptop_down='~/play/gautam_linux/scripts/setup-monitors.sh down'
alias laptop_left='~/play/gautam_linux/scripts/setup-monitors.sh left'
alias laptop_right='~/play/gautam_linux/scripts/setup-monitors.sh right'

alias poweroff='echo "This command is intentionally disabled. (It can only be run as root.)" && return 1'

alias rb='gitResetBranch'
alias reboot='echo "This command is intentionally disabled. (It can only be run as root.)" && return 1'

# Three special things are done when playing sounds:
#   1. 'stderr' is redirected to /dev/null to suppress aplay's output.
#   2. The process is started in the background (using '&') so that control
#      returns immediately to the command prompt (the delay becomes noticeable
#      when playing longer sounds of ~1s duration).
#   3. Parentheses are used to start the process in a subshell, in order to
#      suppress printing the PID (and also later on the "done" message) when the
#      process is sent to the background.
alias sound-drop='(aplay ~/play/gautam_linux/misc/sounds/drop.wav 2>/dev/null &)'
alias sound-complete='(aplay ~/play/gautam_linux/misc/sounds/complete.wav 2>/dev/null &)'

alias utc='date -u'
alias uuid='/usr/bin/uuidgen'
