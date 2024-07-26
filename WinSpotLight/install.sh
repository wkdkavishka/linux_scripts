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
echo -e "automaticaly install and configure fresh linux install${reset}${magenta}"
echo -e "------------------------------------------------------${reset}"
echo ""

echo -e "${lred} coping files...${lred}"
mkdir ~/scripts
cp winspotlightkde ~/scripts

sudo cp winspotlightkde.service /etc/systemd/system/
sudo cp winspotlightkde.timer /etc/systemd/system/

echo -e "${lred} starting services...${lred}"
sudo systemctl daemon-reload
sudo systemctl start winspotlightkde.service
sudo systemctl start winspotlightkde.timer

echo -e "${lred} enabling services...${lred}"
sudo systemctl enable winspotlightkde.service
sudo systemctl enable winspotlightkde.timer
