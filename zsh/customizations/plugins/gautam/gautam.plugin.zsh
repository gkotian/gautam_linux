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
    else
        echo "Aborted."
    fi
}

# Rebase interactively
function reb() {
    git rebase -i HEAD~${1}
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

function gofmt() {
    GOLANG_IMG=$(docker image ls | grep -w "^golang" | head -1)

    if [ -z "${GOLANG_IMG}" ]; then
        echo "No golang docker image found. Aborting."
        return 1
    fi

    VER=$(echo ${GOLANG_IMG} | awk '{ print $2 }')
    FINAL_IMAGE=golang:${VER}

    docker run --rm --tty \
        --mount "type=bind,source=${PWD},target=/go/src" \
		--workdir /go/src \
        ${FINAL_IMAGE} \
            /bin/sh -c "gofmt -s -w ."
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

    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME}
}

#
# Aliases
# (sorted alphabetically)
#

alias bat='upower -i $(upower -e | grep "BAT") | grep -E "state|time\ to|percentage"'

alias cdt='cd /tmp'

alias dcu='docker-compose up'
alias dils='docker image ls'
alias dps='docker ps'
alias dpsa='docker ps -a'

alias gca='git commit --amend --no-edit'
alias gcae='git commit --amend'
alias gcf='git commit --fixup'
alias gcp='custom-git-cherry-pick'
alias gct='git commit -m "tmp"'

alias gd='git difftool --no-prompt'
alias gd_cl='PAGER= git diff'

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
alias groot='cd $(git rev-parse --show-toplevel || echo ".")'
alias grs='git rebase --skip'
alias grsh='git reset HEAD'
alias grshh='git reset HEAD --hard'
alias grum='git rebase upstream/master'

alias gs='git status -s'
alias gss='git submodules-status; alert "git submodules-status done"'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='ask-for-confirmation "git stash drop stash@{0}" "Are you sure you want to drop the most recent stash?"'
alias gsui='git submodule update --init'
alias gsuir='git submodule update --init --recursive'

alias laptop_left='~/play/gautam_linux/scripts/setup-monitors.sh left'
alias laptop_right='~/play/gautam_linux/scripts/setup-monitors.sh right'
alias less='vimpager'

alias poweroff='echo "This command is disabled. Please run it with sudo." && return 1'

alias reboot='echo "This command is disabled. Please run it with sudo." && return 1'

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
