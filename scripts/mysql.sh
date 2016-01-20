
export DEBIAN_FRONTEND="noninteractive"

fuser -vk /var/cache/debconf/config.dat

debconf-set-selections <<<  "mysql-server mysql-server/root_password select $DBROOTPASSWORD" 
debconf-set-selections <<<  "mysql-server mysql-server/root_password_again select $DBROOTPASSWORD"

spawn apt-get -y install mysql-server
expect "Enter password:"
send "$DBROOTPASSWORD\n"
expect "Enter password:"
send "$DBROOTPASSWORD\n"

#mysql_secure_installation #bug report, currently requires an expect script

mysql -uroot -p"$DBROOTPASSWORD" <<< "DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;"

#A common vector is to attack the MySQL root user since it is the default omipotent user put on almost all #MySQL installs.
#So, give your 'root' user a different name. (Is admin more secure than root, meh. Yeah, I guess.)

mysql -u"root" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'localhost' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"
mysql -u"$root" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'127.0.0.1' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"
mysql -u"$root" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'::1' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "DELETE FROM mysql.user WHERE User='root';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE USER 'backup'@'localhost' IDENTIFIED BY '$DBBACKUPUSERPASSWORD';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "FLUSH PRIVILEGES;"