#!/bin/bash

SESSION_NAME="car-service"

# Check if the session exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Stopping tmux session: $SESSION_NAME..."
    tmux kill-session -t $SESSION_NAME
    echo "Stopped."
else
    echo "No active tmux session named '$SESSION_NAME' found."
fi
