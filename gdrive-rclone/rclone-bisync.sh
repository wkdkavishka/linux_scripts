#!/bin/bash

# Sync Documents
if pgrep -f "rclone bisync /home/wkdk/Documents dkmaxhome-g_drive:Documents" > /dev/null; then
  echo "rclone bisync for Documents is already running. Exiting."
else
  /usr/bin/rclone bisync /home/wkdk/Documents dkmaxhome-g_drive:Documents --resilient
  if [ $? -ne 0 ]; then
    echo "Sync Documents failed, running resync..."
    /usr/bin/rclone bisync /home/wkdk/Documents dkmaxhome-g_drive:Documents --resync
  fi
fi

# Sync G-Drive
if pgrep -f "rclone bisync /mnt/Storage-ssd/G-Drive dkmaxhome-g_drive:rclone" > /dev/null; then
  echo "rclone bisync for G-Drive is already running. Exiting."
else
  /usr/bin/rclone bisync /mnt/Storage-ssd/G-Drive dkmaxhome-g_drive:rclone --resilient
  if [ $? -ne 0 ]; then
    echo "Sync G-Drive failed, running resync..."
    /usr/bin/rclone bisync /mnt/Storage-ssd/G-Drive dkmaxhome-g_drive:rclone --resync
  fi
fi

# Sync Pictures
if pgrep -f "rclone bisync /home/wkdk/Pictures dkmaxhome-g_drive:Dictures" > /dev/null; then
  echo "rclone bisync for Pictures is already running. Exiting."
else
  /usr/bin/rclone bisync /home/wkdk/Pictures dkmaxhome-g_drive:Pictures --resilient
  if [ $? -ne 0 ]; then
    echo "Sync Pictures failed, running resync..."
    /usr/bin/rclone bisync /home/wkdk/Pictures dkmaxhome-g_drive:Pictures --resync
  fi
fi

exit 0
