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

#package arrays
known_os=(arch debian);

#code
echo -e "${lred}searching for linux(kind)${reset}"
os_name=$(cat /etc/os-release | grep -w ID)
base_os=$(cat /etc/os-release | grep -w ID_LIKE)
os_name=${os_name:3}; base_os=${base_os:8}
echo -e "os name = ${lred}$os_name${reset}"
echo -e "base on = ${lred}$base_os${reset}"
echo "------------------------------------------------------"
echo ""
#user inputs
echo -e -n "${lred}user name --> ${reset}"
read user_name
echo ""
export user_name

for i in ${known_os[*]} 
do 
    if [ $i == $base_os ];
        then
            temp="./$base_os.sh"
            echo -e "${lgreen}opening $temp${reset}"
            cd main_scripts
            $temp
            cd ..
            break
    fi
done

echo -e "${cyan}start installing snaps\nopening snap.sh${reset}"
#locating snap.sh
cd main_scripts
sudo ./snap.sh
cd ../

#theaming
cd theaming
ls -1
