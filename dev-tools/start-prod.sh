#!/bin/bash

SESSION_NAME="car-service"

# Kill existing tmux session if it exists
tmux kill-session -t $SESSION_NAME 2>/dev/null

# Create a new detached tmux session
tmux new-session -d -s $SESSION_NAME

# Start Angular frontend in the first pane
tmux send-keys -t $SESSION_NAME "cd car-service-center-Angular-front && echo 'Starting Angular frontend...' && npm run start-production" C-m

# Split window horizontally for Express backend
tmux split-window -h -t $SESSION_NAME
tmux send-keys -t $SESSION_NAME "cd car-service-center-Express-back && echo 'Starting Express backend...' && npm run start-production" C-m

# Attach to session (optional)
tmux attach -t $SESSION_NAME
