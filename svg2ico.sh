#!/usr/bin/env bash

# -*- coding:utf-8 -*-

# Reference: https://gist.github.com/azam/3b6995a29b9f079282f3

### Static values.
cmdname=$(basename "$0")
readonly cmdname

readonly NO_ERR=0
readonly SYS_ERR=1
readonly ARG_ERR=255

# Set permission 077 when craete directories and files.
umask 077

### functions.

# Show usage.
usage () {
    echo "Usage:"
    echo "$cmdname 'file.svg' [--dry-run]"
}

# Check the command status.
check_status () {
    if [ "$1" -eq 0 ]; then
        echo "...Succeeded (return $1)."
        echo "$1"
    else
        # Never go throuth.
        echo "...Failed (return $1)."
        exit "$1"
    fi
}

### Check command exists.
if ! command -v convert &> /dev/null; then
    echo "This program uses convert command, but convert is not found..."
    echo "Should configure PATH or install imagemagick."
    echo
    echo "Install command example:"
    echo "sudo apt install imagemagick"
    exit $SYS_ERR
fi

### Check command line arguments.
debugmode=0
case $# in
    1 ) echo "--- execution mode ---" ;;
    2 )
        if [ "$2" = "--dry-run" ]; then
            debugmode=1
            echo "--- debug mode ---"
        else
            usage; exit $ARG_ERR
        fi ;;
    * ) usage ; exit $ARG_ERR ;;
esac

### Set command line arguments as variables.
svgfile=$1
outfile="favicon.ico"

if [ ! -e "$svgfile" ]; then
    echo "Abort error: svg-file(${svg-file}) is not found."
    exit $ARG_ERR
fi

# Debug
if [ $debugmode ]; then
    echo "-----"
    echo "svg-file = " "${svgfile}"
    echo "output = " "${outfile}"
    echo "-----"
fi

# Create a favicon.ico from svg-file
convertcmd="convert -density 256x256 -background transparent ${svgfile} -define icon:auto-resize -colors 256 ${outfile}"
echo "${convertcmd}"
if [ $debugmode -eq 0 ]; then
    ${convertcmd}
    check_status $?
fi

# Normal end.
exit $NO_ERR
