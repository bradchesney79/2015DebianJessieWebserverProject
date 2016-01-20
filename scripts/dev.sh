#!/bin/bash

#CONFIGURATION="${1:-'../setup.conf'}"

#source $CONFIGURATION

if [ "$DEV" = 'TRUE' ]
  then
  apt-get -y install php5-dev php5-xdebug make build-essential g++
fi