#!/bin/bash

# GROUP MEMBERS
# ---NAME---            ---Matric. no---
# Nicole Jackson        2415277
# Christopher O'May     2418120
# Kai Uerlichs          2421101       



# HELP.SH
# Displays a help page explaining the commands



# Create colour output variables
PREFIX="\033[0;36m[CMS]\033[0m"
CYAN="\033[0;36m"
NOCL="\033[0m"

help_function () {
      # Echo all the command descriptions
      echo -e "Add: ${CYAN}cms add <repository> <file(s)>${NOCL}
            Add file(s) to a repository"
      echo -e "Check in: ${CYAN}cms checkin <repository> <file>${NOCL}
            Check in file"
      echo -e "Check out: ${CYAN}cms checkout <repository> <file>${NOCL}
            Check out file"
      echo -e "Create: ${CYAN}cms create <repository name>${NOCL}
            alias init
            Create a new repository"
      echo -e "Forward: ${CYAN}cms forward <repository>${NOCL}
            Forward command to run on the repository"
      echo -e "Help: ${CYAN}cms help${NOCL}
            Help page for commands"
      echo -e "Import: ${CYAN}cms import <archive file> <repository name>${NOCL}
            Import repositiry from archive"
      echo -e "List: ${CYAN}cms list${NOCL}
            List all repositories"
      echo -e "List: ${CYAN}cms list <repository>${NOCL}
            List the repository files"
      echo -e "Log: ${CYAN}cms log <repository> <file>${NOCL}
            Show log file for selected file"
      echo -e "Remove: ${CYAN}cms remove <repository> <file>${NOCL}
            Remove file from repository"
      echo -e "Reset: ${CYAN}cms reset <repository> <file> <options>${NOCL}
            -f: forced mode, resets file state even if the user is not the one currently holding check-out rights
            Reset checkout state of the file"
      echo -e "Revert-snap: ${CYAN}cms revert-snap <repository> <snapshot>${NOCL}
            Revert to a previous snapshot version of repository"
      echo -e "Revert: ${CYAN}cms revert <repository> <file> <version>${NOCL}
            Revert file to previous iteration"
      echo -e "Snapshot: ${CYAN}cms snapshot create <repository> <optional destination>${NOCL}
            Create a snapshot archive of repository"
      echo -e "Snapshot: ${CYAN}cms snapshot list <repository> ${NOCL}
            List all snapshots of a repository"
      echo -e "Snapshot: ${CYAN}cms snapshot export <repository>${NOCL}
            alias snapshot copy
            Export a snapshot of a repository"
      echo -e "Versions: ${CYAN}cms versions <repository> <file>${NOCL}
            Display file versions list"

      return 0
}