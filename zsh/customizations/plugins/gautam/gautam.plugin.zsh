#
# Functions
#

# Rebase interactively
function reb() {
    AUTHOR_EMAIL=$(git config user.email)
    git rebase --gpg-sign=${AUTHOR_EMAIL} -i HEAD~$1
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
        git cherry-pick --gpg-sign=$(git config user.email) ${COMMIT}
        if [ $? != "0" ]
        then
            echo "That cherry-pick failed. Aborting."
            return 2
        fi
    done
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
alias cdo='cd ${PLAY_DIR}/ocean'

alias gc='git commit --verbose -S'
alias gca='git commit --amend --no-edit -S'
alias gcae='git commit --amend --verbose -S'
alias gcf='git commit -S --fixup'
alias gcp='custom-git-cherry-pick'
alias gct='git commit -m "tmp" -S'

alias gd='git difftool --no-prompt'
alias gd_cl='PAGER= git diff'

alias gk='\gitk --all --branches&'

# git latest tag
alias glt='git tag --list "v*" --sort=v:refname | tail -1'

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
alias grum='git rebase --gpg-sign=$(git config user.email) upstream/master'

alias gs='git status -s'
alias gss='git submodules-status; alert "git submodules-status done"'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop stash@{0}'
alias gsui='git submodule update --init'
alias gsuir='git submodule update --init --recursive'
