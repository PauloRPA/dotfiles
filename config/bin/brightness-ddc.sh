#!/usr/bin/env bash

bold="\u001b[1m"
reset="\u001b[0m"

if [[ -z "$1" ]]; then
    echo "Usage ./brightness-ddc.sh <up|down>"
    echo -e ${bold}Up:$reset Increase screen brightness
    echo -e ${bold}Down:$reset Decrease screen brightness
    exit 0
fi

if [[ "$1" == "up" ]]; then
    systemctl --user stop plasma-powerdevil
    ddcutil setvcp 10 --bus 4 25
    exit 0
fi

if [[ "$1" == "down" ]]; then
    systemctl --user stop plasma-powerdevil
    ddcutil setvcp 10 --bus 4 0 
    exit 0
fi




