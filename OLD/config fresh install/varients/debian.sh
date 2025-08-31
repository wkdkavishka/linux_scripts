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

echo "${cyan}debian.sh -- running${reset}"

#package arrays
declare -a apt_list
while read -r line;
    do
    apt_list+=$line
done < ../package_lists/apt.list

#confirm
base_os=$(cat /etc/os-release | grep -w ID_LIKE)
base_os=${base_os:8}

if [ $base_os != "debian" ]; then
    exit
fi
echo -e "os confirmed \nmooving on \nupdate repositories";

#debian special
echo -e "${cyan}adding repositories${reset}"
echo -e "backing up sources.list"
td=pwd
cp /etc/apt/sources.list $td.back
echo -e "" >> /etc/apt/sources.list

#carefull install (yes/no)
echo -e -n "${lred}you want a atendent install or not --> ${reset}"
read choise
if [ $choise == "yes" ];
    then
        #install packages using loop
        for pack_name in ${pacman_list[*]}
            do
            sudo pacman -S $pack_name
        done
elif [ $choise == "no" ];
    then
        #install packages using loop
        for pack_name in ${pacman_list[*]}
            do
            sudo pacman -S $pack_name -y
        done
fi

echo -e "${cyan}done running debian.sh${reset}"