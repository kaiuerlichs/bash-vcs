#!/bin/bash
# Takes repo as parameter
# When command is run, display warning about risks of running commands on repo, advise not to run file-changing commands directly and to use snapshots instead
# Confirm user wants to proceed
# Take command as user input
# Run command on repo folder

PREFIX="\033[0;36m[CMS]\033[0m"
    
forward_function() {
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
    REPO=/cms/repositories/$1
    # Check whether specified repository exists
    if [ ! -e $REPO ]
    then
        echo -e "$PREFIX The repository \"$1\" does not exist."
        return 0;
    fi
 
    echo -e "$PREFIX WARNING! Running this command is risky, you are advised to use snapshots when running file changing commands."

    read -p "$(echo -e "$PREFIX Are you sure you want to run a command on the repository folder? [y/N] ")" option
    case $option in
        [Yy]* ) 
            cd $REPO
            read -p "$(echo -e "$PREFIX Please enter the command you want to run or "ABORT" to cancel: ")" command
            if [ "$command" == "ABORT" ]
            then
                echo -e "$PREFIX Aborting command forwarding..."
            else
                echo -e "$PREFIX Command output:"
                eval $command
            fi
            ;;
        * )
            echo -e "$PREFIX Aborting command forwarding..."
            return 0;
            ;;
    esac

}