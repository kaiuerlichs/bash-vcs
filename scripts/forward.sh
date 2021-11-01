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

    REPO=$HOME/cms/repositories/$1
    # Check whether specified repository exists
    if [ ! -e $REPO ]
    then
        echo -e "$PREFIX The repository \"$1\" does not exist."
        return 0;
    fi
 
    echo -e "$PREFIX WARNING! running this command is risky, you are advised to use snapshots when running file changing commands."
     echo -e "$PREFIX Do you want to proceed? 1 = YES, 0 = NO"
     read proceed
     if [proceed = 0]
        then 

     elseif [proceed = 1]
        then

     else -e "$PREFIX Please enter a valid value."

     fi
    }