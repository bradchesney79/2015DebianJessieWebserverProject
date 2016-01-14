#!/bin/bash

source ../setup.conf

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