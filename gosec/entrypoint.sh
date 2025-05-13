# Import Runner sh From /bin/sh (using sh because image is alpine linux using shell posix not bash shell)
#!/bin/sh

# Exit 1 or error exit if command below error and terminated script
set -e

# Checking Input Command From User
if [ -n "$1" ];then
    # Creating Folder result and bind to folder
    mkdir -p /app/result
    # Exec gosec command from user
    eval "$@"
else
    # If User not sending the custom command return with gosec --help CLI
    eval gosec --help
fi