
printf "\n########## CONFIGURE SENTINEL DB TABLES###\n"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE DATABASE $SENTINELDB"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $SENTINELDB.* TO '$DEFAULTSITEDBUSER'@'localhost' IDENTIFIED BY '$DEFAULTSITEDBPASSWORD' WITH GRANT OPTION;"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "FLUSH PRIVILEGES;"

sed -i -e 's/\x270000-00-00 00:00:00\x27/CURRENT_TIMESTAMP/g' $WEBROOT/vendor/cartalyst/sentinel/schema/mysql.sql

mysql -u"$DEFAULTSITEDBUSER" -p"$DEFAULTSITEDBPASSWORD" -D"$SENTINELDB" < "$WEBROOT/vendor/cartalyst/sentinel/schema/mysql.sql"