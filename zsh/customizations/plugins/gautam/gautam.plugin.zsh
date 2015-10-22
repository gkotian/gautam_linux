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
  $_omz_git_git_cmd rebase -i HEAD~$1
}

#
# Aliases
# (sorted alphabetically)
#

alias gbd='git branch -d'
alias gbD='git branch -D'

alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gct='git commit -m "tmp"'

alias gd='git difftool --no-prompt'

alias gk='\gitk --all --branches&'

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
alias grum='git rebase upstream/master'

alias gs='git status'
alias gst='git stash'
alias gsta='git stash apply'
alias gsui='git submodule update --init'
alias gsuir='git submodule update --init --recursive'

