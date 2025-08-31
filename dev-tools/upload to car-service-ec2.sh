#!/bin/bash

# Define variables
EXCLUDE_FILE="exclude.txt"
REMOTE_USER="ubuntu"
REMOTE_HOST="ec2-*****.****.amazonaws.com"
REMOTE_DIR="~/folder"
SSH_KEY="./key.pem"

# Run rsync with excludes from file
rsync -avz --exclude-from="$EXCLUDE_FILE" -e "ssh -i $SSH_KEY" . $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
