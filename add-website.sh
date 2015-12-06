#!/bin/bash

######################################################################
######################################################################

#####NOTES & SNIPPETS#####

######################################################################
######################################################################

#based upon:
# 
# http://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash


usage(){
	echo "Usage: $0"
	echo ""
	echo "Two mandatory arguments"
	echo "Up to eight arguments, space delimited"
	echo "The script is not 'smart', must specify all arguments up until the last one you need to specify"
	echo ""
	echo "DOMAIN (example.com)*"
	echo "NON-PERSON WEBSITE USER PASSWORD (passw0rd)*"
	echo ""
	echo "SSL CERT ORGANIZATION (Rust Belt Rebellion)✓"
	echo ""
	echo "SSL CERT ORGANIZATIONAL UNIT (Web Development)✓"
	echo ""
	echo "SSL Provider (start-ssl)✓"
	echo ""
	echo "SSL CERT LOCALITY (Eastlake)✓"
	echo "SSL CERT STATE (Ohio)✓"
	echo "SSL CERT COUNTRY (US)✓"
	echo ""
	echo "* denotes a required argument"
	echo "✓ denotes a default value as the example"
	exit 1
}
 
# invoke  usage
# call usage() function if parameters not supplied
[[ $# -eq 0 ]] && usage

if [ -z "$1" ]
then usage
fi

if [ "$1" == "-h" ]
then usage
fi

if [ "$1" == "--help" ]
then usage
fi

if [ -z "$2" ]
then usage
fi

#setup variables
DOMAIN="$1"

DOMAINUSER=`echo "$DOMAIN-web" | sed -e 's/\.//g'`
EMAIL="$DOMAINUSER@$DOMAIN"
PASSWORD="$2"

HOSTNAME="www"
WEBROOT="/home/$DOMAINUSER"
LOGDIR="$WEBROOT/logs"

##### SSL KEY PARTICULARS #####

KEYSIZE="2048"
ALGORITHM="-sha256"

##### DEFAULT DOMAIN INFO FOR SSL #####

ORGANIZATION=${3:-"Rust Belt Rebellion"}
ORGANIZATIONALUNIT=${4:-"Web Development"}
SSLPROVIDER=${5:-"start-ssl"}
LOCALITY=${6:-"Eastlake"}
STATE=${7:-"Ohio"}
COUNTRY=${8:-"US"}

SCRIPTLOCATION=`pwd`
UNIXTIMESTAMP=`date +%s`
DATE=`date +%Y-%m-%d`
YEAR=`date +%Y`

EXECUTIONLOG="/var/log/$DOMAIN-auto-install.log"


#add the user
printf "\n########## CREATE A NOT-A-PERSON USER ACCOUNT FOR THE SITE ###\n"
printf "\n########## THIS AIDS RESOURCE SEGREGATION ###\n"

mkdir "/home/$DOMAINUSER"

useradd -d $WEBROOT -p $PASSWORD -c "$DOMAIN FPM Web Site User" $DOMAINUSER

printf "\n########## LOCK THE NOT-A-PERSON USER ACCOUNT THE FPM WEBSITE RUNS AS ###\n"
passwd -l $DOMAINUSER

#setup virtualhost directory structure

printf "\nCreate the Site directory structure\n\n"

mkdir $WEBROOT/http
mkdir $WEBROOT/https
mkdir $WEBROOT/fonts
mkdir $WEBROOT/certs
mkdir $WEBROOT/certs/$YEAR
mkdir $WEBROOT/certs/$YEAR/$SSLPROVIDER
mkdir $LOGDIR
mkdir $WEBROOT/sockets
mkdir $WEBROOT/tmp

#fix file permissions

chown -R $DOMAINUSER:$DOMAINUSER $WEBROOT
chmod -R 774 $WEBROOT

chown -R www-data:www-data $WEBROOT/sockets
find $WEBROOT -type d -exec chmod -R 775 {} \;

#setup virtual hosts

printf "<VirtualHost *:80>\n" > /etc/apache2/sites-available/$DOMAIN.conf
printf "  ServerName $DOMAIN\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "  ServerAlias $HOSTNAME.$DOMAIN\n\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "  ServerAdmin $EMAIL\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "  DocumentRoot $WEBROOT/http\n\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "  ErrorLog $LOGDIR/error.log\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "  CustomLog $LOGDIR/access.log combined\n\n" >> /etc/apache2/sites-available/$DOMAIN.conf

printf "  <FilesMatch \"\.php$\">\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "    SetHandler \"proxy:unix://$WEBROOT/sockets/$DOMAIN.sock|fcgi://$DOMAIN\"\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "  </FilesMatch>\n\n" >> /etc/apache2/sites-available/$DOMAIN.conf

printf "  <Proxy fcgi://$DOMAIN>\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "    ProxySet connectiontimeout=5 timeout=240\n" >> /etc/apache2/sites-available/$DOMAIN.conf
printf "  </Proxy>\n\n" >> /etc/apache2/sites-available/$DOMAIN.conf

printf "</VirtualHost>\n" >> /etc/apache2/sites-available/$DOMAIN.conf


printf "<IfModule mod_ssl.c>\n" > /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "    <VirtualHost *:443>\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        ServerName $DOMAIN\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        ServerAlias *.$DOMAIN\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        DocumentRoot $WEBROOT/https\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        <Directory $WEBROOT/https/>\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "            Options Indexes FollowSymLinks MultiViews\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "            AllowOverride None\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "            Order allow,deny\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "            allow from all\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        </Directory>\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        LogLevel warn\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        ErrorLog $WEBROOT/logs/error-ssl.log\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        CustomLog $WEBROOT/logs/access-ssl.log combined\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf

printf "        <FilesMatch \"\.php$\">\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "          SetHandler \"proxy:unix://$WEBROOT/sockets/$DOMAIN-ssl.sock|fcgi://$DOMAIN-SSL\"\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        </FilesMatch>\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf

printf "        <Proxy fcgi://$DOMAIN-SSL>\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "          ProxySet connectiontimeout=5 timeout=240\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        </Proxy>\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf

printf "        Include /etc/apache2/includes/vhost-ssl\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf

printf "        #   The StartSSL Certificate\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        SSLCertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.crt\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        SSLCertificateKeyFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        SSLCertificateChainFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.ca.pem\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        SSLCACertificateFile $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        \n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf

printf "        #   SSL Protocol Adjustments:\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   The safe and default but still SSL/TLS standard compliant shutdown\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   approach is that mod_ssl sends the close notify alert but doesn't wait for\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   the close notify alert from client. When you need a different shutdown\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   approach you can use one of the following variables:\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   o ssl-unclean-shutdown:\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     This forces an unclean shutdown when the connection is closed, i.e. no\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     SSL close notify alert is send or allowed to received.  This violates\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     the SSL/TLS standard but is needed for some brain-dead browsers. Use\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     this when you receive I/O errors because of the standard approach where\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     mod_ssl sends the close notify alert.\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   o ssl-accurate-shutdown:\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     This forces an accurate shutdown when the connection is closed, i.e. a\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     SSL close notify alert is send and mod_ssl waits for the close notify\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     alert of the client. This is 100%% SSL/TLS standard compliant, but in\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     practice often causes hanging connections with brain-dead browsers. Use\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     this only for browsers where you know that their SSL implementation\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #     works correctly.\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   Notice: Most problems of broken clients are also related to the HTTP\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   keep-alive facility, so you usually additionally want to disable\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   keep-alive for those clients, too. Use variable "nokeepalive" for this.\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   Similarly, one has to force some clients to use HTTP/1.0 to workaround\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   their broken HTTP/1.1 implementation. Use variables "downgrade-1.0" and\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        #   "force-response-1.0" for this.\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        BrowserMatch \"MSIE [2-6]\" \x5C\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "            nokeepalive ssl-unclean-shutdown \x5C\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "            downgrade-1.0 force-response-1.0\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "            # MSIE 7 and newer should be able to use keepalive\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "        BrowserMatch \"MSIE [17-9]\" ssl-unclean-shutdown\n\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf

printf "    </VirtualHost>\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf
printf "</IfModule>\n" >> /etc/apache2/sites-available/$DOMAIN-ssl.conf

printf "\n########## ADD STARTSSSL CLASS2 CERTIFICATE FILES ###\n"

wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/sub.class2.server.sha2.ca.pem https://www.startssl.com/certs/class2/sha2/pem/sub.class2.server.sha2.ca.pem
wget -O $WEBROOT/certs/$YEAR/$SSLPROVIDER/ca.pem https://www.startssl.com/certs/ca.pem

printf "\n########## GENERATE SSL FOR DEFAULT SITE ###\n"

printf "\nConfigure Apache\n\n"

printf "Generating SSL\n\n"

printf "openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj \"/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN\"\n\n"

openssl req -nodes $ALGORITHM -newkey rsa:$KEYSIZE -keyout $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.key -out $WEBROOT/certs/$YEAR/$SSLPROVIDER/ssl.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONALUNIT/CN=$DOMAIN"
printf "\n########## ENABLE THE DEFAULT SITES ###\n"
a2ensite $DOMAIN.conf
#a2ensite $DOMAIN-ssl.conf

printf "\n########## SETUP THE DEFAULT SITE FASTCGI ###\n"

printf "\n########## CONFIG PHP-FPM ###\n"

cp /etc/php5/fpm/pool.d/www.conf.original /etc/php5/fpm/pool.d/${DOMAIN}.conf
cp /etc/php5/fpm/pool.d/www.conf.original /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

printf "\n########## DEFAULT HTTP POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN\]/" /etc/php5/fpm/pool.d/${DOMAIN}.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN.sock|" /etc/php5/fpm/pool.d/${DOMAIN}.conf

sed -i "s/user = www-data/user = $DOMAINUSER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf
sed -i "s/group = www-data/group = $DOMAINUSER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}.conf

printf "\n########## DEFAULT HTTPS POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN-SSL\]/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN-SSL.sock|" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/user = www-data/user = $DOMAINUSER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s/group = www-data/group = $DOMAINUSER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

##reload apache settings
service apache2 reload
