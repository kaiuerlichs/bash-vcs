#!/bin/bash

# First parameter "create": Takes repo name and optional destination path
    # Create archive of repo files (not the .cms folder) and save it to the snapshot folder with date in name
    # If destination path is specified, also copy archive to destination

# First parameter "list": Takes repo name
    # List all snapshots saved for the repository

# First parameter "copy" or "export": Takes repo name, snapshot name and destination path
    # Copy specified snapshot file to destination

snapshot_function() {
    if [ ! $# -gt 0 ]
    then
        echo -e "$PREFIX Please specify a snapshot operation: create, list or export"
        return 0;
    fi

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
    DEST=0
    if [ $# -gt 1 ] && [ -d $2 ]
    then
        DEST=$2
    fi

    

}