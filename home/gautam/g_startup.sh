#!/bin/sh

GL_DIR=/home/gautam/gautam_linux
TODO_FILE=/home/gautam/tmp/TODO.txt

# Sociomantic specific startup.
FILE=$GL_DIR/g_startup_sociomantic
if [ -f $FILE ]; then
    $FILE
fi

# Open the todo file, if it exists.
if [ -f $TODO_FILE ]; then
    gedit $TODO_FILE
fi

