#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# FORWARD.SH
# Takes a repo name as argument; prompts user to enter a command to be evaluated on the repo



# Create colour output variables
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
 
    # Display relevant warnings and get user confirmation
    echo -e "$PREFIX WARNING! Running this command is risky, you are advised to use snapshots when running file changing commands."
    read -p "$(echo -e "$PREFIX Are you sure you want to run a command on the repository folder? [y/N] ")" option

    # Case statement for user selection
    case $option in
        [Yy]* ) 
            cd $REPO

            # Prompt user to enter command
            read -p "$(echo -e "$PREFIX Please enter the command you want to run or "ABORT" to cancel: ")" command

            # Check cancel condition
            if [ "$command" == "ABORT" ]
            then
                echo -e "$PREFIX Aborting command forwarding..."
                return 0;
            else
                # Run the command
                echo -e "$PREFIX Command output:"
                eval $command
                return 0;
            fi
            ;;
        * )
            echo -e "$PREFIX Aborting command forwarding..."
            return 0;
            ;;
    esac
}