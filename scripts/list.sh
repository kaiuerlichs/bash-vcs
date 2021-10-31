#!/bin/bash
# Takes either no parameters, or a repo name as parameter
# Without parameter, display all repositories
# With repo parameter, display all files in repository

PREFIX="\033[0;36m[CMS]\033[0m"

list_function(){
    # Check if a repository was specified
    if [ $# -eq 0 ]
    then
        echo -e "$PREFIX Listing all repositories..."
        ls /cms/repositories | while read line
        do
            echo -e "$line\tLast edited: $(date -r  /cms/repositories/$line "+%d-%m-%Y %H:%M:%S")"
        done
    else
        echo "else"
    fi
    
    
}