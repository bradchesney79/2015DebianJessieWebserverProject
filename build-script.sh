#!/bin/bash

##### THE USER INFO, SCRIPT LOCATION, & DATE #####

SCRIPTLOCATION=`pwd`
UNIXTIMESTAMP=`date +%s`
DATE=`date +%Y-%m-%d`
YEAR=`date +%Y`
EXECUTIONLOG="/var/log/auto-install.log"

##### HOST INFO #####

HOSTNAME="www"
DOMAIN="rustbeltrebellion.com"
IPV4="45.33.112.226"
IPV6="2600:3c00::f03c:91ff:fe26:42cf"
TIMEZONE="Etc/UTC" # This is a server, UTC is the only appropriate timezone

DEV="YES" # The conditional below looks for "YES", everything else is no, essentially

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

# start-ssl-free start-ssl-class2 lets-encrypt 
SSLPROVIDER="start-ssl-class2"

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

# make security improvement changes to apache
# (like hiding version & whatnot, much guided by securityheaders.com)

# improve reporting report

# break reporting into its own script so it can be rerun at whim

# install global webdev resources like composer, node, fonts

# improve troubleshooting resources

# remedy broken GUI SFTP -- works fine CLI

# update troubleshooting resources on github

# improve readability

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

#http://serverfault.com/questions/570288/is-it-bad-to-redirect-http-to-https
#http://xdebug.org/docs/install
#https://www.jetbrains.com/phpstorm/help/configuring-xdebug.html
#http://xmodulo.com/block-network-traffic-by-country-linux.html

###For me to test the whole thing as-is
#pushd /root; mkdir bin; pushd bin; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/build-script.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/add-web-person-user.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/add-website.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/troubleshooting.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/backend-build-chain.sh; chmod +x *.sh; time ./build-script.sh 2>&1 | tee /var/log/auto-install.log; time ./add-web-person-user.sh bradchesney79 TRUE 2>&1 | tee /var/log/auto-install.log; time ./backend-build-chain.sh 2>&1 | tee /var/log/auto-install.log; popd; popd

#Takes ... on a Linode 1024
#real    7m55.128s
#real    9m49.525s
#real    4m27.518s
#real    3m56.291s
#real    4m4.988s

###For myself and others to acquire & modify 

#Acquire the scripts
#pushd /root; mkdir bin; pushd bin; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/build-script.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/add-web-person-user.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/add-website.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/troubleshooting.sh; wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/backend-buld-chain.sh; chmod +x *.sh

#Modify the scripts
#--You'll have to manage this on your own.

#Run the build script
#time ./build-script.sh 2>&1 | tee /var/log/auto-install.log; popd; popd


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

apt-get -y install php5-fpm libapache2-mod-php5 php-pear php5-curl php5-mysql php5-gd php5-gmp php5-mcrypt php5-memcached php5-imagick php5-intl 

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.original

printf "\n########## OPTIONALLY INSTALL XDEBUG ON DEVELOPMENT INSTANCE ###\n"

if [ "$DEV" = 'YES' ]
  then
  apt-get -y install php5-dev php5-xdebug make build-essential g++
fi

printf "\n########## MODIFY DEFAULT VHOST CONFIGURATION FILES ###\n"

mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.original


printf "<VirtualHost _default_:80>\n" > /etc/apache2/sites-available/default.conf
printf "  ServerName $DOMAIN\n" >> /etc/apache2/sites-available/default.conf
printf "  ServerAlias $HOSTNAME.$DOMAIN\n\n" >> /etc/apache2/sites-available/default.conf
printf "  ServerAdmin $EMAIL\n" >> /etc/apache2/sites-available/default.conf
printf "  DocumentRoot $WEBROOT/http\n\n" >> /etc/apache2/sites-available/default.conf
printf "  ErrorLog $LOGDIR/error.log\n" >> /etc/apache2/sites-available/default.conf
printf "  CustomLog $LOGDIR/access.log combined\n\n" >> /etc/apache2/sites-available/default.conf

printf "\n        #   Configure Apache to Advertise Trying SSL First\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header always set Strict-Transport-Security \"max-age=63072000; includeSubdomains; preload\"\n\n" >> /etc/apache2/sites-available/default.conf

printf "\n        #   Do Not Permit Embedding In an iframe Tag\n\n" >> /etc/apache2/sites-available/default.conf
printf "\n        #   See SAMEORIGIN or ALLOW-FROM Documentation for More Relaxed X-Frame Usage\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header always set X-Frame-Options DENY\n\n" >> /etc/apache2/sites-available/default.conf

printf "\n        #   Set Server Level XSS Prevention\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header set X-XSS-Protection: \"1; mode=block\"\n\n" >> /etc/apache2/sites-available/default.conf

printf "\n        #   Remove Poorly Performing etag Cache Invalidation Header\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header unset ETag\n\n" >> /etc/apache2/sites-available/default.conf

printf "\n        #   Prevent MIME sniffing a non-declared content type\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header set X-Content-Type-Options: nosniff\n\n" >> /etc/apache2/sites-available/default.conf

printf "\n        #   Allow Running Scripts from Self and Third-Party Resources from Google\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header set X-WebKit-CSP: \"default-src 'self';script-src 'self' www.google-analytics.com ajax.googleapis.com;\"\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header set X-Content-Security-Policy: \"default-src 'self';script-src 'self' www.google-analytics.com ajax.googleapis.com;\"\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header set Content-Security-Policy: \"default-src 'self';script-src 'self' www.google-analytics.com ajax.googleapis.com;\"\n\n" >> /etc/apache2/sites-available/default.conf

printf "\n        #   Used by Adobe PDF & Flash -- Don't Use Flash\n\n" >> /etc/apache2/sites-available/default.conf
printf "        Header set X-Permitted-Cross-Domain-Policies: "master-only"\n\n" >> /etc/apache2/sites-available/default.conf

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

if [ "$SSLPROVIDER" = "start-ssl-class2" ]
then
printf "        #   The StartSSL Certificate\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.crt\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCertificateKeyFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCertificateChainFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.ca.pem\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        SSLCACertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        \n" >> /etc/apache2/sites-available/default-ssl.conf
fi

printf "\nModify Headers Served for a More Secure Server\n\n"

printf "\n        #   Configure Apache to Advertise Trying SSL First\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header always set Strict-Transport-Security \"max-age=63072000; includeSubdomains; preload\"\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "\n        #   Do Not Permit Embedding In an iframe Tag\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "\n        #   See SAMEORIGIN or ALLOW-FROM Documentation for More Relaxed X-Frame Usage\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header always set X-Frame-Options DENY\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "\n        #   Set Server Level XSS Prevention\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header set X-XSS-Protection: \"1; mode=block\"\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "\n        #   Remove Poorly Performing etag Cache Invalidation Header\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header unset ETag\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "\n        #   Prevent MIME sniffing a non-declared content type\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header set X-Content-Type-Options: nosniff\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "\n        #   Allow Running Scripts from Self and Third-Party Resources from Google\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header set X-WebKit-CSP: \"default-src 'self';script-src 'self' www.google-analytics.com ajax.googleapis.com;\"\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header set X-Content-Security-Policy: \"default-src 'self';script-src 'self' www.google-analytics.com ajax.googleapis.com;\"\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "        Header set Content-Security-Policy: \"default-src 'self';script-src 'self' www.google-analytics.com ajax.googleapis.com;\"\n\n" >> /etc/apache2/sites-available/default-ssl.conf

printf "\n        #   Used by Adobe PDF & Flash -- Don't Use Flash\n\n" >> /etc/apache2/sites-available/default-ssl.conf
printf "#        Header set X-Permitted-Cross-Domain-Policies: "master-only"\n\n" >> /etc/apache2/sites-available/default-ssl.conf

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

printf "\n########## ENABLE THE PROXY FCGI, SSL, & HEADERS APACHE MODULES ###\n"
a2enmod proxy_fcgi ssl headers

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


# These settings allow you to load balance for horizontal scaling-- this is for sharing your PHP Session data.

sed -i "s/session.save_handler =.*/session.save_handler = memcached/" /etc/php5/fpm/php.ini

# To share PHP Session data you have to specify that the session data is stored to all memcached instances on all servers
# Once stored on all hosts, reading is just a matter of hitting the local memcached.
# Security Note: Only specifying listening on IP:port of private networks behind firewalls

sed -i "s/;session.save_path =.*/session.save_path = \"127.0.0.1:11211\"\nmemcached.sess_prefix = \"\"/" /etc/php5/fpm/php.ini

# Problems with session_destroy() are solved with this:
# memcached.sess_prefix = \"\"
# added after editing session.save_path above

sed -i "s/session.gc_maxlifetime =.*/session.gc_maxlifetime = 720/" /etc/php5/fpm/php.ini


# You may need to modify the memcached settings if more machines are pooled

# listen on a port of a firewalled/private network IP
# memcached -l 127.0.0.1:11211,10.1.2.3:11211
# or go straight for the config file to edit the service 
# vi /etc/memcached.conf

# service memcached restart

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

./troubleshooting.sh

printf "\n Add a person user. Best practices dictate using the root account less. ( ./add-web-person-user.sh $USERID1001 TRUE )\n"

printf "\nSSL Certs come from a third-party, be sure to get the applicable files and put them in the appropriate directory.\n"

printf "\nThinking inside my head that a few minutes of uptime is trivial at this point-- nobody is actually depending on the system being up or even using it at this exact moment-- a reboot might be a smart idea.\n"

printf "\nSet up Reverse DNS while you wait if applicable-- gets rid of those pesky problem with the server being referred to by the linode assigned machine name in most places."

exit 0