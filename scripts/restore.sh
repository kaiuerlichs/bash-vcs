#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# REVERT.SH
# Takes a repo name a file name; allows the user to revert to previous file version



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

# Import snapshot subscript
PATHNAME="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $PATHNAME/snapshot.sh

restore_function() {
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

    # Create relavant variables
    SNAPS=$REPO/.cms/snapshots
    SNAP_COUNT=$(ls $VERSIONS | wc -l)

    # Check if tmp folder already exists, create tmp file variable
    if [ ! -e /cms/.tmp/ ]
    then
        mkdir /cms/.tmp/
    fi
    TMP=/cms/.tmp/snaplist

    echo -e "$PREFIX Listing snapshots for \"$REPO\"..."

    if [ $SNAP_COUNT -eq 0 ]
    then
        echo -e "$PREFIX No snapshots found."
    else
        # Loop through all snapshots
        ls $SNAPS > $TMP
        echo -e "Snapshots saved for the following timestamps: \n"
        COUNTER=1
        while read SNAP
        do
            echo -e "$COUNTER) ${SNAP::-7}"
            COUNTER=$((COUNTER+1))
        done < $TMP

        # Get user selection
        read -p "$(echo -e "$PREFIX Select a snapshot to restore or \"Quit\": ")" option
        # If option is numeric
        if [ "$option" -eq "$option" ] 2> /dev/null
        then
            # If option is within range
            if [ "$option" -gt "0" ] && [ ! "$option" -gt "$SNAP_COUNT" ]
            then
                # Find selected version
                SNAP_VER=$(sed -n "${option}p" < $TMP)
                
                # Create snapshot of current repository
                snapshot_function create $1 > /dev/null

                # Remove repo files
                cd $REPO
                FILES=$(ls -p | grep -v /)
                if [ -n $FILES ]
                then
                    rm $FILES
                fi

                # Replace files with snapshot files
                tar xzf ./.cms/snapshots/$SNAP_VER

                # Append log messages
                USERNAME=$(whoami)
                DATE=$(date "+[%d-%m-%Y | %T]")
                ls ./.cms/logs | while read f
                do
                    echo "$DATE $USERNAME restored the repository version from ${SNAP_VER::-7}" >> ./.cms/logs/$f
                done

                echo -e "$PREFIX A snapshot of the repository has been created."
                echo -e "$PREFIX The repository has been restored to the specified version."
            else
                echo -e "$PREFIX The snapshot you selected does not exist."
            fi
        else
            echo -e "$PREFIX Aborting reverting to snapshot... "
        fi 

        # Remove temp file
        rm $TMP
    fi

    return 0
}