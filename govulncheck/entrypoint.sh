# Import Shell Exec For Alpine Image
#!/bin/sh

# Exit 1 if Error from Command
set -e

# Checking Input Command From User is Not Null 
if [ -n "$1" ]; then
    # Create Folder 
    mkdir -p /app/result
    # Sleep First for Waiting The Folder Ready
    sleep 5
    # Exec Command from param
    eval "$@"
else
    # Show Help govulncheck if user not send the command param
    eval govulncheck --help
fi
