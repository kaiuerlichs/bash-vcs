#!/bin/bash

PREFIX="\033[0;36m[CMS]\033[0m"

create_function() {
    REPOS=$HOME/cms/repositories

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

    # Create repos folder if it doesnt exist already
    mkdir -p $REPOS
    cd $REPOS

    # Check if repository already exists
    if [ -e $1 ]
    then
        echo -e "${PREFIX} Repository \"$1\" already exists"
    else
        # Create repository folder, .cms folders and file table
        mkdir $1
        cd ./$1
        mkdir .cms
        cd ./.cms
        mkdir logs snapshots versions
        touch file_table
        cd ..

        echo -e "$PREFIX New repository \"$1\" created at $PWD"
    fi
}