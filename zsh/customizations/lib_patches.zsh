# More dot aliases for going up a directory hierarchy
alias -g .......='../../../../../..'
alias -g ........='../../../../../../..'
alias -g .........='../../../../../../../..'
alias -g ..........='../../../../../../../../..'

# Alias to go to the root directory of the current git repository
alias cdr='cd $(git rev-parse --show-toplevel || echo ".")'

function tounixtime () {
    if [ $# -eq 0 ]; then
        date -u +%s
    else
        date -u -d"$@" +%s
    fi
}

function fromunixtime () {
    if [ $# -eq 0 ]; then
        date -u
    else
        date -u -d@$@
    fi
}

