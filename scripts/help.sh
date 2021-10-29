#!/bin/bash
# Displays a help page explaining all the commands of the cms script

PREFIX="\033[0;36m[CMS]\033[0m"

help_function () {

echo "Add: cms add <repository> <file(s)>
      add files to a repository."
echo "Check in: cms checkin <repository> <file>
      check in files."
echo "Check out: cms checkout <repository> <file>
      check out files."
echo "Create: cms create <repository name>
      alias init
      create repository folder, .cms folders and file table."
echo "Forward: cms forward <repository>
      forward command to run on the repository."
echo "Help: cms help <optional command>
      help page for commands(current page)."
echo "Import: cms import <archive file> <repository name>
      import repositiry from archive."
echo "List: cms list <repository>
      list the repository files."
echo "Log: cms log <repository> <file>
      show log file for selected file."
echo "Remove: cms remove <repository> <file>
      remove file from repository."
echo "Reset: cms reset <repository> <file> <options>
      -f: forced mode
      reset checkout state of the file."
echo "Revert-snap: cms revert-snap <repository> <snapshot>
      revert to snapshot version of repository."
echo "Revert: cms revert <repository> <file> <version>
      revert file to previous iteration."
echo "Snapshot: cms snapshot create <repository> <optional destination>
      create snapshot archive of repository."
echo "Versions: cms versions <repository> <file>
      display file versions list."

}