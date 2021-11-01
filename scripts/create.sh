#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# CREATE.SH
# Takes a repo name as argument; creates a new repository and required files



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

create_function() {

    echo -e "$PREFIX Please note: The creation of repositories requires root/sudo access."

    # Set repo path
    REPOS=/cms/repositories

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
    sudo mkdir -p $REPOS
    sudo chmod -R 777 /cms
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
        chmod 777 file_table
        cd ..

        echo -e "$PREFIX New repository \"$1\" created at $PWD"
    fi

    return 0
}