#!/bin/bash

##### THE USER INFO, SCRIPT LOCATION, & DATE #####

EXECUTOR=`whoami`
SCRIPTLOCATION=`pwd`
UNIXTIMESTAMP=`date +%s`
DATE=`date +%Y-%m-%d`
YEAR=`date +%Y`
EXECUTIONLOG="/var/log/auto-install.log"

TROUBLESHOOTINGFILES="$SCRIPTLOCATION/troubleshooting/$UNIXTIMESTAMP"

##### HOST INFO #####

HOSTNAME="www"
DOMAIN="rustbeltrebellion.com"
IPV4="45.33.112.226"
IPV6="2600:3c00::f03c:91ff:fe26:42cf"
TIMEZONE="Etc/UTC" # This is a server, UTC is the only appropriate timezone

##### PERSON RESPONSIBLE FOR DEFAULT DOMAIN #####

USER="administrator"
PASSWORD="dummypassword"
EMAIL="$USER@$DOMAIN"

WEBROOT="/var/www"
LOGDIR="/var/www/logs"


##### SSL KEY PARTICULARS #####

KEYSIZE="2048"
ALGORITHM="-sha256"

##### DEFAULT DOMAIN INFO FOR SSL #####

COUNTRY="US"
STATE="Ohio"
LOCALITY="Eastlake"
ORGANIZATION="Rust Belt Rebellion"
ORGANIZATIONALUNIT="Web Development"

SSLPROVIDER="start-ssl"


#####  #####


printf "\n##################################################" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n# SETUP SCRIPT START                             #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n##################################################\n\n" >> ${EXECUTIONLOG}

printf "\n########## SCRIPT EXECUTION PARTICULARS ##########\n\n" >> ${EXECUTIONLOG}

printf "\nEXECUTOR - $EXECUTIONLOGLOCATION" >> ${EXECUTIONLOG}
printf "\nSCRIPTLOCATION - $SCRIPTLOCATION" >> ${EXECUTIONLOG}
printf "\nEXECUTIONLOG - $EXECUTIONLOG" >> ${EXECUTIONLOG}
printf "\nTROUBLESHOOTINGFILES - $TROUBLESHOOTINGFILES" >> ${EXECUTIONLOG}
printf "\n$DATE\n\n" >> ${EXECUTIONLOG}


printf "\n########## RECORD THE VARIABLES FOR POSTERITY ####\n\n" >> ${EXECUTIONLOG}

printf "\nHOSTNAME - $HOSTNAME\n" >> ${EXECUTIONLOG}
printf "\nDOMAIN - $DOMAIN\n" >> ${EXECUTIONLOG}
printf "\nIPV4 - $IPV4\n" >> ${EXECUTIONLOG}
printf "\nIPV6 - $IPV6\n" >> ${EXECUTIONLOG}
printf "\nTIMEZONE - $TIMEZONE\n\n" >> ${EXECUTIONLOG}

printf "\nUSER - $USER\n\n" >> ${EXECUTIONLOG}

printf "\nCOUNTRY - $COUNTRY\n" >> ${EXECUTIONLOG}
printf "\nSTATE - $STATE\n" >> ${EXECUTIONLOG}
printf "\nLOCALITY - $LOCALITY\n" >> ${EXECUTIONLOG}
printf "\nORGANIZATION - $ORGANIZATION\n" >> ${EXECUTIONLOG}
printf "\nORGANIZATIONALUNIT - $ORGANIZATIONALUNIT\n" >> ${EXECUTIONLOG}
printf "\nEMAIL - $EMAIL\n\n" >> ${EXECUTIONLOG}

printf "\nPASSWORD - $PASSWORD\n\n" >> ${EXECUTIONLOG}

printf "\nSSLPROVIDER - $SSLPROVIDER\n\n" >> ${EXECUTIONLOG}

printf "\n########## CONFIGURE THE HOSTNAME ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Set the hostname\n\n" >> ${EXECUTIONLOG}

hostnamectl set-hostname $HOSTNAME >> ${EXECUTIONLOG}

printf "\n########## UPDATE THE HOSTS FILE ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Fully populate hosts file\n\n" >> ${EXECUTIONLOG}

printf "127.0.0.1\t\t\tlocalhost.localdomain localhost\n" > /etc/hosts
printf "127.0.1.1\t\t\tdebian\n" >> /etc/hosts
printf "$IPV4\t\t$HOSTNAME.$DOMAIN $HOSTNAME\n" >> /etc/hosts
printf "\n" >> /etc/hosts
printf "# The following lines are desirable for IPv6 capable hosts\n" >> /etc/hosts
printf "::1\t\t\t\tlocalhost ip6-localhost ip6-loopback\n" >> /etc/hosts
printf "ff02::1\t\t\t\tip6-allnodes\n" >> /etc/hosts
printf "ff02::2\t\t\t\tip6-allrouters\n" >> /etc/hosts
printf "$IPV6\t$HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts

printf "\n########## SET THE TIMEZONE & TIME ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Set the timezone to UTC \n\n" >> ${EXECUTIONLOG}

echo $TIMEZONE > /etc/timezone                     
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime # This sets the time

printf "\n########## UPDATE APT SOURCES ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Update apt sources\n\n" >> ${EXECUTIONLOG}

echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://backports.debian.org/debian-backports squeeze-backports main" >> /etc/apt/sources.list

printf "\n########## UPDATE THE SYSTEM ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Update the system\n\n" >> ${EXECUTIONLOG}

apt-get -qy update >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Upgrade the system\n\n" >> ${EXECUTIONLOG}

apt-get -qy dist-upgrade >> ${EXECUTIONLOG}

printf "\n########## INSTALL THE FIRST BATCHES OF PACKAGES ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Install the first batch of packages for Apache & PHP\n\n" >> ${EXECUTIONLOG}

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections >> ${EXECUTIONLOG}
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections >> ${EXECUTIONLOG}

apt-get -qy install sudo tcl perl python3 apache2 tmux iptables-persistent ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban libapache2-mod-fastcgi php5-fpm libapache2-mod-php5 php-pear php5-curl >> ${EXECUTIONLOG}

printf "\n########## CLEAN UP ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "First autoremove of packages\n\n" >> ${EXECUTIONLOG}

apt-get -qy autoremove >> ${EXECUTIONLOG}


printf "\n########## UPDATE THE IPTABLES RULES ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Update the IP tables rules\n\n" >> ${EXECUTIONLOG}

echo "*filter" > /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Allow all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0" >> /etc/iptables/rules.v4
echo "-A INPUT -i lo -j ACCEPT" >> /etc/iptables/rules.v4
echo "-A INPUT -d 127.0.0.0/8 -j REJECT" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Accept all established inbound connections" >> /etc/iptables/rules.v4
echo "-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Allow all outbound traffic - you can modify this to only allow certain traffic" >> /etc/iptables/rules.v4
echo "-A OUTPUT -j ACCEPT" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Allow HTTP and HTTPS connections from anywhere (the normal ports for websites and SSL)." >> /etc/iptables/rules.v4
echo "-A INPUT -p tcp --dport 80 -j ACCEPT" >> /etc/iptables/rules.v4
echo "-A INPUT -p tcp --dport 443 -j ACCEPT" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Allow SSH connections" >> /etc/iptables/rules.v4
echo "#" >> /etc/iptables/rules.v4
echo "#  The -dport number should be the same port number you set in sshd_config" >> /etc/iptables/rules.v4
echo "#" >> /etc/iptables/rules.v4
echo "-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Allow ping" >> /etc/iptables/rules.v4
echo "-A INPUT -p icmp --icmp-type echo-request -j ACCEPT" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Log iptables denied calls" >> /etc/iptables/rules.v4
echo "#-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "#  Drop all other inbound - default deny unless explicitly allowed policy" >> /etc/iptables/rules.v4
echo "-A INPUT -j DROP" >> /etc/iptables/rules.v4
echo "-A FORWARD -j DROP" >> /etc/iptables/rules.v4
printf "\n" >> /etc/iptables/rules.v4
echo "COMMIT" >> /etc/iptables/rules.v4

printf "\n########## APPLY THE IPTABLES RULES ###\n" >> ${EXECUTIONLOG}

printf "\nApply the IP tables rules\n\n" >> ${EXECUTIONLOG}

iptables-restore < /etc/iptables/rules.v4 >> ${EXECUTIONLOG}

printf "\n########## USING fail2ban DEFAULT CONFIG ###\n" >> ${EXECUTIONLOG}

# See /etc/fail2ban/jail.conf for additional options


printf "\n########## CONFIGURE APACHE ###\n" >> ${EXECUTIONLOG}

printf "\n########## CREATE A USER FOR THE DEFAULT SITE ###\n" >> ${EXECUTIONLOG}
printf "\n########## THIS AIDS RESOURCE SEGREGATION ###\n" >> ${EXECUTIONLOG}
printf "\n########## www-data HAS ACCESS TO ALL WEBSERVER FUN ###\n" >> ${EXECUTIONLOG}

useradd -d $WEBROOT -p $PASSWORD -c "Default Web Site User" $USER >> ${EXECUTIONLOG}

printf "\n########## ADD SSL CONFIGURATION INCLUDE ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Write Apache SSL include file\n\n" >> ${EXECUTIONLOG}

mkdir -pv /etc/apache2/includes >> ${EXECUTIONLOG}


printf "\n        #   SSL Engine Switch:\n" > /etc/apache2/includes/vhost-ssl
printf "        #   Enable/Disable SSL for this virtual host.\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLEngine on\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLProtocol all -SSLv2 -SSLv3\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLHonorCipherOrder On\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS\n" >> /etc/apache2/includes/vhost-ssl

chown www-data:www-data /etc/apache2/includes/vhost-ssl >> ${EXECUTIONLOG}

printf "\n########## CONFIGURE THE DEFAULT SITE ###\n" >> ${EXECUTIONLOG}

printf "\n########## PREPARE DIRECTORY STRUCTURE FOR DEFAULT SITE ###\n" >> ${EXECUTIONLOG}

printf "\n" >> ${EXECUTIONLOG}
printf "Create the Default Site directory structure\n\n" >> ${EXECUTIONLOG}

rm -rf /var/www/html>> ${EXECUTIONLOG}

mkdir $WEBROOT/http >> ${EXECUTIONLOG}
mkdir $WEBROOT/https >> ${EXECUTIONLOG}
mkdir $WEBROOT/fonts >> ${EXECUTIONLOG}
mkdir $WEBROOT/certs >> ${EXECUTIONLOG}
mkdir $WEBROOT/certs/$YEAR >> ${EXECUTIONLOG}
mkdir $WEBROOT/certs/$YEAR/$SSLPROVIDER >> ${EXECUTIONLOG}
mkdir $LOGDIR >> ${EXECUTIONLOG}
mkdir $WEBROOT/sockets >> ${EXECUTIONLOG}
mkdir $WEBROOT/tmp >> ${EXECUTIONLOG}

chown -r $USER:$USER $WEBROOT >> ${EXECUTIONLOG}

chmod -r 754 $WEBROOT >> ${EXECUTIONLOG}
find $WEBROOT -type d -exec chmod 751 {} \; >> ${EXECUTIONLOG}

chown -R www-data:www-data $WEBROOT/sockets >> ${EXECUTIONLOG}
chmod -R 666 $WEBROOT/sockets >> ${EXECUTIONLOG}

printf "\n########## CONFIGURE PHP ###\n" >> ${EXECUTIONLOG}

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.original 

#sed -i '.bak' 's/find/replace' file.txt


printf "\n########## MODIFY DEFAULT VHOST CONFIGURATION FILES ###\n" >> ${EXECUTIONLOG}

mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.original >> ${EXECUTIONLOG}


printf "<VirtualHost *:80>\n" > /etc/apache2/sites-available/default.conf
printf "  ServerName $DOMAIN\n" >> /etc/apache2/sites-available/default.conf
printf "  ServerAlias $HOSTNAME.$DOMAIN\n\n" >> /etc/apache2/sites-available/default.conf
printf "  ServerAdmin $EMAIL\n" >> /etc/apache2/sites-available/default.conf
printf "  DocumentRoot $WEBROOT/http\n\n" >> /etc/apache2/sites-available/default.conf
printf "  ErrorLog $LOGDIR/error.log\n" >> /etc/apache2/sites-available/default.conf
printf "  CustomLog $LOGDIR/access.log combined\n\n" >> /etc/apache2/sites-available/default.conf

printf "  <FilesMatch \"\.php$\">\n" >> /etc/apache2/sites-available/default.conf
printf "    SetHandler \"proxy:unix://$WEBROOT/sockets/$DOMAIN.sock|fcgi://$DOMAIN\"\n" >> /etc/apache2/sites-available/default.conf
printf "  </FilesMatch>\n\n" >> /etc/apache2/sites-available/default.conf

printf "  <Proxy fcgi://$DOMAIN>\n" >> /etc/apache2/sites-available/default.conf
printf "    ProxySet connectiontimeout=5 timeout=240\n" >> /etc/apache2/sites-available/default.conf
printf "  </Proxy>\n\n" >> /etc/apache2/sites-available/default.conf


printf "</VirtualHost>\n" >> /etc/apache2/sites-available/default.conf


cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.original >> ${EXECUTIONLOG}


printf "<IfModule mod_ssl.c>\n" > /etc/apache2/sites-available/default-ssl.conf
printf "    <VirtualHost _default_:443>\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        ServerName $DOMAIN\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        ServerAlias *.$DOMAIN\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        DocumentRoot $WEBROOT/https\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        <Directory $WEBROOT/https/>\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            Options Indexes FollowSymLinks MultiViews\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            AllowOverride None\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            Order allow,deny\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            allow from all\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        </Directory>\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        LogLevel warn\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        ErrorLog $WEBROOT/logs/error-ssl.log\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        CustomLog $WEBROOT/logs/access-ssl.log combined\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "        <FilesMatch \"\.php$\">\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "          SetHandler \"proxy:unix://$WEBROOT/sockets/$DOMAIN-ssl.sock|fcgi://$DOMAIN-SSL\"\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        </FilesMatch>\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "        <Proxy fcgi://$DOMAIN-SSL>\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "          ProxySet connectiontimeout=5 timeout=240\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        </Proxy>\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "        Include /etc/apache2/includes/vhost-ssl\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "        #   The StartSSL Certificate\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.crt\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCertificateKeyFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCertificateChainFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.ca.pem\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCACertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        \n" >> /etc/apache2/sites-available/default-ssl.conf

printf "        #   SSL Protocol Adjustments:\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   The safe and default but still SSL/TLS standard compliant shutdown\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   approach is that mod_ssl sends the close notify alert but doesn't wait for\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   the close notify alert from client. When you need a different shutdown\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   approach you can use one of the following variables:\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   o ssl-unclean-shutdown:\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     This forces an unclean shutdown when the connection is closed, i.e. no\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     SSL close notify alert is send or allowed to received.  This violates\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     the SSL/TLS standard but is needed for some brain-dead browsers. Use\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     this when you receive I/O errors because of the standard approach where\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     mod_ssl sends the close notify alert.\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   o ssl-accurate-shutdown:\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     This forces an accurate shutdown when the connection is closed, i.e. a\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     SSL close notify alert is send and mod_ssl waits for the close notify\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     alert of the client. This is 100%% SSL/TLS standard compliant, but in\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     practice often causes hanging connections with brain-dead browsers. Use\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     this only for browsers where you know that their SSL implementation\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #     works correctly.\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   Notice: Most problems of broken clients are also related to the HTTP\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   keep-alive facility, so you usually additionally want to disable\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   keep-alive for those clients, too. Use variable "nokeepalive" for this.\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   Similarly, one has to force some clients to use HTTP/1.0 to workaround\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   their broken HTTP/1.1 implementation. Use variables "downgrade-1.0" and\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        #   "force-response-1.0" for this.\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        BrowserMatch \"MSIE [2-6]\" \x5C\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            nokeepalive ssl-unclean-shutdown \x5C\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            downgrade-1.0 force-response-1.0\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            # MSIE 7 and newer should be able to use keepalive\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        BrowserMatch \"MSIE [17-9]\" ssl-unclean-shutdown\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "    </VirtualHost>\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "</IfModule>\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "\n########## ADD STARTSSSL CLASS2 CERTIFICATE FILES ###\n" >> ${EXECUTIONLOG}

wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.sha2.ca.pem https://www.startssl.com/certs/class2/sha2/pem/sub.class2.server.sha2.ca.pem >> ${EXECUTIONLOG}
wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem https://www.startssl.com/certs/ca.pem >> ${EXECUTIONLOG}

printf "\n########## GENERATE SSL FOR DEFAULT SITE ###\n" >> ${EXECUTIONLOG}
printf "\n" >> ${EXECUTIONLOG}
printf "Configure Apache\n\n" >> ${EXECUTIONLOG}

printf "Generating SSL\n\n" >> ${EXECUTIONLOG}

printf "openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj \"/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN\"\n\n" >> ${EXECUTIONLOG}

openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN" >> ${EXECUTIONLOG}

#####!!!!! So, skipping swapping out mpm_prefork and disabling the ssl host allows the webserver to start
#####!!!!! Using mpm_worker causes an invalid config based upon mpm_worker being threaded and php5-fpm not being threadsafe

printf "\n########## DISABLE THE PREFORK PHP APACHE MODULE ###\n" >> ${EXECUTIONLOG}
a2dismod mpm_prefork >> ${EXECUTIONLOG}

printf "\n########## ENABLE THE MPM WORKER PHP APACHE MODULE ###\n" >> ${EXECUTIONLOG}
a2enmod actions fastcgi alias ssl mpm_worker >> ${EXECUTIONLOG}

printf "\n########## REMOVE EXISTING ENABLED SITES ###\n" >> ${EXECUTIONLOG}
rm /etc/apache2/sites-enabled/* >> ${EXECUTIONLOG}

printf "\n########## ENABLE THE DEFAULT SITES ###\n" >> ${EXECUTIONLOG}
a2ensite default.conf >> ${EXECUTIONLOG}
a2ensite default-ssl.conf >> ${EXECUTIONLOG}

printf "\n########## SETUP THE DEFAULT SITE FASTCGI ###\n" >> ${EXECUTIONLOG}

printf "\n########## CONFIG PHP-FPM ###\n" >> ${EXECUTIONLOG}

mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.original
cp /etc/php5/fpm/pool.d/www.conf.original /etc/php5/fpm/pool.d/${DOMAIN}.conf


printf "\n########## DEFAULT HTTP POOL ###\n" >> ${EXECUTIONLOG}

sed -i "s/\[www\]/\[$DOMAIN\]/" /etc/php5/fpm/pool.d/${DOMAIN}.conf >> ${EXECUTIONLOG}
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN.sock|" /etc/php5/fpm/pool.d/${DOMAIN}.conf >> ${EXECUTIONLOG}

sed -i "s/user = www-data/user = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf >> ${EXECUTIONLOG}
sed -i "s/group = www-data/group = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf >> ${EXECUTIONLOG}

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}.conf >> ${EXECUTIONLOG}

printf "\n########## DEFAULT HTTPS POOL ###\n" >> ${EXECUTIONLOG}

sed -i "s/\[www\]/\[$DOMAIN-ssl\]/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf >> ${EXECUTIONLOG}
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN-SSL.sock|" /etc/php5/fpm/pool.d/${DOMAIN}.conf >> ${EXECUTIONLOG}

sed -i "s/user = www-data/user = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf >> ${EXECUTIONLOG}
sed -i "s/group = www-data/group = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf >> ${EXECUTIONLOG}

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf >> ${EXECUTIONLOG}
printf "\n########## RESTART THE WEBSERVER SERVICES ###\n" >> ${EXECUTIONLOG}

service apache2 restart
service php-fpm restart

printf "\n##################################################" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n# SETUP SCRIPT END                               #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n##################################################\n\n" >> ${EXECUTIONLOG}

printf "\n##################################################" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n# INITIAL TROUBLESHOOTING SCRIPT START           #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n##################################################\n\n" >> ${EXECUTIONLOG}

printf "\n########## CREATE A PLACE TO STORE THE OUTPUT FOR SHARING TROUBLESHOOTING DATA###\n" >> ${EXECUTIONLOG}

printf "Location of troubleshooting files: $TROUBLESHOOTINGFILES\n\n"
mkdir -pv ${TROUBLESHOOTINGFILES}

printf "Start collecting config files\n\n" >> ${EXECUTIONLOG}

cp /etc/hosts ${TROUBLESHOOTINGFILES}/etc-hosts

cp /etc/apt/sources.list ${TROUBLESHOOTINGFILES}/etc-apt-sources.list

cp /etc/iptables/rules.v4 ${TROUBLESHOOTINGFILES}/etc-iptables-rules.v4

cp /etc/apache2/sites-available/default.conf ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available-default.conf

cp /etc/apache2/includes/vhost-ssl ${TROUBLESHOOTINGFILES}/etc-apache2-includes-vhost-ssl

cp /etc/apache2/sites-available/default-ssl.conf ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available-default-ssl.conf

cp /etc/php5/fpm/php.ini ${TROUBLESHOOTINGFILES}/etc-php5-fpm-php.ini

cp /etc/apache2/mods-available/fastcgi.conf ${TROUBLESHOOTINGFILES}/etc-apache2-mods-available-fastcgi.conf


cp /etc/php5/fpm/pool.d/${DOMAIN}.conf ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d-${DOMAIN}.conf

printf "Start collecting log files\n\n" >> ${EXECUTIONLOG}

printf "Apache log files\n" >> ${EXECUTIONLOG}
tail ${LOGDIR}/error.log >> ${TROUBLESHOOTINGFILES}/apache-error.log
tail ${LOGDIR}/access.log >> ${TROUBLESHOOTINGFILES}/apache-access.log

printf "FPM log files\n" >> ${EXECUTIONLOG}
tail /var/log/php5-fpm.log >> ${TROUBLESHOOTINGFILES}/php5-fpm.log

printf "Whole shebang log files\n\n" >> ${EXECUTIONLOG}
cp ${EXECUTIONLOG} ${TROUBLESHOOTINGFILES}/execution.log

printf "Create troubleshooting report for pastebin\n\n" >> ${EXECUTIONLOG}


#USEFUL FOR CUT/PASTE
#printf "##########  ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
#cat  >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## TROUBLESHOOTING REPORT $DATE $UNIXTIMESTAMP ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## PHP MODULE LOADED ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
apachectl -V | grep -i mpm >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n########## PHP MODULE THREAD SAFETY ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
php -i | grep Thread >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## HOSTS ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-hosts >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## SOURCES.LIST ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-apt-sources.list >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## IPTABLES-RULES.V4 ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-iptables-rules.v4 >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## SITES-AVAILABLE/DEFAULT.CONF ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available-default.conf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## INCLUDES/VHOST-SSL ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-apache2-includes-vhost-ssl >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## SITES-AVAILABLE/DEFAULT-SSL.CONF ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available-default-ssl.conf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## PHP.INI ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-php5-fpm-php.ini >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## FPM/POOL.D/$DOMAIN.CONF ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d-${DOMAIN}.conf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## FPM/POOL.D/$DOMAIN-SSL.CONF ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d-${DOMAIN}-ssl.conf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## APACHE ACCESS.LOG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/apache-access.log >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## APACHE ERROR.LOG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/apache-error.log >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## PHP-FPM LOG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/php5-fpm.log >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## UNABRIDGED SETUP LOG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/execution.log >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n##################################################" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n# INITIAL TROUBLESHOOTING SCRIPT END             #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n#                                                #" >> ${EXECUTIONLOG}
printf "\n##################################################\n\n" >> ${EXECUTIONLOG}

######################################################################
######################################################################

#####NOTES & SNIPPETS#####

######################################################################
######################################################################


SSLEngine on

SSLProtocol all -SSLv2 -SSLv3
SSLHonorCipherOrder On
SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS




##### INSTALL MYSQL #####

    sudo apt-get install mysql-server


    mysql_secure_installation





    mysql -u root -p


##### INSTALL IMAGICK #####











        # phpMyAdmin default Apache configuration

Alias /dbmanager /usr/share/phpmyadmin
printf "        <FilesMatch "\.(shtml|phtml|php)$">\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "                SSLOptions +StdEnvVars\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        </FilesMatch>\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        <Directory /usr/lib/cgi-bin>\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "                SSLOptions +StdEnvVars\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        </Directory>\n\n" >> /etc/apache2/sites-available/default-ssl.conf
<Directory /usr/share/phpmyadmin>
        Options FollowSymLinks
        DirectoryIndex index.php

        <IfModule mod_php5.c>
                AddType application/x-httpd-php .php

                php_flag magic_quotes_gpc Off
                php_flag track_vars On
                php_flag register_globals Off
                php_admin_flag allow_url_fopen Off
                php_value include_path .
                php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
                php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/
        </IfModule>
        
</Directory>

# Authorize for setup
<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authn_file.c>
    AuthType Basic
    AuthName "phpMyAdmin Setup"
    AuthUserFile /etc/phpmyadmin/htpasswd.setup
    </IfModule>
#    Require valid-user
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/libraries>
    Order Deny,Allow
    Deny from All
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Order Deny,Allow
    Deny from All
</Directory>



sudo sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf

apt-get install php5-mysql php5-curl php5-gd php5-gmp php5-mcrypt php5-memcached php5-imagick php5-intl php5-xdebug


disable_functions = “apache_child_terminate, apache_setenv, define_syslog_variables, escapeshellarg, escapeshellcmd, eval, exec, fp, fput, ftp_connect, ftp_exec, ftp_get, ftp_login, ftp_nb_fput, ftp_put, ftp_raw, ftp_rawlist, highlight_file, ini_alter, ini_get_all, ini_restore, inject_code, mysql_pconnect, openlog, passthru, php_uname, phpAds_remoteInfo, phpAds_XmlRpc, phpAds_xmlrpcDecode, phpAds_xmlrpcEncode, popen, posix_getpwuid, posix_kill, posix_mkfifo, posix_setpgid, posix_setsid, posix_setuid, posix_setuid, posix_uname, proc_close, proc_get_status, proc_nice, proc_open, proc_terminate, shell_exec, syslog, system, xmlrpc_entity_decode”




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


vi setup.sh; chmod +x setup.sh; ./setup.sh

#test settings with:
hostname
iptables -L
dpkg -l

#myhost specific:

hostnamectl set-hostname www

printf "127.0.0.1\t\t\tlocalhost.localdomain localhost\n" > /etc/hosts
printf "127.0.1.1\t\t\tdebian\n" >> /etc/hosts
printf "45.33.112.226\t\t\twww.rustbeltrebellion.com www\n" >> /etc/hosts
printf "\n" >> /etc/hosts
printf "# The following lines are desirable for IPv6 capable hosts\n" >> /etc/hosts
printf "::1\t\t\t\tlocalhost ip6-localhost ip6-loopback\n" >> /etc/hosts
printf "ff02::1\t\t\t\tip6-allnodes\n" >> /etc/hosts
printf "ff02::2\t\t\t\tip6-allrouters\n" >> /etc/hosts
printf "2600:3c00::f03c:91ff:fe26:42cf\twww.rustbeltrebellion.com www" >> /etc/hosts