# Takes repo name, file and optional destination path as parameters
# Validates parameters
# Check file is not already checked out
# Change file table entry to "out" with username and id stored
# Copy repo file to pwd or destination path specified
# Append a log entry of format "$(date "+[%d-%m-%Y | %T]") $USER checked out the file."
# Display success message to user in console