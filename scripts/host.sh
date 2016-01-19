#!/bin/bash

CONFIGURATION="${1:-'../setup.conf'}"

source $CONFIGURATION

printf "\nSet the hostname\n\n"

hostnamectl set-hostname $HOSTNAME

printf "\n########## UPDATE THE HOSTS FILE ###\n"

printf "\nFully populate hosts file\n\n"

printf "127.0.0.1\t\t\tlocalhost.localdomain localhost\n" > /etc/hosts
printf "127.0.1.1\t\t\tdebian\n" >> /etc/hosts
printf "$IPV4\t\t\t\t$HOSTNAME.$DOMAIN $HOSTNAME\n" >> /etc/hosts
printf "\n# The following lines are desirable for IPv6 capable hosts\n" >> /etc/hosts
printf "::1\t\t\t\tlocalhost ip6-localhost ip6-loopback\n" >> /etc/hosts
printf "ff02::1\t\t\t\tip6-allnodes\n" >> /etc/hosts
printf "ff02::2\t\t\t\tip6-allrouters\n" >> /etc/hosts
printf "$IPV6\t$HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts