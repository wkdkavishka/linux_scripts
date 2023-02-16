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
echo -e "Debian maintenance${reset}${magenta}"
echo -e "------------------------------------------------------${reset}"
echo ""
#-------------------------------------------------------
cho -e "${lred}searching for linux(kind)${reset}"
os_name=$(cat /etc/os-release | grep -w ID)
base_os=$(cat /etc/os-release | grep -w ID_LIKE)
os_name=${os_name:3}; base_os=${base_os:8}
echo -e "os name = ${lred}$os_name${reset}"
echo -e "base on = ${lred}$base_os${reset}"
echo "------------------------------------------------------"
echo ""
#-------------------------------------------------------
echo -e -n "${lred}prefer interaction :  ${reset}"
read choise

#------------------------------------------------------
#   apt-get  #
#------------------------------------------------------
if [ $choise == "yes" ] || [ $choise == "y" ]
    then
        echo $choise
        #sudo apt-get update
        #sudo apt-get upgrade
        #sudo apt-get autoremove
        #sudo apt-get install --fix-broken
    else
        echo $choise
        #sudo apt-get update
        #sudo apt-get autoremove -y
        #sudo apt-get upgrade -y
        #sudo apt-get install --fix-broken -y
fi
#------------------------------------------------------
#   btrfs   #
#------------------------------------------------------

btrfs_commands=(  "sudo btrfs filesystem defragment -rv /"
                    "sudo btrfs scrub start /"
                    "sudo btrfs balance --full-balance /"
                    )

echo -e -n "${lred}prefer interaction :  ${reset}"
read choise
if [ $choise == "yes" ] || [ $choise == "y" ]
    then


    else
        echo $choise
        echo -e "${lred}using default settings${reset}"
        #sudo btrfs filesystem defragment -rv /
        #sudo btrfs scrub start /
        #sudo btrfs balance --full-balance /
fi

sudo btrfs filesystem defragment -rv /
sudo btrfs scrub start /
sudo btrfs balance --full-balance /
