#!/bin/bash

######################################################################
######################################################################

#####NOTES & SNIPPETS#####

######################################################################
######################################################################

#based upon:
# 
# http://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash


usage(){
	echo "Usage: $0"
	echo ""
	echo "One mandatory argument"
	echo "One optional argument, TRUE||FALSE, space delimited"
	echo ""
	echo "USERNAME (bradchesney79)*"
	echo ""
	echo "SUDO USER (FALSE)✓"
	echo ""
	echo "* denotes a required argument"
	echo "✓ denotes a default value"
	exit 1
}
 
# invoke  usage
# call usage() function if parameters not supplied
[[ $# -eq 0 ]] && usage

if [ -z "$1" ]
then usage
fi

if [ "$1" == "-h" ]
then usage
fi

if [ "$1" == "--help" ]
then usage
fi

adduser "$1"



if [ "$2" ]
  then
	if [ "$2" == TRUE ]
	  then
	  echo "Adding User to sudoers"
	  echo "$1 ALL=(ALL:ALL) ALL" | (EDITOR="tee -a" visudo)
  fi
fi

cat /etc/group | tr '\n' ' '

echo "How to give a user access to other groups:"
echo "usermod -a -groups <pre-existing-group> [<pre-existing-group>]..."