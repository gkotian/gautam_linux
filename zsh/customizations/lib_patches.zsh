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

# Removes the *.orig files left by kdiff3 -- probably not needed anymore
function rmorig () {
    # If there is a 'src' directory in the current working directory, then
    # restrict searching within that.
    SEARCH_DIR=$([ -d "${PWD}/src" ] && echo "src" || echo ".")

    ORIG_FILES=(`find ${SEARCH_DIR} -name "*.orig"`)
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

    echo -n "Proceed (y/n): "

    read YES_OR_NO
    if [ ${YES_OR_NO} != "y" ] && [ ${YES_OR_NO} != "Y" ]; then
        return
    fi

    for ((i = 1; i <= ${#ORIG_FILES[@]}; i+=1))
    do
        rm -f ${ORIG_FILES[$i]}
    done
}
