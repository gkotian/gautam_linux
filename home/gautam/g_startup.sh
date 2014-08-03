#!/bin/sh

GL_DIR=/home/gautam/gautam_linux

# Sociomantic specific startup.
FILE=$GL_DIR/g_startup_sociomantic
if [ -f $FILE ]; then
    $FILE
fi

