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
echo -e "${cyan}arch.sh -- running${reset}"

#package arrays
declare -a pacman_list
declare -a yay_list

while read  line;
    do
    pacman_list+=$line
done < ../package_lists/pacman.list
while read  line;
    do
    yay_list+=$line
done < ../package_lists/yay.list

#confirm 
base_os=$(cat /etc/os-release | grep -w ID_LIKE)
base_os=${base_os:8}

if [ $base_os != "arch" ];  then
    exit
fi
echo -e "os confirmed \nmooving on \nupdate repositories"

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
        #installing AUR
        for pack_name in ${yay_list[*]}
            do
            sudo -u $user_name yay -S $pack_name
        done
elif [ $choise == "no" ];
    then
        #install packages using loop
        for pack_name in ${pacman_list[*]}
            do
            sudo pacman -S $pack_name --noconfirm
        done
        #installing AUR
        for pack_name in ${yay_list[*]}
            do
            sudo -u $user_name yay -S $pack_name --noconfirm
        done
fi

echo -e "${cyan}done running arch.sh${reset}"