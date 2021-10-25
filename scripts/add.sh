#!/bin/bash

PREFIX="\033[0;36m[CMS]\033[0m"
CYAN="\033[0;36m"
NOCL="\033[0m"

add_function() {
    if [[ $1 =~ ['.;!@#$%^&*()\/<>|:'] ]]
    then
        echo -e "$PREFIX The specified repository name is invalid. Avoid the following characters:"
        echo ". ; ! @ # $ % ^ & * ( ) \ / < > | :"
        return 0;
    fi

    REPO=$HOME/cms/repositories/$1

    if [ ! -e $REPO ]
    then
        echo -e "$PREFIX The repository \"$1\" does not exist."
        return 0;
    fi

    FILES=${@:2}

    for f in $FILES
    do
        if [ -e $f ]
        then
            if [ -e $REPO/$f ]
            then
                echo -e "$PREFIX The file $f already exists in the repository. Did you mean ${CYAN}cms checkin${NOCL}?"
            else
                cp $f $REPO
                echo "$f;in;---" >> $REPO/.cms/file_table
                echo -e "$PREFIX The file $f has been added to the repository."
            fi
        else
            echo -e "$PREFIX The file $f does not exist."
        fi
    done

}