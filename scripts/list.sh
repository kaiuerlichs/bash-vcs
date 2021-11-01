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
        echo -e "$PREFIX Total number of repositories: $(ls /cms/repositories | wc -l)\n"
        ls /cms/repositories | while read line
        do
            echo -e "$line\tLast edited: $(date -r  /cms/repositories/$line "+%d-%m-%Y %H:%M:%S")"
        done
    else
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

        if [ ! -e /cms/.tmp/ ]
        then
            mkdir /cms/.tmp/
        fi

        echo -e "$PREFIX Displaying all files in repository \"$1\""
        echo -e "$PREFIX Total number of files: $(wc -l < $REPO/.cms/file_table)\n"

        tmpfile=/cms/.tmp/tmpfile
        echo -e "File name;Checked In/Out;Username;User ID" | cat - $REPO/.cms/file_table > $tmpfile
        column -t -s ";" < $tmpfile
        rm $tmpfile
    fi
    
    
}