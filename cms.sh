#!/bin/bash

# SCRIPTS=$(cd `dirname $0` && pwd)/scripts
SCRIPTS="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/scripts"
PREFIX="\033[0;36m[CMS]\033[0m"

. $SCRIPTS/create.sh
. $SCRIPTS/import.sh
. $SCRIPTS/list.sh
. $SCRIPTS/add.sh
. $SCRIPTS/remove.sh
. $SCRIPTS/checkout.sh
. $SCRIPTS/checkin.sh
. $SCRIPTS/reset.sh
. $SCRIPTS/log.sh
. $SCRIPTS/revert.sh
. $SCRIPTS/snapshot.sh
. $SCRIPTS/revert-snap.sh
. $SCRIPTS/forward.sh
. $SCRIPTS/help.sh

COMMAND=$1

case $COMMAND in 
    init|create)
        create_function ${@:2}
        ;;
    import)
        echo "Import repo from archive"
        ;;
    list|ls|l)
        echo "List repo files / get list of repositories if no repo is specified"
        ;;
    add|a)
        add_function ${@:2}
        ;;
    remove|r)
        remove_function ${@:2}
        ;;
    checkout|out)
        checkout_function ${@:2}
        ;;
    checkin|in)
        checkin_function ${@:2}
        ;;
    reset)
        reset_function ${@:2}
        ;;
    log)
        log_function ${@:2}
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
        forward_function ${@:2}
        ;;
    versions)
        echo "Displaying file versions list"
        ;;
    help)
        help_function ${@:2}
        ;;
    *)
        echo -e "$PREFIX Sorry, this command is not recognised."
        # echo "If you want some cheering up, click here: https://twitter.com/SHS_MusicDep/status/1258414589789822978"
        ;;
esac