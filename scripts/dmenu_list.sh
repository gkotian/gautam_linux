#!/bin/sh

# Script that uses the dmenu interface to add/delete one-liner items.
# Obviously requires dmenu to be installed.
# Fork of todo.sh available at "http://tools.suckless.org/dmenu/scripts"

# Usage:
#     0. Install dmenu and place this script in a suitable place
#     1. Make a symbolic link to the script in one of the directories in PATH
#        The name of the link should signify the purpose of the list
#        e.g. for a todo list
#                 $> sudo ln -s /path/to/dmenu_list.sh /usr/local/bin/todo
#             for a list of movies
#                 $> sudo ln -s /path/to/dmenu_list.sh /usr/local/bin/movies
#     2. Launch dmenu and type the name of the intended list
#     3. Enjoy!
#
# to add an item    --> write whatever and press Enter
# to delete an item --> go to the item and press Enter
# when done         --> press Esc

SB="#336699"
SF="#ccc"
NB="#111"
NF="#ccc"
FN="-*-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-*"

LIST_NAME=$(basename $0)
FILE=~/.$LIST_NAME
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
