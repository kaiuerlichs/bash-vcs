#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# REMOVE.SH
# Takes a repo name and file name as arguments, removes the file and linked files from repo



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

remove_function() {
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

    # Validate if file exists
    if [ -f $FILE ]; then
        # Check if file is checked out
        FILESTATE=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 2)
        if [ "$FILESTATE" == "out" ]
        then
            echo -e "$PREFIX Cannot delete a file which is already checked out."
            return 0;
        fi

        # Get confirmation the user wants to proceed
        read -p "$(echo -e "$PREFIX Are you sure you want to delete this file permanently? [y/N] ")" option
        case $option in
            [Yy]* ) 
                # Remove files
                rm $REPO/$FILE
                rm $REPO/.cms/logs/$FILE
                rm -R $REPO/.cms/versions/$FILE

                # Remove file table entry
                line=$(grep $FILE $REPO/.cms/file_table)
                sed -i "/$line/d" $REPO/.cms/file_table

                echo -e "$PREFIX File was successfully deleted!"
                ;;
            * )
                # Abort
                echo -e "$PREFIX Aborting file delete..."
                ;;
        esac
    else
        echo -e "$PREFIX The file \"$FILE\" does not exist in the repository." 
    fi

    return 0
}