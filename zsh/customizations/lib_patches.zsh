# More dot aliases for going up a directory hierarchy
alias -g .......='../../../../../..'
alias -g ........='../../../../../../..'
alias -g .........='../../../../../../../..'
alias -g ..........='../../../../../../../../..'

# Alias to go to the root directory of the current git repository
alias cdr='cd $(git rev-parse --show-toplevel || echo ".")'

