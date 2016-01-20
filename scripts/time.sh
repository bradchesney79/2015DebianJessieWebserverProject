#!/bin/bash

CONFIGURATION="${1:-'./setup.conf'}"

source $CONFIGURATION

printf "Set the timezone to UTC \n\n\n"

echo $TIMEZONE > /etc/timezone                     
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime # This sets the time