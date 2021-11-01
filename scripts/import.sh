#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# IMPORT.SH
# Takes a file name and a repo name as argument; creates a new repository from archive




# Import subscripts
PATHNAME="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $PATHNAME/create.sh
. $PATHNAME/add.sh

# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

import_function() {
    # Set repo path
    REPOS=/cms/repositories

    # Check if a file was specified
    if [ ! $# -gt 1 ]
    then
        echo -e "$PREFIX No file was specified."
        return 0;
    fi
    FILE=$1

    # Check if any repository name was supplied
    if [ $# -lt 2 ]
    then
        echo -e "$PREFIX No repository name was specified."
        return 0
    fi

    # Check if repository name is valid
    if [[ $2 =~ ['.;!@#$%^&*()\/<>|:'] ]]
    then
        echo -e "$PREFIX The specified name is invalid. Avoid the following characters:"
        echo ". ; ! @ # $ % ^ & * ( ) \ / < > | :"
        return 0
    fi

    # Check if repository already exists
    if [ -e $REPOS/$2 ]
    then
        echo -e "${PREFIX} Repository \"$2\" already exists"
        return 0
    fi

    # Verify file is tar or zip
    if [ "${FILE:-7}" == ".tar.gz" ]
    then
        TYPE=tar
    elif [ "${FILE:-4}" == ".zip" ]
    then
        TYPE=zip
    else
        echo -e "${PREFIX} The archive needs to be of format .tar.gz or .zip and have the corresponding file extension."
        return 0
    fi

    # Check if tmp folder already exists, create tmp folder variable
    if [ ! -e /cms/.tmp/ ]
    then
        mkdir /cms/.tmp/
    fi
    TMP=/cms/.tmp/tmpfolder
    mkdir $TMP

    # Unzip into tmpfolder
    if[ "$TYPE" == "tar" ]
    then
        # Unpack archive
        tar xcf $FILE -C $TMP
    else
        unzip $FILE -d $TMP
    fi

    # Create new repo
    create_function $2 > /dev/null

    # Add files to repository
    ls $TMP | while read f
    do
        add_function $2 $TMP/$f
    done


}