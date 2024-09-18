#!/bin/bash

#color code variables     #theaming
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

#introduction
echo -e "${magenta}------------------------------------------------------"
echo -e "${lyellow}linux automated script"
echo -e "by ${cyan}w.k.d.kavishka${lyellow}"
echo -e "Add SSH key at Login${reset}${magenta}"
echo -e "------------------------------------------------------${reset}"
echo ""

echo -e "${lred} coping files...${reset}"
mkdir ~/scripts
cp ssh-login.sh ~/scripts

sudo cp ssh-login.service /etc/systemd/system/
sudo cp ssh-login.timer /etc/systemd/system/

echo -e "${lred} starting services...${reset}"
sudo systemctl daemon-reload
sudo systemctl start ssh-login.service
sudo systemctl start ssh-login.timer

echo -e "${lred} enabling services...${reset}"
sudo systemctl enable ssh-login.service
sudo systemctl enable ssh-login.timer
