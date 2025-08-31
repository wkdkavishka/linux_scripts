#!/bin/bash
# ---------

# Start ssh-agent
eval "$(ssh-agent -s)"
# Add the SSH key
ssh-add /mnt/Storage-ssd/Documents/Backup_Keys/Git/wkdkavishka/wkdk-git
