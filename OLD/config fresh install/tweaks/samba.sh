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
echo -e "${cyan}samba.sh -- running${reset}"

echo -e "installing samaba server"
sudo apt update
sudo apt install samba -y

echo -e -n "${lgreen}adding folde paths${reset} --> "
# paths to share
sudo printf '\n[wkdkavishka-linux-storage-320]\n\tcomment = storage-320\n\tpath = /mnt/Storage-320/\n\tread only = yes\n\tbrowsable = yes' >> /etc/samba/smb.conf
sudo printf '\n[wkdkavishka-linux-storage-500]\n\tcomment = storage-500\n\tpath = /mnt/Storage-500/\n\tread only = yes\n\tbrowsable = yes' >> /etc/samba/smb.conf
# restarting services
sudo service smbd restart
sudo ufw allow samba
# ading user
echo -e -n "${lgreen}enter the current user${reset} --> "
read current_user
sudo smbpasswd -a $current_user
# done
exit
