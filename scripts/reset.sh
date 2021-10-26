# Takes a repo name and a filename (-f flag for forced)
# Checks if file exists in repo
# Validate correct user is resetting file in | skip if forced
# Append a log entry of format "$(date "+[%d-%m-%Y | %T]") $USER reset the file check-out state."
# Change status of file to "in" on the file table
# Display success message to user in console