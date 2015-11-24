#!/bin/bash

#SET CONSTANTS 3/3 required
#1 username

#2 associated website group

#3 sudo access, "true"/"false"

adduser $1 --add_extra_groups $2

if [ $3 ]
  then
    echo "Adding User to sudoers"
    echo "$1 ALL=(ALL:ALL) ALL" | (EDITOR="tee -a" visudo)
fi

cat /etc/group | tr '\n' ' '

echo "How to give a user access to other groups:"
echo "usermod -a -groups <existing-group> [<existing-group>]..."