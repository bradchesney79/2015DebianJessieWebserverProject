#!/bin/bash

####### INIT SCRIPT ####

mkdir -p /root/bin

pushd /root/bin

wget https://github.com/bradchesney79/2015DebianJessieWebserverProject/archive/master.zip

unzip master.zip

cp -R /root/bin/2015DebianJessieWebserverProject/* /root/bin/

chmod -R 770 /root/bin/*
find /root/bin/* -type d -exec chmod -R 771 {} \;