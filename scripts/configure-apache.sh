#!/bin/bash

#CONFIGURATION="${1:-'../setup.conf'}"

#source $CONFIGURATION

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