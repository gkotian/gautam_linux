# More dot aliases for going up a directory hierarchy
alias -g .......='../../../../../..'
alias -g ........='../../../../../../..'
alias -g .........='../../../../../../../..'
alias -g ..........='../../../../../../../../..'

# Alias to go to the root directory of the current git repository
alias cdroot='cd $(git rev-parse --show-toplevel || echo ".")'

function tounixtime () {
    if [ $# -eq 0 ]; then
        date -u +%s
    else
        date -u -d"$@" +%s
    fi
}

function fromunixtime () {
    # To keep converting, use:
    #     while 1; do echo -n "Enter timestamp to convert: "; read TS; fromunixtime ${TS}; done
    if [ $# -eq 0 ]; then
        date -u
    else
        date -u -d@$@
    fi
}

# Removes the *.orig files left by kdiff3
function rmorig () {
    ORIG_FILES=(`find . -name "*.orig"`)
    NUM_ORIG_FILES=${#ORIG_FILES[@]}

    if [ ${NUM_ORIG_FILES} -eq 0 ]
    then
        echo "No '*.orig' files found. Nothing to do."
        return
    fi

    PLURAL_CHARACTER=$([ "${#ORIG_FILES[@]}" -eq 1 ] && echo "" || echo "s")

    echo "The following ${#ORIG_FILES[@]} file${PLURAL_CHARACTER} will be deleted:"

    for ((i = 1; i <= ${#ORIG_FILES[@]}; i+=1))
    do
        echo "    ${ORIG_FILES[$i]}"
    done

    read "?Continue? (Y/n): " YES_OR_NO
    if [ ! -z "${YES_OR_NO}" ]; then
        [[ "${YES_OR_NO}" != [yY] ]] && echo "Canceled." && return
    fi

    rm -f ${ORIG_FILES}
}
