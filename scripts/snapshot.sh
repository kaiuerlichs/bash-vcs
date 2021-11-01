#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# SNAPSHOT.SH
# Takes a repo name and an operation (potentially more args); executes operation accordingly



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"

# Handle inital function call
snapshot_function() {
    # Check if operation was specified
    if [ ! $# -gt 0 ]
    then
        echo -e "$PREFIX Please specify a snapshot operation: create, list or export"
        return 0;
    fi
    # Perform relevant operation
    case $1 in
        create)
            create_snapshot ${@:2}
            ;;
        list)
            list_snapshots ${@:2}
            ;;
        export|copy)
            export_snapshot ${@:2}
            ;;
        *)
            echo -e "$PREFIX $1 is not recognised as a snapshot operation."
            ;;
    esac
}

# Takes a repo name and optionally a destination path; creates new repo snapshot
create_snapshot() {
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

    # Check if optional destination is specified
    DEST=""
    if [ $# -gt 1 ] && [ -d $2 ]
    then
        DEST=$(pwd)/$2
    fi

    # Navigate into repository
    cd $REPO

    # Create tar file for all files, but not the .cms directory
    IDENTIFIER=$(date "+%d-%m-%y-%H-%M-%S")
    tar czf $REPO/.cms/snapshots/$IDENTIFIER.tar.gz $(ls -p | grep -v /)

    # Copy file to export destination if necessary
    if [ -n "$DEST" ]
    then
        cp $REPO/.cms/snapshots/$IDENTIFIER.tar.gz $DEST
        echo -e "$PREFIX A snapshot of the repository has been created successfully. A copy of the archive was saved to \"$DEST\"."
    else
        echo -e "$PREFIX A snapshot of the repository has been created successfully."
    fi
}

# Takes a repo name; lists all snapshots available for this repo
list_snapshots() {
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

    # Create relevant variables
    SNAPS=$REPO/.cms/snapshots
    SNAP_COUNT=$(ls $SNAPS | wc -l)
    LATEST=$(date -r $REPO "+%d-%m-%Y %H:%M:%S")

    echo -e "$PREFIX Listing snapshots for \"$REPO\"..."
    echo -e "Last repository edit: $LATEST\n"

    # Only run loop if there are snapshots to show
    if [ $SNAP_COUNT -eq 0 ]
    then
        echo -e "$PREFIX No snapshots found."
    else
        echo -e "Snapshots saved for the following timestamps: "
        # Loop through all returned lines from ls
        COUNTER=1
        ls $SNAPS | while read snap
        do
            # Display without file extension
            echo -e "$COUNTER) ${snap::-7}"
            COUNTER=$((COUNTER+1))
        done
    fi
}

# Takes a repo name as parameter, copies a snapshot to a user-specified destination
export_snapshot() {
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

    # Create relevant variables
    SNAPS=$REPO/.cms/snapshots
    SNAP_COUNT=$(ls $SNAPS | wc -l)
    LATEST=$(date -r $REPO "+%d-%m-%Y %H:%M:%S")

    # Check if tmp folder already exists
    if [ ! -e /cms/.tmp/ ]
    then
        mkdir /cms/.tmp/
    fi
    TMP=/cms/.tmp/snaplist

    echo -e "$PREFIX Listing snapshots for \"$REPO\"..."
    echo -e "Last repository edit: $LATEST\n"

    if [ $SNAP_COUNT -eq 0 ]
    then
        echo -e "$PREFIX No snapshots found."
    else
        # Loop through all snapshots after storing them in the tmp file
        ls $SNAPS > $TMP
        echo -e "Snapshots saved for the following timestamps: "
        COUNTER=1
        while read snap
        do
            echo -e "$COUNTER) ${snap::-7}"
            COUNTER=$((COUNTER+1))
        done < $TMP

        # Get and verify user input
        read -p "$(echo -e "$PREFIX Select a version to export or \"Quit\": ")" option
        if [ "$option" -eq "$option" ] 2> /dev/null
        then
            if [ "$option" -gt "0" ] && [ ! "$option" -gt "$SNAP_COUNT" ]
            then
                # Find selected version
                SNAP_VER=$(sed -n "${option}p" < $TMP)
                
                # Get destination directory
                read -p "$(echo -e "$PREFIX Enter a destination to export to: ")" dest

                # Copy archive
                if [ -d $dest ]
                then
                    cp $SNAPS/$SNAP_VER $dest
                    echo -e "$PREFIX The selected snapshot has been copied to the destination."
                else
                    echo -e "$PREFIX The entered destination is not a directory."
                fi
            else
                echo -e "$PREFIX The snapshot you selected does not exist."
            fi
        else
            echo -e "$PREFIX Aborting snapshot export... "
        fi 

        # Remove temp file
        rm $TMP
    fi

    return 0
}