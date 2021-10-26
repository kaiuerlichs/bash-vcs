# Takes a repo name and a file as parameters
# Checks if file exists in repo
# Perhaps show diffs?
# Validate correct user is checking file in
# Creates copy of repo file in versions/filename with name=$(date "+%d-%m-%Y | %T")
# Override repo file with file specified in parameter
# Request user to enter a check-in message
# Append a log entry of format "$(date "+[%d-%m-%Y | %T]") $USER checked in the file: check in message"
# Change status of file to "in" on the file table
# Display success message to user in console