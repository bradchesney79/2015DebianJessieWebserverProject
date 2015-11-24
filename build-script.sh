#!/bin/bash

##### THE USER INFO, SCRIPT LOCATION, & DATE #####

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

##### SYSTEM USER RESPONSIBLE FOR DEFAULT DOMAIN #####

USER="default-web"
PASSWORD="dummypassword"
EMAIL="$USER@$DOMAIN"

##### TOP LEVEL HUMAN USER #####

USERID1001='brad'
USERID1001EMAIL='bradchesney79@gmail.com'

# There is an interesting dynamic that I just want to send myself mail.
# No fuss, no muss-- that means in many cases no DNS, SPF, DKIM, and/or DMARC.
# "Disposable Email Service", email launderers for hire essentially.
# (Free providers exist...)
# What equates to 'sketchy' emails from your unverified host to the service.
# From the service, a fully qualified & clean email out to your target inbox.
# 33mail.com is the service I use. Shameless plug for them in my example...
TARGETEMAIL="dummyemail@bradchesney79.33mail.com"

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

##### DATABASE INFO #####

DBROOTUSER="datalord"
DBPASSWORD="seconddummypassword"

DEFAULTSITEDBUSER="administrator"
DEFAULTSITEDBPASSWORD="dummypassword"

DBBACKUPUSERPASSWORD="thirddummypassword"

#####  #####

######################################################################
######################################################################

#####NOTES & SNIPPETS#####

######################################################################
######################################################################

#####TO DO

# copy & tar keys for facilitating backups

# a script to add a new virtualhost & new 'website' system users

# a script to add human user acccounts (new VHOST fires this if 'person' user doesn't exist by default)

# a note displays to ensure users are added to groups appropriately

# make security improvement changes to apache
# (like hiding version & whatnot, much guided by securityheaders.com)

# install global webdev resources like composer, node, fonts

# improve troubleshooting resources

# remedy broken GUI SFTP -- works fine CLI

# update troubleshooting resources on github

# improve readability

# break into modular Ansible scripts

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

#pushd /root; mkdir bin; pushd bin; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/build-script.sh; chmod +x build-script.sh; time ./build-script.sh 2>&1 | tee /var/log/auto-install.log; popd; popd

#Takes ... on a Linode 1024
#real    7m55.128s
#real    9m49.525s
#real    4m27.518s


printf "\n##################################################"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n# SETUP SCRIPT START                             #"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n##################################################\n\n"

printf "\n########## SCRIPT EXECUTION PARTICULARS ##########\n\n"

printf "\nSCRIPTLOCATION - $SCRIPTLOCATION"
printf "\nEXECUTIONLOG - $EXECUTIONLOG"
printf "\nTROUBLESHOOTINGFILES - $TROUBLESHOOTINGFILES"
printf "\n$DATE - $UNIXTIMESTAMP\n\n"


printf "\n########## RECORD THE VARIABLES FOR POSTERITY ####\n\n"

printf "\nHOSTNAME - $HOSTNAME\n"
printf "\nDOMAIN - $DOMAIN\n"
printf "\nIPV4 - $IPV4\n"
printf "\nIPV6 - $IPV6\n"
printf "\nTIMEZONE - $TIMEZONE\n\n"

##### PERSON RESPONSIBLE FOR DEFAULT DOMAIN #####

printf "\nUSER - $USER\n\n"
printf "\nPASSWORD - $PASSWORD\n"
printf "\nEMAIL - $EMAIL=\n\n"

printf "\nTARGETEMAIL - $TARGETEMAIL\n\n"

printf "\nWEBROOT - $WEBROOT\n"
printf "\nLOGDIR - $LOGDIR\n\n"


##### SSL KEY PARTICULARS #####

printf "\nKEYSIZE - $KEYSIZE\n"
printf "\nALGORITHM - $ALGORITHM\n\n"

printf "\nCOUNTRY - $COUNTRY\n"
printf "\nSTATE - $STATE\n"
printf "\nLOCALITY - $LOCALITY\n"
printf "\nORGANIZATION - $ORGANIZATION\n"
printf "\nORGANIZATIONALUNIT - $ORGANIZATIONALUNIT\n"
printf "\nEMAIL - $EMAIL\n\n"

printf "\nPASSWORD - $PASSWORD\n\n"

printf "\nSSLPROVIDER - $SSLPROVIDER\n\n"

##### DATABASE INFO #####

printf "\nDBROOTUSER - $DBROOTUSER\n"
printf "\nDBPASSWORD - $DBPASSWORD\n\n"

printf "\nDEFAULTSITEDBUSER - $DEFAULTSITEDBUSER\n"
printf "\nDEFAULTSITEDBPASSWORD - $DEFAULTSITEDBPASSWORD\n\n"

printf "\nDBBACKUPPASSWORD - $DBBACKUPUSERPASSWORD\n\n"

printf "\n########## CONFIGURE THE HOSTNAME ###\n"


printf "\nSet the hostname\n\n"

hostnamectl set-hostname $HOSTNAME

printf "\n########## UPDATE THE HOSTS FILE ###\n"

printf "\nFully populate hosts file\n\n"

printf "127.0.0.1\t\t\tlocalhost.localdomain localhost\n" > /etc/hosts
printf "127.0.1.1\t\t\tdebian\n" >> /etc/hosts
printf "$IPV4\t\t\t\t$HOSTNAME.$DOMAIN $HOSTNAME\n" >> /etc/hosts
printf "\n# The following lines are desirable for IPv6 capable hosts\n" >> /etc/hosts
printf "::1\t\t\t\tlocalhost ip6-localhost ip6-loopback\n" >> /etc/hosts
printf "ff02::1\t\t\t\tip6-allnodes\n" >> /etc/hosts
printf "ff02::2\t\t\t\tip6-allrouters\n" >> /etc/hosts
printf "$IPV6\t$HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts

printf "\n########## SET THE TIMEZONE & TIME ###\n\n"

printf "Set the timezone to UTC \n\n\n"

echo $TIMEZONE > /etc/timezone                     
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime # This sets the time

printf "\n########## UPDATE APT SOURCES ###\n"


printf "\nUpdate apt sources\n\n"

echo "deb http://ftp.us.debian.org/debian jessie main contrib non-free" > /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list
printf "\n" >> /etc/apt/sources.list
echo "deb http://http.debian.net/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list

printf "\n########## UPDATE THE SYSTEM ###\n"


printf "\nUpdate the system\n\n"
printf "Update the system\n\n"

apt-get -y update


printf "\nUpgrade the system\n\n"
printf "Upgrade the system\n\n"

apt-get -y dist-upgrade
apt-get -y upgrade

printf "\n########## INSTALL THE FIRST BATCHES OF PACKAGES ###\n"


printf "\nInstall the first batch of packages for Apache & PHP\n\n"

apt-get -y install sudo tcl perl python3 apache2 tmux ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban git debconf-utils imagemagick expect

printf "\n########## CLEAN UP ###\n"

printf "\nFirst autoremove of packages\n\n"

apt-get -y autoremove

printf "\n########## UPDATE THE IPTABLES RULES ###\n"

echo "Creating the iptables directory in /etc"
mkdir /etc/iptables

printf "\n/etc/iptables exists!!\n\n"

ls /etc/iptables

printf "\n/PROOF!\n\n"

touch /etc/iptables/rules.v4
touch /etc/iptables/rules.v6

printf "\nBegin updating the IP tables rules\n\n"

printf "\nEXPECT - $EXPECT\n\n"

${EXPECT} <<EOD
set timeout 120
log_file -a /tmp/iptables-persistent.log
spawn apt-get -y install iptables-persistent
expect {
  timeout { send_user "\nFailed to find IPV4 prompt.\n"; exit 1 }
  eof { send_user "\nIPV4 failure for iptables-persistent setup\n"; exit 1 }
  "*Save current IPv4 rules"}
send "\r"
expect {
  timeout { send_user "\nFailed to find IPV6 prompt.\n"; exit 1 }
  eof { send_user "\nIPV6 failure for iptables-persistent setup\n"; exit 1 }
  "*Save current IPv6 rules"}
send "\r"
expect {
  timeout { send_user "\nFailsafe failed, timeout.\n"; exit 1 }
  eof { send_user "\nFailsafe failed.\n"; exit 1 }
  "*"}
send "\r"
EOD

cat /tmp/iptables-persistent.log

#FIXME rm /tmp/iptables-persistent.log

printf "\nUpdate the IP tables rules\n\n"

echo "*filter
#
# Loaded by /root/bin/iptables.sh via crontab at reboot
#
#  Allow all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT -d 127.0.0.0/8 -j REJECT
#  Accept all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#  Allow all outbound traffic - you can modify this to only allow certain traffic
-A OUTPUT -j ACCEPT
#  Allow HTTP and HTTPS connections from anywhere (the normal ports for websites and SSL).
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
#  Allow SSH connections
#
#  The -dport number should be the same port number you set in sshd_config
#
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
#  Allow ping
-A INPUT -p icmp --icmp-type echo-request -j ACCEPT
#  Log iptables denied calls
#-A INPUT -m limit --limit 5/min -j LOG --log-prefix \"iptables denied: \" --log-level 7
#  Drop all other inbound - default deny unless explicitly allowed policy
-A INPUT -j DROP
-A FORWARD -j DROP
COMMIT" > /root/bin/iptables.load

cat /root/bin/iptables.load > /etc/iptables/rules.v4

printf "\n########## APPLY THE IPTABLES RULES ###\n"

printf "\nApply the IP tables rules\n\n"

iptables-restore < /etc/iptables/rules.v4

printf "\nMake the IP tables rules persistent\n\n"

echo "#!/bin/bash

cat /root/bin/iptables.load > /etc/iptables/rules.autosave_v4

iptables-restore < /etc/iptables/rules.v4" > /root/bin/iptables.sh

chmod 700 /root/bin/iptables.sh

echo "@reboot root /root/bin/iptables.sh" >> /etc/crontab 


#echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
#echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

#iptables-save > /etc/iptables/rules.v4
#ip6tables-save > /etc/iptables/rules.v6

printf "\n########## USING fail2ban DEFAULT CONFIG ###\n"

# See /etc/fail2ban/jail.conf for additional options


printf "\n########## CONFIGURE APACHE ###\n"

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
chmod -R 744 $WEBROOT

chown -R www-data:www-data $WEBROOT/sockets
find $WEBROOT -type d -exec chmod -R 755 {} \;

printf "\n########## INSTALL MYSQL ###\n"

echo "mysql-server mysql-server/root_password select $DBPASSWORD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again select $DBPASSWORD" | debconf-set-selections

apt-get -y install mysql-server

#mysql_secure_installation #bug report, currently requires an expect script

SQL0="DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;"

#A common vector is to attack the MySQL root user since it is the default omipotent user put on almost all #MySQL installs.
#So, give your 'root' user a different name. (Is admin more secure than root, meh. Yeah, I guess.)

SQL1="GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'localhost' IDENTIFIED BY '$DBPASSWORD' WITH GRANT OPTION;"
SQL2="GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'127.0.0.1' IDENTIFIED BY '$DBPASSWORD' WITH GRANT OPTION;"
SQL3="GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'::1' IDENTIFIED BY '$DBPASSWORD' WITH GRANT OPTION;"

SQL4="DELETE FROM mysql.user WHERE User='root';"

SQL5="CREATE USER 'backup'@'localhost' IDENTIFIED BY '$DBBACKUPUSERPASSWORD';"
SQL6="GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';"

SQL7="FLUSH PRIVILEGES;"

mysql -u "root" -p"$DBPASSWORD" -e "$SQL0"
mysql -u "root" -p"$DBPASSWORD" -e "$SQL1"
mysql -u "root" -p"$DBPASSWORD" -e "$SQL2"
mysql -u "root" -p"$DBPASSWORD" -e "$SQL3"
mysql -u "root" -p"$DBPASSWORD" -e "$SQL4"
mysql -u "root" -p"$DBPASSWORD" -e "$SQL5"
mysql -u "root" -p"$DBPASSWORD" -e "$SQL6"
mysql -u "root" -p"$DBPASSWORD" -e "$SQL7"

printf "\n########## CONFIGURE PHP ###\n"

apt-get -y install php5-fpm libapache2-mod-php5 php-pear php5-curl php5-mysql php5-gd php5-gmp php5-mcrypt php5-memcached php5-imagick php5-intl php5-xdebug

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.original

printf "\n########## MODIFY DEFAULT VHOST CONFIGURATION FILES ###\n"

mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.original


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

cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.original


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

printf "\n########## ADD STARTSSSL CLASS2 CERTIFICATE FILES ###\n"

wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.sha2.ca.pem https://www.startssl.com/certs/class2/sha2/pem/sub.class2.server.sha2.ca.pem
wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem https://www.startssl.com/certs/ca.pem

printf "\n########## GENERATE SSL FOR DEFAULT SITE ###\n"

printf "\nConfigure Apache\n\n"

printf "Generating SSL\n\n"

printf "openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj \"/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN\"\n\n"

openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN"

#####!!!!! So, skipping swapping out mpm_prefork and disabling the ssl host allows the webserver to start
#####!!!!! Using mpm_worker causes an invalid config based upon mpm_worker being threaded and php5-fpm not being threadsafe
#####!!!!! First no SSL-Cert that matches the SSL Virtual Host Configuration

printf "\n########## DISABLE THE ACTIONS APACHE MODULE ###\n"
a2dismod -f actions

printf "\n########## ENABLE THE PROXY FCGI APACHE MODULE ###\n"
a2enmod proxy_fcgi ssl

printf "\n########## REMOVE EXISTING ENABLED SITES ###\n"
rm /etc/apache2/sites-enabled/*

printf "\n########## ENABLE THE DEFAULT SITES ###\n"
a2ensite default.conf
#a2ensite default-ssl.conf

printf "\n########## SETUP THE DEFAULT SITE FASTCGI ###\n"

printf "\n########## CONFIG PHP-FPM ###\n"

mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.original
cp /etc/php5/fpm/pool.d/www.conf.original /etc/php5/fpm/pool.d/${DOMAIN}.conf
cp /etc/php5/fpm/pool.d/www.conf.original /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

printf "\n########## DEFAULT HTTP POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN\]/" /etc/php5/fpm/pool.d/${DOMAIN}.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN.sock|" /etc/php5/fpm/pool.d/${DOMAIN}.conf

sed -i "s/user = www-data/user = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf
sed -i "s/group = www-data/group = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}.conf

printf "\n########## DEFAULT HTTPS POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN-SSL\]/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN-SSL.sock|" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/user = www-data/user = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s/group = www-data/group = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

printf "\n########## CONFIGURE PHP ###\n"

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.original


sed -i "s/;*short_open_tag.*/short_open_tag = Off/" /etc/php5/fpm/php.ini

sed -i "s/;*post_max_size.*/post_max_size = 12M/" /etc/php5/fpm/php.ini


sed -i "s/;*upload_max_filesize.*/upload_max_filesize = 12M/" /etc/php5/fpm/php.ini


sed -i "s/;*session.cookie_secure.*/session.cookie_secure = 1/" /etc/php5/fpm/php.ini


sed -i "s/;*session.cookie_httponly.*/session.cookie_httponly = 1/" /etc/php5/fpm/php.ini


sed -i "s/;*disable_functions.*/disable_functions = apache_child_terminate, apache_setenv, define_syslog_variables, escapeshellarg, escapeshellcmd, eval, exec, fp, fput, ftp_connect, ftp_exec, ftp_get, ftp_login, ftp_nb_fput, ftp_put, ftp_raw, ftp_rawlist, highlight_file, ini_alter, ini_get_all, ini_restore, inject_code, mysql_pconnect, openlog, passthru, pcntl_alarm, pcntl_exec, pcntl_fork, pcntl_get_last_error, pcntl_getpriority, pcntl_setpriority, pcntl_signal, pcntl_signal_dispatch, pcntl_sigprocmask, pcntl_sigtimedwait, pcntl_sigwaitinfo, pcntl_strerror, pcntl_wait, pcntl_waitpid, pcntl_wexitstatus, pcntl_wifexited, pcntl_wifsignaled, pcntl_wifstopped, pcntl_wstopsig, pcntl_wtermsig, phpAds_XmlRpc, phpAds_remoteInfo, phpAds_xmlrpcDecode, phpAds_xmlrpcEncode, php_uname, popen, posix_getpwuid, posix_kill, posix_mkfifo, posix_setpgid, posix_setsid, posix_setuid, posix_uname, proc_close, proc_get_status, proc_nice, proc_open, proc_terminate, shell_exec, syslog, system, xmlrpc_entity_decode/" /etc/php5/fpm/php.ini

printf "\n########## INSTALL WEBDEVELOPER RESOURCES ###\n"


printf "\n########## RESTART THE WEBSERVER SERVICES ###\n"

service apache2 restart
service php5-fpm restart

echo "<?php phpinfo(); ?>" >> /var/www/http/index.php

printf "\n########## SETUP MAIL ###\n"

#### May need an SPF record
# from http://spfwizard.com

echo "SPF Record:"
echo "$DOMAIN.  IN TXT \"v=spf1 mx a ip4:$IPV4/32 ?all\""

# in my DNS config the first text field was: rustbeltrebellion.com.
# in the dropdown: TXT
# in the last text field went: "v=spf1 mx a ip4:45.33.112.226/32 ?all"

#### Needed DMARC record
# https://www.unlocktheinbox.com/dmarcwizard/

echo "_dmarc.$DOMAIN. IN TXT \"v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:$USERID1001EMAIL; ruf=mailto:$USERID1001EMAIL; rf=afrf; pct=100; ri=604800\""

# in my DNS config the first text field was: _dmarc.rustbeltrebellion.com.
# in the dropdown: TXT
# in the last text field went: "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:bradchesney79@gmail.com; ruf=mailto:bradchesney79@gmail.com; rf=afrf; pct=100; ri=604800"

#### What is DKIM?

apt-get -y install exim4 exim4-daemon-light bsd-mailx opendkim opendkim-tools mailutils

mkdir -p /var/www/certs/dkim
pushd /var/www/certs/dkim
openssl genrsa -out dkim.default.key 1024
openssl rsa -in dkim.default.key -out dkim.default.pub -pubout -outform PEM
popd

DKIMPUBLICKEY=${cat /var/www/certs/dkim/dkim.default.pub | sed -e s/"-.*"// | tr -d '\n'}

echo "default._domainkey.$DOMAIN IN TXT \"v=DKIM1;p=$DKIMPUBLICKEY\""

# in my DNS config the first text field was: default._domainkey..rustbeltrebellion.com.
# in the dropdown: TXT
# in the last text field went: "v=DKIM1;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC3xvSbgwX5WMMfIui3w2Lcwjj1RBVy/AjTCptQT4BGMRiLQcS5vhP4XnlzifX/G4Tp3oD+eh75zMLyw3mHjaT0dX1Yg79U/GAMndtkpoZaGMQwDKzKI0c0rt1AdmXHBEJ+BpPrG3IGGUN1H2eybyp4cZJ11ST51knk2mbSKooIPwIDAQAB"

echo "verify with this command:"
echo "host -t txt default._domainkey.$DOMAIN default._domainkey.$DOMAIN descriptive text \"v=DKIM1\\;p=$DKIMPUBLICKEY"


# If not updating DNS for SPF but not DMARC or DKIM: still need to tell Google not to spam messages from:(*@$DOMAIN) via 'filters'
# Or use 3rd party disposable email forwarding


printf "\n########## SET UPDATE-EXIM4.CONF MAIL CONFIGS ###\n"

echo "# /etc/exim4/update-exim4.conf.conf" > /etc/exim4/update-exim4.conf.conf
echo "#" >> /etc/exim4/update-exim4.conf.conf
echo "# Edit this file and /etc/mailname by hand and execute update-exim4.conf" >> /etc/exim4/update-exim4.conf.conf
echo "# yourself or use 'dpkg-reconfigure exim4-config'" >> /etc/exim4/update-exim4.conf.conf
echo "#" >> /etc/exim4/update-exim4.conf.conf
echo "# Please note that this is _not_ a dpkg-conffile and that automatic changes" >> /etc/exim4/update-exim4.conf.conf
echo "# to this file might happen. The code handling this will honor your local" >> /etc/exim4/update-exim4.conf.conf
echo "# changes, so this is usually fine, but will break local schemes that mess" >> /etc/exim4/update-exim4.conf.conf
echo "# around with multiple versions of the file." >> /etc/exim4/update-exim4.conf.conf
echo "#" >> /etc/exim4/update-exim4.conf.conf
echo "# update-exim4.conf uses this file to determine variable values to generate" >> /etc/exim4/update-exim4.conf.conf
echo "# exim configuration macros for the configuration file." >> /etc/exim4/update-exim4.conf.conf
echo "#" >> /etc/exim4/update-exim4.conf.conf
echo "# Most settings found in here do have corresponding questions in the" >> /etc/exim4/update-exim4.conf.conf
echo "# Debconf configuration, but not all of them." >> /etc/exim4/update-exim4.conf.conf
echo "#" >> /etc/exim4/update-exim4.conf.conf
echo "# This is a Debian specific file" >> /etc/exim4/update-exim4.conf.conf
printf "\n" >> /etc/exim4/update-exim4.conf.conf
echo "dc_eximconfig_configtype='internet'" >> /etc/exim4/update-exim4.conf.conf
echo "dc_other_hostnames='localhost'" >> /etc/exim4/update-exim4.conf.conf
echo "dc_local_interfaces='127.0.0.1; ::1'" >> /etc/exim4/update-exim4.conf.conf
echo "dc_readhost=''" >> /etc/exim4/update-exim4.conf.conf
echo "dc_relay_domains=''" >> /etc/exim4/update-exim4.conf.conf
echo "dc_minimaldns='false'" >> /etc/exim4/update-exim4.conf.conf
echo "dc_relay_nets=''" >> /etc/exim4/update-exim4.conf.conf
echo "dc_smarthost=''" >> /etc/exim4/update-exim4.conf.conf
echo "CFILEMODE='644'" >> /etc/exim4/update-exim4.conf.conf
echo "dc_use_split_config='false'" >> /etc/exim4/update-exim4.conf.conf
echo "dc_hide_mailname=''" >> /etc/exim4/update-exim4.conf.conf
echo "dc_mailname_in_oh='true'" >> /etc/exim4/update-exim4.conf.conf
echo "dc_localdelivery='maildir_home'" >> /etc/exim4/update-exim4.conf.conf

echo "DKIM_CANON = strict" >> /etc/exim4/conf.d/main/00_localmacros
echo "DKIM_SELECTOR = default" >> /etc/exim4/conf.d/main/00_localmacros
echo "DKIM_PRIVATE_KEY = /var/www/certs/dkim/dkim.default.key" >> /etc/exim4/conf.d/main/00_localmacros
echo "DKIM_DOMAIN = ${lc:${domain:$h_from:}}" >> /etc/exim4/conf.d/main/00_localmacros

printf "\n########## SET EXIM4 MAILNAME ###\n"

echo "$DOMAIN" > /etc/mailname

printf "\n########## REDIRECT SERVER MAIL TO A REAL WORLD ADDRESS ###\n"

sed -i "s/root:.*/root: $TARGETEMAIL/" /etc/aliases
#echo "root: $TARGETEMAIL" >> /etc/aliases
echo "$USER: $TARGETEMAIL" >> /etc/aliases

printf "\n########## APPLY CONFIGURATION CHANGES ###\n"

update-exim4.conf
newaliases

printf "\n########## RESTART THE EXIM4 SERVICE ###\n"

service exim4 restart

printf "\n########## SEND TEST MAIL ###\n"

echo "Email from $(hostname)" | mail "$TARGETEMAIL" -s "$DATE $UNIXTIMESTAMP Email from $(hostname)"

echo "No DNS configuration mail testing:"
echo "The trick is that you have to use 'disposable email' services that exist because in some cases it is not always the wisest decision to only do business with the best of the best. These services allow otherwise questionable mail to come in, melded into mail stamped as legit from a sender with sufficient SPF, DMARC, & DKIM-- and is sent along to your real mail box --or at least that is how it works with 33mail.com"
echo "Welcome to the seedy world of email laundering."


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

printf "\n##################################################"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n# INITIAL TROUBLESHOOTING SCRIPT START           #"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n##################################################\n\n"

printf "\n########## CREATE A PLACE TO STORE THE OUTPUT FOR SHARING TROUBLESHOOTING DATA###\n"

printf "Location of troubleshooting files: $TROUBLESHOOTINGFILES\n\n"
mkdir -pv ${TROUBLESHOOTINGFILES}

printf "Start collecting config files\n\n"

cp /etc/hosts ${TROUBLESHOOTINGFILES}/etc-hosts

cp /etc/apt/sources.list ${TROUBLESHOOTINGFILES}/etc-apt-sources.list

cp /etc/iptables/rules.v4 ${TROUBLESHOOTINGFILES}/etc-iptables-rules.v4

cp /etc/apache2/sites-available/default.conf ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available-default.conf

cp /etc/apache2/includes/vhost-ssl ${TROUBLESHOOTINGFILES}/etc-apache2-includes-vhost-ssl

cp /etc/apache2/sites-available/default-ssl.conf ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available-default-ssl.conf

cp /etc/mysql/my.cnf ${TROUBLESHOOTINGFILES}/etc-mysql-my.cnf

cp /etc/php5/fpm/php.ini ${TROUBLESHOOTINGFILES}/etc-php5-fpm-php.ini

cp /etc/php5/fpm/pool.d/${DOMAIN}.conf ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d-${DOMAIN}.conf

cp /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d-${DOMAIN}-ssl.conf

cp /etc/exim4/update-exim4.conf.conf ${TROUBLESHOOTINGFILES}/etc-exim4-update-exim4.conf.conf

cp /etc/exim4/conf.d/main/00_localmacros ${TROUBLESHOOTINGFILES}/etc-exim4-conf.d-main-00_localmacros

cp /etc/aliases ${TROUBLESHOOTINGFILES}/etc-aliases


printf "Start collecting log files\n\n"

printf "Apache log files\n"
tail ${LOGDIR}/error.log >> ${TROUBLESHOOTINGFILES}/apache-error.log
tail ${LOGDIR}/access.log >> ${TROUBLESHOOTINGFILES}/apache-access.log

printf "FPM log files\n"
tail /var/log/php5-fpm.log >> ${TROUBLESHOOTINGFILES}/php5-fpm.log

printf "Whole shebang log files\n\n"
cp ${EXECUTIONLOG} ${TROUBLESHOOTINGFILES}/execution.log

printf "Create troubleshooting report for pastebin\n\n"


#USEFUL FOR CUT/PASTE
#printf "##########  ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
#cat  >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## TROUBLESHOOTING REPORT $DATE $UNIXTIMESTAMP ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n########## HOSTNAME ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
hostname >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n########## PROCESSORS AVAILABLE (COUNT) ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
grep processor /proc/cpuinfo | wc -l >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n########## UPTIME, USERS (COUNT), AND LOAD AVG (LOAD MAX = 100% * PROCESSORS AVAILABLE FOR PREVIOUS 1, 5, & 15 MINUTES) ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
uptime >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## IP TABLE RULES LOADED ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
iptables -L >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## PACKAGES INSTALLED ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
dpkg -l >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## APACHECTL INFO ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
apachectl configtest
printf "\n\n"
apachectl fullstatus

printf "\n\n########## PHP MODULE LOADED ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
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

printf "########## MYSQL.CNF ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-mysql-my.cnf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## PHP.INI ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-php5-fpm-php.ini >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## FPM/POOL.D/$DOMAIN.CONF ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d-${DOMAIN}.conf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## FPM/POOL.D/$DOMAIN-SSL.CONF ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d-${DOMAIN}-ssl.conf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

#printf "\n\n\n########## APACHE ACCESS.LOG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
#cat ${TROUBLESHOOTINGFILES}/apache-access.log >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

#printf "\n\n\n########## APACHE ERROR.LOG ###########\n\n" >> #${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
#cat ${TROUBLESHOOTINGFILES}/apache-error.log >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## PHP-FPM LOG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/php5-fpm.log >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## MAIN EXIM CONFIG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-exim4-update-exim4.conf.conf >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## EXIM CONF.D CONFIG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-exim4-conf.d-main-00_localmacros >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## ETC/ALIASES ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-aliases >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n\n########## UNABRIDGED SETUP LOG ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${EXECUTIONLOG} >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n##################################################"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n# INITIAL TROUBLESHOOTING SCRIPT END             #"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n##################################################\n\n"

pushd ${TROUBLESHOOTINGFILES}
tar -czvf troubleshooting.tgz ${TROUBLESHOOTINGFILES}/*  
#mv /root/bin/troubleshooting/troubleshooting.tgz /root/bin/troubleshooting/${UNIXTIMESTAMP}/
cp ${TROUBLESHOOTINGFILES}/troubleshooting.tgz $WEBROOT/http

printf "\nThinking inside my head that a few minutes of uptime is trivial at this point-- nobody is actually depending on the system being up or even using it at this exact moment-- a reboot might be a smart idea.\n"

printf "\nDon't forget to set up Reverse DNS while you wait -- gets rid of those pesky problem with the server being referred to by the linode assigned machine name in most places."

exit 0
