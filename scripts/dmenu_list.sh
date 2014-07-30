#!/bin/sh

# Script that uses the dmenu interface to add/delete one-liner tasks.
# Obviously requires dmenu to be installed.
# Downloaded from "http://tools.suckless.org/dmenu/scripts"

# Usage:
#     $> sudo ln -s /path/to/todo.sh /usr/local/bin/todo
# then just launch dmenu and type 'todo'
# to add a task: write the task and press Enter
# to delete a task: go to it and press Enter

SB="#336699"
SF="#ccc"
NB="#111"
NF="#ccc"
FN="-*-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-*"

FILE=~/.todo
HEIGHT=$(cat $FILE | wc -l)
PROMPT="Add/delete a task"

ACTION="cat $FILE | dmenu -fn $FN -l '$HEIGHT' -nb '$NB' -nf '$NF' -sb '$SB' -sf '$SF' -p '$PROMPT:' "
CMD=$(eval $ACTION)
while [ -n "$CMD" ]; do
	grep -q "^$CMD" $FILE
	if [ $? = 0 ]; then
		grep -v "^$CMD" $FILE > /tmp/todo
		mv /tmp/todo $FILE
        HEIGHT=$(($HEIGHT-1))
        ACTION="cat $FILE | dmenu -fn $FN -l '$HEIGHT' -nb '$NB' -nf '$NF' -sb '$SB' -sf '$SF' -p '$PROMPT:' "
	else
		echo "$CMD" >> $FILE
        HEIGHT=$(($HEIGHT+1))
        ACTION="cat $FILE | dmenu -fn $FN -l '$HEIGHT' -nb '$NB' -nf '$NF' -sb '$SB' -sf '$SF' -p '$PROMPT:' "
	fi

	CMD=$(eval $ACTION)

done
exit 0
