#!/bin/bash

##### THE DATE #####

DATE=`date +%Y-%m-%d`
YEAR=`date +%Y`

##### HOST INFO #####

HOSTNAME="www"
DOMAIN="rustbeltrebellion.com"
IPV4="45.33.112.226"
IPV6="2600:3c00::f03c:91ff:fe26:42cf"

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

##### RECORD THE DATE IN THE LOG #####

printf "\n$DATE\n\n" >> /var/log/auto-install.log


##### RECORD THE VARIABLES FOR POSTERITY #####

printf "\nHOSTNAME - $HOSTNAME\n" >> /var/log/auto-install.log
printf "\nDOMAIN - $DOMAIN\n" >> /var/log/auto-install.log
printf "\nIPV4 - $IPV4\n" >> /var/log/auto-install.log
printf "\nIPV6 - $IPV6\n\n" >> /var/log/auto-install.log

printf "\nUSER - $USER\n\n" >> /var/log/auto-install.log

printf "\nCOUNTRY - $COUNTRY\n" >> /var/log/auto-install.log
printf "\nSTATE - $STATE\n" >> /var/log/auto-install.log
printf "\nLOCALITY - $LOCALITY\n" >> /var/log/auto-install.log
printf "\nORGANIZATION - $ORGANIZATION\n" >> /var/log/auto-install.log
printf "\nORGANIZATIONALUNIT - $ORGANIZATIONALUNIT\n" >> /var/log/auto-install.log
printf "\nEMAIL - $EMAIL\n\n" >> /var/log/auto-install.log

printf "\nPASSWORD - $PASSWORD\n\n" >> /var/log/auto-install.log

printf "\nSSLPROVIDER - $SSLPROVIDER\n\n" >> /var/log/auto-install.log

##### CONFIGURE THE HOSTNAME #####

printf "\n" >> /var/log/auto-install.log
printf "Set the hostname\n\n" >> /var/log/auto-install.log

hostnamectl set-hostname $HOSTNAME

##### UPDATE THE HOSTS FILE #####

printf "\n" >> /var/log/auto-install.log
printf "Fully populate hosts file\n\n" >> /var/log/auto-install.log

printf "127.0.0.1\t\t\tlocalhost.localdomain localhost\n" > /etc/hosts
printf "127.0.1.1\t\t\tdebian\n" >> /etc/hosts
printf "$IPV4\t\t$HOSTNAME.$DOMAIN $HOSTNAME\n" >> /etc/hosts
printf "\n" >> /etc/hosts
printf "# The following lines are desirable for IPv6 capable hosts\n" >> /etc/hosts
printf "::1\t\t\t\tlocalhost ip6-localhost ip6-loopback\n" >> /etc/hosts
printf "ff02::1\t\t\t\tip6-allnodes\n" >> /etc/hosts
printf "ff02::2\t\t\t\tip6-allrouters\n" >> /etc/hosts
printf "$IPV6\t$HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts

##### SET THE TIMEZONE & TIME #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Set the timezone to UTC \n\n" >> /var/log/apt/auto-install.log

TIMEZONE="Etc/UTC" # This is a server, UTC is the only appropriate timezone
echo $TIMEZONE > /etc/timezone                     
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime # This sets the time

##### UPDATE APT SOURCES #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Update apt sources\n\n" >> /var/log/apt/auto-install.log

echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian/ jessie-updates main contrib non-free" >> /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://backports.debian.org/debian-backports squeeze-backports main" >> /etc/apt/sources.list

##### UPDATE THE SYSTEM #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Update the system\n\n" >> /var/log/apt/auto-install.log

apt-get -qy update > /dev/null

printf "\n" >> /var/log/apt/auto-install.log
printf "Upgrade the system\n\n" >> /var/log/apt/auto-install.log

apt-get -qy dist-upgrade >> /var/log/auto-install.log

##### INSTALL THE FIRST BATCHES OF PACKAGES #####

printf "\n" >> /var/log/auto-install.log
printf "Install the first batch of packages for Apache & PHP\n\n" >> /var/log/auto-install.log

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

apt-get -qy install sudo tcl perl python3 apache2 tmux iptables-persistent ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban libapache2-mod-fastcgi php5-fpm libapache2-mod-php5 php-pear php5-curl >> /var/log/auto-install.log

##### CLEAN UP #####

printf "\n" >> /var/log/auto-install.log
printf "First autoremove of packages\n\n" >> /var/log/auto-install.log

apt-get -qy autoremove >> /var/log/auto-install.log


##### UPDATE THE IPTABLES RULES #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Update the IP tables rules\n\n" >> /var/log/apt/auto-install.log

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

##### APPLY THE IPTABLES RULES #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Apply the IP tables rules\n\n" >> /var/log/apt/auto-install.log

iptables-restore < /etc/iptables/rules.v4

##### USING fail2ban DEFAULT CONFIG #####

# See /etc/fail2ban/jail.conf for additional options


##### CONFIGURE APACHE #####

##### CREATE A USER FOR THE DEFAULT SITE #####
##### THIS AIDS RESOURCE SEGREGATION #####
##### www-data HAS ACCESS TO ALL WEBSERVER FUN #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Create the Default Web Site user\n\n" >> /var/log/apt/auto-install.log

useradd -d $WEBROOT -p $PASSWORD -c "Default Web Site User" $USER

##### ADD SSL CONFIGURATION INCLUDE #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Write Apache SSL include file\n\n" >> /var/log/apt/auto-install.log

mkdir /etc/apache2/includes


printf "\n        #   SSL Engine Switch:\n" > /etc/apache2/includes/vhost-ssl
printf "        #   Enable/Disable SSL for this virtual host.\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLEngine on\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLProtocol all -SSLv2 -SSLv3\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLHonorCipherOrder On\n" >> /etc/apache2/includes/vhost-ssl
printf "        SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS\n" >> /etc/apache2/includes/vhost-ssl

chown root:www-data /etc/apache2/includes/vhost-ssl

##### CONFIGURE THE DEFAULT SITE #####

##### PREPARE DIRECTORY STRUCTURE FOR DEFAULT SITE #####

printf "\n" >> /var/log/apt/auto-install.log
printf "Create the Default Site directory structure\n\n" >> /var/log/apt/auto-install.log

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

chown -r $USER:$USER $WEBROOT

chmod -r 754 $WEBROOT
find $WEBROOT -type d -exec chmod 751 {} \;

chown -R www-data:www-data $WEBROOT/sockets
chmod -R 666 $WEBROOT/sockets

##### CONFIGURE PHP #####

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.original

#sed -i '.bak' 's/find/replace' file.txt


##### MODIFY DEFAULT VHOST CONFIGURATION FILES #####

mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.original



#<VirtualHost *:80>
#  ServerName $DOMAIN
#  ServerAlias $HOSTNAME.$DOMAIN
#
#  ServerAdmin $EMAIL
#  DocumentRoot $WEBROOT/html
#
#  ErrorLog ${APACHE_LOG_DIR}/error.log
#  CustomLog ${APACHE_LOG_DIR}/access.log combined
#  
#
#  ErrorLog $WEBROOT/logs/error.log
#  CustomLog $WEBROOT/logs/access.log combined
#
#  <IfModule mod_fastcgi.c>
#      AddType application/x-httpd-fastphp5 .php
#      Action application/x-httpd-fastphp5 /php5-fcgi
#      Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi_$DOMAIN
#      FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi_$DOMAIN -socket $WEBROOT/sockets/ $DOMAIN.sock -pass-header Authorization
#  </IfModule>
#</VirtualHost>

printf "<VirtualHost *:80>\n" > /etc/apache2/sites-available/default.conf
printf "  ServerName $DOMAIN\n" >> /etc/apache2/sites-available/default.conf
printf "  ServerAlias $HOSTNAME.$DOMAIN\n\n" >> /etc/apache2/sites-available/default.conf
printf "  ServerAdmin $EMAIL\n" >> /etc/apache2/sites-available/default.conf
printf "  DocumentRoot $WEBROOT/http\n\n" >> /etc/apache2/sites-available/default.conf
printf "  ErrorLog $LOGDIR/error.log\n" >> /etc/apache2/sites-available/default.conf
printf "  CustomLog $LOGDIR/access.log combined\n" >> /etc/apache2/sites-available/default.conf
printf "  <IfModule mod_fastcgi.c>\n" >> /etc/apache2/sites-available/default.conf
printf "      AddType application/x-httpd-fastphp5 .php\n" >> /etc/apache2/sites-available/default.conf
printf "      Action application/x-httpd-fastphp5 /php5-fcgi\n" >> /etc/apache2/sites-available/default.conf
printf "      Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi_$DOMAIN\n" >> /etc/apache2/sites-available/default.conf
printf "      FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi_$DOMAIN -socket $WEBROOT/sockets/$DOMAIN.sock -pass-header Authorization -user administrator -group administrator -idle-timeout 3600\n" >> /etc/apache2/sites-available/default.conf
printf "  </IfModule>\n" >> /etc/apache2/sites-available/default.conf
printf "</VirtualHost>\n" >> /etc/apache2/sites-available/default.conf


cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.original

#<IfModule mod_ssl.c>
#    <VirtualHost _default_:443>
#
#        ServerName $DOMAIN
#        ServerAlias *.$DOMAIN
#        DocumentRoot $WEBROOT/https
#        <Directory $WEBROOT/https/>
#            Options Indexes FollowSymLinks MultiViews
#            AllowOverride None
#            Order allow,deny
#            allow from all
#        </Directory>
#
#        <IfModule mod_fastcgi.c>
#            AddType application/x-httpd-fastphp5 .php
#            Action application/x-httpd-fastphp5 /php5-fcgi
#            Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi_$DOMAIN
#            FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi_$DOMAIN -socket /var/run/php5-fpm $DOMAIN.sock -pass-header Authorization
#        </IfModule>
#
#        LogLevel warn
#
#        ErrorLog $WEBROOT/logs/error-ssl.log
#        CustomLog $WEBROOT/logs/access-ssl.log combined
#
#        Include /etc/apache2/includes/vhost-ssl
#
#        #   The StartSSL Certificate
#
#        SSLCertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.crt
#        SSLCertificateKeyFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key
#        SSLCertificateChainFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.ca.pem
#        SSLCACertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem
#        
#        #   SSL Protocol Adjustments:
#        #   The safe and default but still SSL/TLS standard compliant shutdown
#        #   approach is that mod_ssl sends the close notify alert but doesn't wait for
#        #   the close notify alert from client. When you need a different shutdown
#        #   approach you can use one of the following variables:
#        #   o ssl-unclean-shutdown:
#        #     This forces an unclean shutdown when the connection is closed, i.e. no
#        #     SSL close notify alert is send or allowed to received.  This violates
#        #     the SSL/TLS standard but is needed for some brain-dead browsers. Use
#        #     this when you receive I/O errors because of the standard approach where
#        #     mod_ssl sends the close notify alert.
#        #   o ssl-accurate-shutdown:
#        #     This forces an accurate shutdown when the connection is closed, i.e. a
#        #     SSL close notify alert is send and mod_ssl waits for the close notify
#        #     alert of the client. This is 100% SSL/TLS standard compliant, but in
#        #     practice often causes hanging connections with brain-dead browsers. Use
#        #     this only for browsers where you know that their SSL implementation
#        #     works correctly.
#        #   Notice: Most problems of broken clients are also related to the HTTP
#        #   keep-alive facility, so you usually additionally want to disable
#        #   keep-alive for those clients, too. Use variable "nokeepalive" for this.
#        #   Similarly, one has to force some clients to use HTTP/1.0 to workaround
#        #   their broken HTTP/1.1 implementation. Use variables "downgrade-1.0" and
#        #   "force-response-1.0" for this.
#        BrowserMatch "MSIE [2-6]" \
#            nokeepalive ssl-unclean-shutdown \
#            downgrade-1.0 force-response-1.0
#            # MSIE 7 and newer should be able to use keepalive
#        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
#
#    </VirtualHost>
#</IfModule>

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
printf "        <IfModule mod_fastcgi.c>\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            AddType application/x-httpd-fastphp5 .php\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            Action application/x-httpd-fastphp5 /php5-fcgi\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi_$DOMAIN\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "            FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi_$DOMAIN -socket /var/run/php5-fpm $DOMAIN.sock -pass-header Authorization\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        </IfModule>\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        LogLevel warn\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        ErrorLog $WEBROOT/logs/error-ssl.log\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        CustomLog $WEBROOT/logs/access-ssl.log combined\n\n" >> /etc/apache2/sites-available/default-ssl.conf

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


##### ADD STARTSSSL CLASS2 CERTIFICATE FILES #####

wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.sha2.ca.pem https://www.startssl.com/certs/class2/sha2/pem/sub.class2.server.sha2.ca.pem
wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem https://www.startssl.com/certs/ca.pem

##### GENERATE SSL FOR DEFAULT SITE #####
printf "\n" >> /var/log/apt/auto-install.log
printf "Configure Apache\n\n" >> /var/log/apt/auto-install.log

printf "Generating SSL\n\n" >> /var/log/apt/auto-install.log

printf "openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj \"/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN\"\n\n" >> /var/log/apt/auto-install.log

openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN" >> /var/log/apt/auto-install.log

a2dismod mpm_prefork
a2enmod actions fastcgi alias ssl mpm_worker

a2ensite default.conf
a2ensite default-ssl.conf

printf "\n" >> /var/log/apt/auto-install.log
printf "Set Apache PHP Module\n" >> /var/log/apt/auto-install.log
apachectl -V | grep -i mpm >> /var/log/apt/auto-install.log
printf "PHP Module Thread Safety\n" >> /var/log/apt/auto-install.log
php -i | grep Thread >> /var/log/apt/auto-install.log



##### SETUP THE DEFAULT SITE FASTCGI #####

##### CONFIG PHP-FPM #####

mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.original

##### ADD FASTCGI CONFIG FILE #####

#printf "<IfModule mod_fastcgi.c>\n" > /etc/apache2/mods-available/fastcgi.conf
#printf "\tAddType application/x-httpd-fastphp5 .php\n" >> /etc/apache2/mods-available/fastcgi.conf
#printf "\tAction application/x-httpd-fastphp5 /php5-fcgi\n" >> /etc/apache2/mods-available/fastcgi.conf
#printf "\tAlias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi\n" >> /etc/apache2/mods-available/fastcgi.conf
#printf "\tFastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization \n" >> /etc/apache2/mods-available/fastcgi.conf
#printf "\t<Directory /usr/lib/cgi-bin>\n" >> /etc/apache2/mods-available/fastcgi.conf
#printf "\t\tRequire all granted\n" >> /etc/apache2/mods-available/fastcgi.conf
#printf "\t</Directory>\n" >> /etc/apache2/mods-available/fastcgi.conf
#printf "</IfModule>" >> /etc/apache2/mods-available/fastcgi.conf






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