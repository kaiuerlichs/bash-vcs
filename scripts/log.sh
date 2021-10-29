#!/bin/bash
# Takes a repo name and file name as parameters
# Display the log file for the specified file

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

    REPO=$HOME/cms/repositories/$1
    # Check whether specified repository exists
    if [ ! -e $REPO ]
    then
        echo -e "$PREFIX The repository \"$1\" does not exist."
        return 0;
    fi

     # Check if any files were specified
    if [ ! $# -gt 1 ]
    then
        echo -e "$PREFIX No file(s) were specified."
        return 0;
    fi
    FILES=${@:2}

    #display general log for file
    cd /cms/repositories/$REPO/.cms/logs/$FILE 
    ls

    #display common log file: messages
    tail -n 10 /cms/repositories/$REPO/.cms/logs/$FILE/messages
    ls


    }