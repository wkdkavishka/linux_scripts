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

#status
echo -e "${cyan}snaps.sh -- running${reset}"

#package arrays
declare -a snap_list
declare -a snap_list_classic

while read -r line;
    do
    snap_list+=($line)
done < ../package_lists/snap.list

while read -r line;
    do
    snap_list_classic+=($line)
done < ../package_lists/snap.classic.list

#checking snaps are configurable
base_os=$(cat /etc/os-release | grep -w ID_LIKE)
base_os=${base_os:8}

echo -e "installing snap services"

if [ $base_os == "debian" ];
    then 
        sudo apt install snapd
elif [ $base_os == "arch" ];
    then 
        yay -S snapd --noconfirm
fi

#install installing snaps
echo -e "${cyan}installing snaps${reset}"
for pack_name in ${snap_list[*]}
    do
    snap install $pack_name
done
for pack_name in ${snap_list_classic[*]}
    do
    snap install $pack_name --classic
done

#done installing snaps
echo -e "${lgreen}done installing snaps${reset}"