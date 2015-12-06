#!/bin/bash

SCRIPTLOCATION=`pwd`
UNIXTIMESTAMP=`date +%s`
DATE=`date +%Y-%m-%d`
YEAR=`date +%Y`
EXECUTIONLOG="/var/log/auto-install.log"

TROUBLESHOOTINGFILES="$SCRIPTLOCATION/troubleshooting/$UNIXTIMESTAMP"

WEBROOT="/var/www/http"

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

cp /etc/passwd ${TROUBLESHOOTINGFILES}/etc-passwd

cp /etc/group ${TROUBLESHOOTINGFILES}/etc-group

cp /etc/apt/sources.list ${TROUBLESHOOTINGFILES}/etc-apt-sources.list

cp /etc/iptables/rules.v4 ${TROUBLESHOOTINGFILES}/etc-iptables-rules.v4

mkdir -p ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available

cp /etc/apache2/sites-available/* ${TROUBLESHOOTINGFILES}/etc-apache2-sites-available/

cp /etc/apache2/includes/vhost-ssl ${TROUBLESHOOTINGFILES}/etc-apache2-includes-vhost-ssl

cp /etc/mysql/my.cnf ${TROUBLESHOOTINGFILES}/etc-mysql-my.cnf

cp /etc/php5/fpm/php.ini ${TROUBLESHOOTINGFILES}/etc-php5-fpm-php.ini

mkdir -p ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d

cp /etc/php5/fpm/pool.d/* ${TROUBLESHOOTINGFILES}/etc-php5-fpm-pool.d/

cp /etc/exim4/update-exim4.conf.conf ${TROUBLESHOOTINGFILES}/etc-exim4-update-exim4.conf.conf

cp /etc/exim4/conf.d/main/00_localmacros ${TROUBLESHOOTINGFILES}/etc-exim4-conf.d-main-00_localmacros

cp /etc/aliases ${TROUBLESHOOTINGFILES}/etc-aliases


printf "Start collecting log files\n\n"

printf "Apache log files\n"
#TODO: parse the apache sites-available confirmations for access & error log locations
#TODO: copy all the log files 

printf "FPM log file\n"
tail -n 1000 /var/log/php5-fpm.log >> ${TROUBLESHOOTINGFILES}/php5-fpm.log

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

printf "\n########## UPTIME, USERS (COUNT), AND LOAD AVG (LOAD MAX = 100 PERCENT x PROCESSORS AVAILABLE FOR PREVIOUS 1, 5, & 15 MINUTES) ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
uptime >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt


printf "\n\n########## LOWER LEVEL MACHINE MESSAGE INFO ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
dmesg | tail >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## CPU MEMORY USAGE ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
vmstat >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## PROCESSOR USAGE ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
mpstat -P ALL >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## RUNNING PROCESSES ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
pidstat >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## IO USAGE ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
iostat -xz 1 >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## MEMORY USAGE ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
free -m >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## KERNEL INFO ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
sar -n DEV 0 >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## NETWORK INFO ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
sar -n TCP,ETCP 0 >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

ipconfig >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "\n\n########## IP TABLE RULES LOADED ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
iptables -L >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## /ETC/PASSWD (USERS) ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-passwd >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

printf "########## /ETC/GROUP ###########\n\n" >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt
cat ${TROUBLESHOOTINGFILES}/etc-group >> ${TROUBLESHOOTINGFILES}/troubleshootingReport.txt

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
popd