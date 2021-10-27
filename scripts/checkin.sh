#!/bin/bash

PREFIX="\033[0;36m[CMS]\033[0m"
CYAN="\033[0;36m"
NOCL="\033[0m"

checkin_function() {
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
    REPO=$HOME/cms/repositories/$1
    # Check whether specified repository exists
    if [ ! -e $REPO ]
    then
        echo -e "$PREFIX The repository \"$1\" does not exist."
        return 0;
    fi

    # Check if any files were specified
    if [ ! $# -gt 1 ]
    then
        echo -e "$PREFIX No file was specified."
        return 0;
    fi
    FILE=$2

    if [ -e $REPO/$FILE ]
    then
        # Check if file is checked out
        FILESTATE=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 2)
        if [ "$FILESTATE" == "out" ]
        then
            # Get user info
            USERNAME=$(whoami)
            USERID=$(id -u)

            # Get file table access info
            CHECKUSER=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 3)
            CHECKUSERID=$(grep $FILE $REPO/.cms/file_table | cut -d ";" -f 4)
            
            # Check if correct person is checking in
            if [ "$CHECKUSERID" == "$USERID" ]
            then
                # Prompt diff view
                read -p "$(echo -e "$PREFIX Show diff view? [y/N] ")" option
                case $option in
                    [Yy]* ) 
                        echo -e "$PREFIX Displaying diff for file checkin on $FILE"
                        diff $REPO/$FILE $FILE
                        read -p "$(echo -e "$PREFIX Do you still wish to check-in? [Y/n] ")" option
                        case $option in
                            [Nn]* ) 
                                echo -e "$PREFIX Aborting..."
                                return 0;
                                ;;
                        esac
                        ;;
                    * )
                        ;;
                esac

                # Prompt checkin message
                read -p "$(echo -e "$PREFIX Please enter a log message: ")" MESSAGE

                # Create version copy
                IDENTIFIER=$(date "+%d-%m-%y-%H-%M-%S")
                cp $REPO/$FILE $REPO/.cms/versions/$FILE/$IDENTIFIER

                # Copy new version
                cp $FILE $REPO/$FILE

                # Append log message
                echo "$DATE $USERNAME checked the file in with the following message: $MESSAGE" >> $REPO/.cms/logs/$FILE

                # Edit file table entry
                OLDLINE=$(grep $FILE $REPO/.cms/file_table)
                NEWLINE="$FILE;in;none;none"
                sed -i "s/$OLDLINE/$NEWLINE/g" $FILE $REPO/.cms/file_table

                echo -e "$PREFIX The file \"$FILE\" has been checked in sucessfully."


            else
                echo -e "$PREFIX The file \"$FILE\" was checked out by $CHECKUSER, not you. You cannot check it in."
            fi
        else
            echo -e "$PREFIX The file \"$FILE\" is not currently checked out. Did you mean ${CYAN}cms checkout${NOCL}?" 
        fi
    else
        echo -e "$PREFIX The file \"$FILE\" does not exist in the repository.  Did you mean ${CYAN}cms add${NOCL}?" 
    fi

}