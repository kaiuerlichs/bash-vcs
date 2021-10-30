# Takes a repo name and file name
# Deletes a file, its logs and versions from the repository permanently
# Display applicable warnings and ask user to confirm they want to proceed

#!/bin/bash
remove_function{
#recieve user input

read -p "Enter the name of the file you want to remove: " file
#validate if file exists and recieve user confirmation
if [-f $file]; then
   rm -i "$file"
   #check file has been removed
   if [-f $file]; then
      echo "Error, we have encountered a problem and $file has not been removed"
   else
      echo "Success $file removed"
   fi
else
   echo "Error, the file $file does not exist"
fi
}