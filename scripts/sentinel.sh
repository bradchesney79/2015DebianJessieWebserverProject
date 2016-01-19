#!/bin/bash

CONFIGURATION="${1:-'../setup.conf'}"

source $CONFIGURATION

printf "\n########## CONFIGURE SENTINEL DB TABLES###\n"

# "datalord:seconddummypassword"

mysql -u"$DBROOTUSER" -p$"DBROOTPASSWORD" <<<"CREATE DATABASE $SENTINELDB"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $SENTINELDB.* TO '$DBWEBUSER'@'localhost' IDENTIFIED BY '$DBWEBUSERPASSWORD' WITH GRANT OPTION;"

mysql -u"$DBWEBUSER" -p"$DBWEBUSERPASSWORD" -D"$SENTINELDB" < "$WEBROOT/vendor/cartalyst/sentinel/schema/mysql.sql"
