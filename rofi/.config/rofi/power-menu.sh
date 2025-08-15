#!/bin/bash

options="Shutdown\nReboot\nLogout\nSuspend\nLock"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu:")

case $chosen in
    "Shutdown")
        shutdown now
        ;;
    "Reboot")
        reboot
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Lock")
        # Replace with your lock command (swaylock, gtklock, etc.)
        swaylock
        ;;
esac
