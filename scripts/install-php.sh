#!/bin/bash

CONFIGURATION="${1:-'./setup.conf'}"

source $CONFIGURATION

printf "\nInstall the PHP packages\n\n"

apt-get -y install php5-fpm libapache2-mod-php5 php-pear php5-curl php5-mysql php5-gd php5-gmp php5-mcrypt php5-memcached php5-imagick php5-intl 

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.original