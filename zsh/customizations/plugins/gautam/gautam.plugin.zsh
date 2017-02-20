################################################################################
#
#         git related customizations
#
################################################################################

#
# Functions
#

# Rebase interactively
function reb() {
    AUTHOR_EMAIL=$($_omz_git_git_cmd config user.email)
    $_omz_git_git_cmd rebase --gpg-sign=${AUTHOR_EMAIL} -i HEAD~$1
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

# gsf => git show file
# NEEDS MORE WORK
function gsf() {
    # Confirm that we are in a git repository
    GIT_TOP=$(git rev-parse --show-toplevel)
    RC=$?
    if [ $RC != "0" ]
    then
        return $RC
    fi

    # Confirm exact number of arguments
    if [ $# -ne 2 ]
    then
        echo "Need exactly two arguments (commit hash & file). Aborting."
        return 1
    fi

    COMMIT=$1
    FILE=$2

    # Validate the given commit
    DUMMY=$(git rev-parse --quiet --short --verify ${COMMIT})
    if [ $? != "0" ]
    then
        echo "'${COMMIT}' is not a valid git object. Aborting."
        return 1
    fi

    # First try a file glob to see if the given file exists.
    # Do it under the 'src' directory so that files in submodules are not
    # considered (the unfortunate side-effect of this is that files at the
    # top-level, e.g. Build.mak get skipped). If needed, it should be possible
    # to make a more intelligent glob using 'setopt extendedglob', but that
    # optimization is probably not needed currently.
    # If the file doesn't exist, it may still be ok; as it may exist in the
    # commit being checked (in this case of course, the proper file path becomes
    # necessary).
    GLOB_RESULT=$(ls ${GIT_TOP}/src/**/${FILE})
    if [ $? == "0" ]
    then
        FILE=${GLOB_RESULT}
    fi

    echo "git show ${COMMIT}:${FILE}"
    # git show ${COMMIT}:${FILE}
}

# gtb => git test branch
# This is not just an alias as I sometimes need to pass arguments to
# 'git-test-branch'
function gtb() {
    git-test-branch $@
    alert "git test-branch done"
}

#
# Aliases
# (sorted alphabetically)
#

alias gbd='git branch -d'
alias gbD='git branch -D'

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

alias gpo='git push origin'
alias gpod='git push origin --delete'
alias gpof='git push -f origin'

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
