#!/bin/bash

#CONFIGURATION="${1:-'../setup.conf'}"

#source $CONFIGURATION

sed -i "s/ServerSignature.*/ServerSignature Off/" /etc/apache2/conf-available/security.conf
sed -i "s/ServerTokens.*/ServerTokens Prod/" /etc/apache2/conf-available/security.conf

printf "\n########## CREATE A USER FOR THE DEFAULT SITE ###\n"
printf "\n########## THIS AIDS RESOURCE SEGREGATION ###\n"
printf "\n########## www-data HAS ACCESS TO ALL WEBSERVER FUN ###\n"

useradd -d $WEBROOT -p $PASSWORD -c "Default Web Site User" $USER

printf "\n########## LOCK THE NOT USER ACCOUNT THE WEBSITE RUNS AS ###\n"
passwd -l $USER

printf "\n########## ADD SSL CONFIGURATION INCLUDE ###\n"


printf "\nWrite Apache SSL include file\n\n"

mkdir -pv /etc/apache2/includes


printf "\n        #   SSL Engine Switch:\n" > /etc/apache2/includes/vhost-ssl
printf "        #   Enable/Disable SSL for this virtual host.\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLEngine on\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLProtocol all -SSLv2 -SSLv3\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLHonorCipherOrder On\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS\n" >> /etc/apache2/includes/vhost-ssl

chown www-data:www-data /etc/apache2/includes/vhost-ssl

printf "\n########## CONFIGURE THE DEFAULT SITE ###\n"

printf "\n########## PREPARE DIRECTORY STRUCTURE FOR DEFAULT SITE ###\n"


printf "\nCreate the Default Site directory structure\n\n"

rm -rf /var/www/html

mkdir $WEBROOT/http
mkdir $WEBROOT/https
mkdir $WEBROOT/fonts
mkdir $WEBROOT/certs
mkdir $WEBROOT/certs/$YEAR
mkdir $WEBROOT/certs/$YEAR/$SSLPROVIDER
mkdir $LOGDIR
mkdir $WEBROOT/sockets
mkdir $WEBROOT/tmp

chown -R $USER:$USER $WEBROOT
chmod -R 774 $WEBROOT

chown -R www-data:www-data $WEBROOT/sockets
find $WEBROOT -type d -exec chmod -R 775 {} \;