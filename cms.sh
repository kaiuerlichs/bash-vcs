#!/bin/bash

command=$1

case $command in 
    init|create)
        echo "Create new repo"
        ;;
    import)
        echo "Import repo from archive"
        ;;
    list|ls|l)
        echo "List repo files"
        ;;
    add|a)
        echo "Add new file to repo"
        ;;
    remove|r)
        echo "Remove file from repo"
        ;;
    checkout|out)
        echo "Checkout file from repo"
        ;;
    checkin|in)
        echo "Checkin file to repo"
        ;;
    reset)
        echo "Reset checkout state of file"
        ;;
    log)
        echo "Show log file for file"
        ;;
    revert)
        echo "Revert file to previous iteration"
        ;;
    snap|snapshot|export)
        echo "Create snapshot archive of repo"
        ;;
    revert-snap)
        echo "Revert to snapshot version of repo"
        ;;
    forward|cmd|command)
        echo "Forward a command to be run on the repo"
        ;;
    help)
        echo "Displaying help page"
        ;;
    *)
        echo "Command not recognised"
        ;;
esac