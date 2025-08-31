#!/bin/bash

# Color code variables (theming)
red="\e[0;31m"
blue="\e[0;34m"
yellow="\e[0;33m"
green="\e[0;32m"
white="\e[0;97m"

cyan="\e[0;96m"
magenta="\e[0;95m"
lred="\e[0;91m"
lgreen="\e[0;92m"
lyellow="\e[0;93m"

blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
expand_bg="\e[K"

bold="\e[1m"
uline="\e[4m"
reset="\e[0m"

# Introduction
echo -e "${magenta}------------------------------------------------------"
echo -e "${lyellow}Linux Automated Script Uninstaller"
echo -e "by ${cyan}w.k.d.kavishka${lyellow}"
echo -e "Automatically uninstall and disable rclone-bisync services${reset}${magenta}"
echo -e "------------------------------------------------------${reset}"
echo ""

# Stop and disable services
echo -e "${lred}Stopping services...${reset}"
sudo systemctl stop rclone-bisync.service
sudo systemctl stop rclone-bisync.timer

echo -e "${lred}Disabling services...${reset}"
sudo systemctl disable rclone-bisync.service
sudo systemctl disable rclone-bisync.timer

# Remove service files
echo -e "${lred}Removing service files...${reset}"
sudo rm -f /etc/systemd/system/rclone-bisync.service
sudo rm -f /etc/systemd/system/rclone-bisync.timer
sudo rm -f /etc/rclone-bisync.sh

# Reload systemd daemon
echo -e "${lred}Reloading systemd daemon...${reset}"
sudo systemctl daemon-reload

echo -e "${green}Uninstallation complete.${reset}"
