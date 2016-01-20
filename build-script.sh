#!/bin/bash

#CONFIGURATION="${1:-'./setup.conf'}"

source /root/bin/setup.conf

######################################################################
######################################################################

#####NOTES & SNIPPETS#####

######################################################################
######################################################################

#####TO DO



# improve reporting report

# improve troubleshooting resources

# remedy broken GUI SFTP -- works fine CLI

# update troubleshooting resources on github

# break into modular Ansible scripts

# <Enter>, <~>, <.> -- will break out of a locked SSH session, say if you blow up the server before closing the connection

######################################################################

#####NICE TO HAVE

# disk partitions

######################################################################

#####LEANING ON OTHERS

# is /etc/aliases specifically okay?
# is exim4/SPF/DMARC/DKIM more or less good to go?

#based upon:
# 
# https://www.linode.com/docs/security/securing-your-server
# https://www.thomas-krenn.com/en/wiki/Saving_Iptables_Firewall_Rules_Permanently
# https://bbs.archlinux.org/viewtopic.php?id=156064
# https://www.linode.com/docs/getting-started
# http://serverfault.com/questions/94991/setting-the-timezone-with-an-automated-script
# http://www.shellhacks.com/en/HowTo-Create-CSR-using-OpenSSL-Without-Prompt-Non-Interactive
# http://tcsoftware.net/blog/2012/02/installing-class-1-startssl-certificate-on-debian/
# https://www.startssl.com/?app=21
# https://www.linode.com/docs/websites/apache/running-fastcgi-php-fpm-on-debian-7-with-apache
# http://wiki.apache.org/httpd/PHP-FPM
# http://serverfault.com/a/672969/106593
# http://float64.uk/blog/2014/08/20/php-fpm-sockets-apache-mod-proxy-fcgi-ubuntu/
# https://chris-lamb.co.uk/posts/checklist-configuring-debian-system
# http://tecadmin.net/setup-dkim-with-postfix-on-ubuntu-debian/
# http://www.rackspace.com/knowledge_center/article/checking-system-load-on-linux
#CSR Generation-- use full state name and not the abbreviation
#http://www.cisco.com/c/en/us/support/docs/application-networking-services/sca-11000-series-secure-content-accelerators/22400-cert-request-22400.html
#http://www.html5rocks.com/en/tutorials/security/content-security-policy/
#https://www.linode.com/docs/tools-reference/linux-system-administration-basics
#http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html
#https://www.digitalocean.com/community/tutorials/how-to-share-php-sessions-on-multiple-memcached-servers-on-ubuntu-14-04
#https://www.digitalocean.com/community/tutorials/how-to-install-node-js-with-nvm-node-version-manager-on-a-vps
#https://www.digitalocean.com/community/tutorials/how-to-configure-virtual-memory-swap-file-on-a-vps
#https://cartalyst.com/manual/sentinel/2.0#configuration
#http://www.sitepoint.com/removing-the-pain-of-user-authorization-with-sentinel/


#http://serverfault.com/questions/570288/is-it-bad-to-redirect-http-to-https
#http://xdebug.org/docs/install
#https://www.jetbrains.com/phpstorm/help/configuring-xdebug.html
#http://xmodulo.com/block-network-traffic-by-country-linux.html

printf "\n##################################################"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n# SETUP SCRIPT START                             #"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n##################################################\n\n"

#date +%s >> /root/time.txt
pushd /root/bin

printf "\n########## SCRIPT EXECUTION PARTICULARS ##########\n\n"

#echo the config to the setup report

printf "\n########## CONFIGURE THE HOSTNAME & HOSTS OVERRIDES ###\n"

. /root/bin/scripts/host.sh

printf "\n########## SET THE TIMEZONE & TIME ###\n\n"

. /root/bin/scripts/time.sh

printf "\n########## APT SOURCES, FIRST UPDATE, & COMMON PACKAGES INSTALL ###\n\n"

. /root/bin/scripts/apt.sh

printf "\n########## UPDATE THE IPTABLES RULES ###\n"

. /root/bin/scripts/iptables.sh

printf "\n########## USING fail2ban DEFAULT CONFIG ###\n"

# See /etc/fail2ban/jail.conf for additional options


printf "\n########## CONFIGURE APACHE ###\n"

. /root/bin/scripts/install-apache.sh

printf "\n########## INSTALL MYSQL ###\n"

. /root/bin/scripts/mysql.sh

printf "\n########## INSTALL PHP ###\n"

. /root/bin/scripts/install-php.sh

printf "\n########## OPTIONALLY INSTALL DEVELOPMENT INSTANCE PACKAGES ###\n"

. /root/bin/scripts/dev.sh

printf "\n########## CONFIGURE APACHE ###\n\n"

. /root/bin/scripts/configure-apache.sh

printf "\n########## SETUP THE DEFAULT SITE FASTCGI ###\n"

. /root/bin/scripts/configure-php.sh
. /root/bin/scripts/memcached.sh

printf "\n########## INSTALL WEBDEVELOPER RESOURCES ###\n"


printf "\n########## RESTART THE WEBSERVER SERVICES ###\n"

service apache2 restart
service php5-fpm restart

if [ "$DEV" = 'TRUE' ]
then
echo "<?php phpinfo(); ?>" >> /var/www/http/index.php
fi

printf "\n########## SETUP MAIL ###\n"

. /root/bin/scripts/system-mail.sh

printf "\n########## CONFIGURE SYSSTAT ###\n"

sed -i "s/ENABLED=\"false\"/ENABLED=\"true\"/" /etc/default/sysstat

printf "\n########## CLEAN UP ###\n"

printf "\nLast autoremove of packages\n\n"

apt-get -y autoremove

printf "\n##################################################"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n# SETUP SCRIPT END                               #"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n##################################################\n\n"

. /root/bin/scripts/troubleshooting.sh

printf "\n Add a person user. Best practices dictate using the root account less. ( ./add-web-person-user.sh $USERID1001 TRUE )\n"

./root/bin/scripts/add-web-person-user.sh $USERID1001 TRUE

usermod -a --groups $USER $USERID1001

printf "\nSSL Certs come from a third-party, be sure to get the applicable files and put them in the appropriate directory.\n"

printf "\nThinking inside my head that a few minutes of uptime is trivial at this point-- nobody is actually depending on the system being up or even using it at this exact moment-- a reboot might be a smart idea.\n"

printf "\nSet up Reverse DNS while you wait if applicable-- gets rid of those pesky problem with the server being referred to by the linode assigned machine name in most places."

date +%s >> /root/endtime.txt

popd

exit 0