#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# RESET.SH
# Takes a repo name and file name; resets the checkout state, if necessary, forcibly



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

reset_function() {
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

    if [ ! -e $REPO/$FILE ]
    then
        echo -e "$PREFIX The file \"$FILE\" does not exist."
        return 0;
    fi

    FORCED=1
    # Check if forced mode is activated 
    if [ $# -gt 2 ]
    then
        if [ "$3" == "-f"  ] || [ "$3" == "--forced" ]
        then
            FORCED=0
        fi
    fi

    # Check file checkin state
    FILESTATE=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 2)
    if [ "$FILESTATE" == "in" ]
    then
        echo -e "$PREFIX The file \"$FILE\" is not checked out."
        return 0;
    fi

    # Get user info
    USERNAME=$(whoami)
    USERID=$(id -u)
    DATE=$(date "+[%d-%m-%Y | %T]")

    if [ "$FORCED" -eq 0 ]
    then
        # Append log message
        echo "$DATE $USERNAME reset the filestate FORCIBLY. The file is now checked in." >> $REPO/.cms/logs/$FILE

        # Edit file table entry
        OLDLINE=$(grep $FILE $REPO/.cms/file_table)
        NEWLINE="$FILE;in;none;none"
        sed -i "s/$OLDLINE/$NEWLINE/g" $FILE $REPO/.cms/file_table

        echo -e "$PREFIX The file \"$FILE\" has been forcibly reset."
    else
        # Get file table access info
        CHECKUSER=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 3)
        CHECKUSERID=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 4)

        if [ "$CHECKUSERID" == "$USERID" ]
        then
            # Append log message
            echo "$DATE $USERNAME reset the file. The file is now checked in." >> $REPO/.cms/logs/$FILE

            # Edit file table entry
            OLDLINE=$(grep $FILE $REPO/.cms/file_table)
            NEWLINE="$FILE;in;none;none"
            sed -i "s/$OLDLINE/$NEWLINE/g" $FILE $REPO/.cms/file_table

            echo -e "$PREFIX The file \"$FILE\" has been reset sucessfully."
        else
            echo -e "$PREFIX The file \"$FILE\" was checked out by $CHECKUSER, not you. If you still want to reset the filestate, you must use forced mode."
        fi
    fi

    return 0
}