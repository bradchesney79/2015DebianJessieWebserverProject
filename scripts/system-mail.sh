#!/bin/bash

CONFIGURATION="${1:-'./setup.conf'}"

source $CONFIGURATION

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