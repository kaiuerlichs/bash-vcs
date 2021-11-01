#!/bin/bash

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
. $SCRIPTS/restore.sh
. $SCRIPTS/forward.sh
. $SCRIPTS/help.sh
. $SCRIPTS/versions.sh

COMMAND=$1

case $COMMAND in 
    init|create)
        create_function ${@:2}
        ;;
    import)
        import_function ${@:2}
        ;;
    list|ls|l)
        list_function ${@:2}
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
        revert_function ${@:2}
        ;;
    snap|snapshot|export)
        snapshot_function ${@:2}
        ;;
    restore|revert-snap)
        restore_function ${@:2}
        ;;
    forward|cmd|command)
        forward_function ${@:2}
        ;;
    versions)
        versions_function ${@:2}
        ;;
    help)
        help_function ${@:2}
        ;;
    *)
        echo -e "$PREFIX Sorry, this command is not recognised."
        # echo "If you want some cheering up, click here: https://twitter.com/SHS_MusicDep/status/1258414589789822978"
        ;;
esac

exit 0