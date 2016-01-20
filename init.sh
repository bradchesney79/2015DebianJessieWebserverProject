#!/bin/bash

####### INIT SCRIPT ####

date +%s >> /root/basestarttime.txt

mkdir -p /root/bin

pushd /root/bin

wget https://github.com/bradchesney79/2015DebianJessieWebserverProject/archive/master.zip

unzip /root/bin/master.zip

cp -R /root/bin/2015DebianJessieWebserverProject-master/* /root/bin/

chmod -R 770 /root/bin/*
find /root/bin/* -type d -exec chmod -R 771 {} \;

rm -rf /root/init.sh /root/bin/2015DebianJessieWebserverProject /root/bin/master.zip

popd