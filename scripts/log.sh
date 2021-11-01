#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# LOG.SH
# Takes a repo name and file name; displays the log for the file



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

log_function() {
    # Check if any repository name was supplied
    if [ $# -eq 0 ]
    then
        echo -e "$PREFIX No repository name was specified."
        return 0
    fi

    # Check if repository name is valid
    if [[ $1 =~ ['.;!@#$%^&*()\/<>|:'] ]]
    then
        echo -e "$PREFIX The specified name is invalid. Avoid the following characters:"
        echo ". ; ! @ # $ % ^ & * ( ) \ / < > | :"
        return 0
    fi

    REPO=/cms/repositories/$1
    # Check whether specified repository exists
    if [ ! -e $REPO ]
    then
        echo -e "$PREFIX The repository \"$1\" does not exist."
        return 0;
    fi

     # Check if any files were specified
    if [ ! $# -gt 1 ]
    then
        echo -e "$PREFIX No file was specified."
        return 0;
    fi
    FILE=$2

    # Check whether specified file exists
    if [ ! -e $REPO/$FILE ]
    then
        echo -e "$PREFIX The file \"$FILE\" does not exist."
        return 0;
    fi

    # Check if tmp folder already exists, create tmp file variable
    if [ ! -e /cms/.tmp/ ]
    then
        mkdir /cms/.tmp/
    fi
    TMP=/cms/.tmp/log

    # Create temporary log file
    echo -e "$PREFIX Displaying log file for \"$FILE\"\n" | cat - $REPO/.cms/logs/$FILE > $TMP

    # Display general log for file
    less -R $TMP

    # Remove temporary file
    rm $TMP
    
    return 0
}