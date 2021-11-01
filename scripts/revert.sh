#!/bin/bash

revert_function() {
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
    # Check if file is checked in 
    FILESTATE=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 2)
    if [ "$FILESTATE" == "out" ]
    then
        echo -e "$PREFIX Cannot revert to previous version because the file is currently checked out."
        return 0;
    fi

    # Create variables
    VERSIONS=$REPO/.cms/versions/$FILE/
    VERSION_COUNT=$(ls $VERSIONS | wc -l)

    # Check if tmp folder already exists
    if [ ! -e /cms/.tmp/ ]
    then
        mkdir /cms/.tmp/
    fi

    TEMP=/cms/.tmp/$FILE
    
    # List all versions
    if [ $VERSION_COUNT -ne 0 ]
    then
        echo -e "$PREFIX Versions saved for the following timestamps: "
        COUNTER=1
        ls $VERSIONS > $TEMP
        while read -r ver
        do
            echo -e "$COUNTER) $ver"
            COUNTER=$((COUNTER+1))
        done < $TEMP

        # Get user selection
        read -p "$(echo -e "$PREFIX Select a version to revert to or \"Quit\": ")" option
        # If input is numeric
        if [ "$option" -eq "$option" ] 2> /dev/null
        then
            # Check if version number is valid
            if [ "$option" -gt "0" ] && [ ! "$option" -gt "$VERSION_COUNT" ]
            then
                REVERT_VER=$(sed -n "${option}p" < $TEMP)

                # Create version copy
                IDENTIFIER=$(date "+%d-%m-%y-%H-%M-%S")
                cp $REPO/$FILE $REPO/.cms/versions/$FILE/$IDENTIFIER

                # Copy old version into repo
                cp $VERSIONS/$REVERT_VER $REPO/$FILE

                # Add log entry
                USERNAME=$(whoami)
                echo "$DATE $USERNAME reverted the file to the following version: $REVERT_VER" >> $REPO/.cms/logs/$FILE

                echo -e "$PREFIX The current file version has been backed up and the file was reverted to a previous version."
            else
                echo -e "$PREFIX The version you selected does not exist."
            fi
        else
            echo -e "$PREFIX Aborting file revert... "
        fi 
    else
        echo -e "$PREFIX There are no versions of \"$FILE\" to revert to."
    fi

    # Remove temp file
    rm $TEMP
}