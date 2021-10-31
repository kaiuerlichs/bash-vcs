#!/bin/bash

versions_function() {
    PREFIX="\033[0;36m[CMS]\033[0m"
    DATE=$(date "+[%d-%m-%Y | %T]")

    # Check if a repository was specified
    if [ $# -eq 0 ]
    then
        echo -e "$PREFIX No repository was specified."
        return 0;
    fi
    # Check if any of these characters are within contained within the specfied repository name
    if [[ $1 =~ ['.;!@#$%^&*()\/<>|:'] ]]
    then
        echo -e "$PREFIX The specified repository name is invalid. Avoid the following characters:"
        echo ". ; ! @ # $ % ^ & * ( ) \ / < > | :"
        return 0;
    fi
    REPO=/cms/repositories/$1
    # Check whether specified repository exists
    if [ ! -e $REPO ]
    then
        echo -e "$PREFIX The repository \"$1\" does not exist."
        return 0;
    fi

    # Check if a file was specified
    if [ ! $# -gt 1 ]
    then
        echo -e "$PREFIX No file was specified."
        return 0;
    fi
    FILE=$2
    #Check if file exists
    if [ ! -e $REPO/$FILE ]
    then 
        echo -e "$PREFIX The file \"$FILE\" does not exist in the repository."
        return 0; 
    fi

    VERSIONS=$REPO/.cms/versions/$FILE/
    VERSION_COUNT=$(ls $VERSIONS | wc -l)
    LATEST=$(date -r $REPO/$FILE "+%d-%m-%Y %H:%M:%S")

    echo -e "$PREFIX Listing versions for \"$FILE\"...\n"
    echo -e "Last file edit: $LATEST"
    echo -e "Total versions: $VERSION_COUNT"

    if [ $VERSION_COUNT -ne 0 ]
    then
        echo -e "\nVersions saved for the following timestamps: "
        ls $VERSIONS | while read ver
        do
            echo -e "\t$ver"
        done
    fi
}