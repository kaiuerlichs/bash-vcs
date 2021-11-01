#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       


# CMS.SH
# Handles the main control flow, evaluates the first command argument to decide which function to call



# Get correct path to scripts folder (same location as cms.sh)
SCRIPTS="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/scripts"

# Set prefix variable
PREFIX="\033[0;36m[CMS]\033[0m"

# Import subscripts
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

# Verify a command argument was specified
if [ $# -eq 0 ]
then
    echo -e "$PREFIX Please enter a valid command or type help to learn more."
    exit 0
fi

# Get first argument
COMMAND=$1

# Call function according to command argument
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
        # Display warning if incorrect command was passed
        echo -e "$PREFIX Sorry, this command is not recognised."
        ;;
esac

# Return exit code
exit 0