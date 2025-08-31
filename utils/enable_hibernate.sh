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

# --------------------------------------------------------------------------
freez_support=$(cat /sys/power/state)
if [ "$freez_support" == "freeze mem disk" ];
    then
        uuid=$(grep swap /etc/fstab | grep -i uuid)
        uuid=${uuid:0:41}
        echo -e -n "$uuid"
        sudo printf "GRUB_CMDLINE_LINUX_DEFAULT='quiet splash resume=$uuid'" >> /etc/default/grub.back
    fi


sudo printf "[Re-enable hibernate by default in upower]\nIdentity=unix-user:*\nAction=org.freedesktop.upower.hibernate\nResultActive=yes\n[Re-enable hibernate by default in logind]\nIdentity=unix-user:*\nAction=org.freedesktop.login1.hibernate\nResultActive=yes" >> /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla.bak
