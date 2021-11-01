#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# CHECKOUT.SH
# Takes a repo name and file name as arguments; marks the file as checked out and provides the user with a copy in PWD



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

checkout_function() {
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

    # Set destination parameter
    if [ $# -gt 2 ]
    then
        DEST=$3
    else
        DEST=./
    fi

    # Check if the file exists in the repository
    if [ -e $REPO/$FILE ]
    then
        # Check if file is already checked out
        FILESTATE=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 2)
        if [ "$FILESTATE" == in ]
        then
            # Check if destination exists
            if [ -d $DEST ]
            then
                # Get user info
                USERNAME=$(whoami)
                USERID=$(id -u)
                
                # Copy file
                cp $REPO/$FILE $DEST

                # Add log entry
                DATE=$(date "+[%d-%m-%Y | %T]")
                echo "$DATE $USERNAME checked out the file" >> $REPO/.cms/logs/$FILE

                # Edit file table
                OLDLINE=$(grep $FILE $REPO/.cms/file_table)
                NEWLINE="$FILE;out;$USERNAME;$USERID"
                sed -i "s/$OLDLINE/$NEWLINE/g" $FILE $REPO/.cms/file_table

                echo -e "$PREFIX The file \"$FILE\" has been checked out sucessfully."
            else
                echo -e "$PREFIX The destination \"$DEST\" does not exist."
            fi
        else
            echo -e "$PREFIX The file \"$FILE\" is already checked out."
        fi
    else
        echo -e "$PREFIX The file \"$FILE\" does not exist."
    fi

    return 0
}