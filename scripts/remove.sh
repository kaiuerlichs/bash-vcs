#!/bin/bash

PREFIX="\033[0;36m[CMS]\033[0m"

remove_function() {
#recieve user input
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

    #validate if file exists and recieve user confirmation
    if [-f $FILE]; then
        FILESTATE=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 2)
        if [ "$FILESTATE" == "out" ]
        then
            echo -e "$PREFIX Cannot delete a file which is already checked out."
            return 0;
        fi


        read -p "$(echo -e "$PREFIX Are you sure you want to delete this file permanently? [y/N] ")" option
        case $option in
            [Yy]* ) 
                rm $REPO/$FILE
                rm $REPO/.cms/logs/$FILE
                rm -R $REPO/.cms/versions/$FILE
                line=$(grep $FILE $REPO/.cms/file_table)
                sed -i "/$line/d" $REPO/.cms/file_table
                echo -e "$PREFIX File was successfully deleted!"
                ;;
            * )
                echo -e "$PREFIX Aborting file delete..."
                return 0;
                ;;
        esac
    fi
}