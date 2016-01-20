#!/bin/bash

CONFIGURATION="${1:-'./setup.conf'}"

source $CONFIGURATION


printf "\n########## START LOADING FRONT END RESOURCES ###\n"


# only want to install the global resources the first time--
# specified via supplied argument or a default setting
if [ "$NTH_RUN" = 'FALSE' ] 
then
apt-get -y install nodejs nodejs-legacy ruby-dev ruby

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash



# so there is this networking executable that pre-exists as 'node'
# if you run:
# which node
#
# and you don't see any output-- you are not using that other 'node' executable
# and you are free to softlink nodejs (as it is installed on Debian)
# The following command softlinks 'nodejs' to 'node' as it is known just about everywhere else
# ln -s /usr/bin/nodejs /usr/bin/node

# This command need run every time the node version is changed.
# It provides global access to the nvm installed node version.

n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local

source /root/.bashrc 

nvm install v5.3.0
n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local

npm install -g npm@latest

npm install -g foundation-cli bower gulp karma-cli

fi

printf "\n########## PLACE A POPULATED package.json FILE ###\n"

echo '{
  "name": "Debian-Host",
  "description": "Performant, secure LAMP",
  "version": "1.0.0",
  "author": "Brad Chesney <bradchesney79@gmail.com> (https://rustbeltrebellion.com)",
  "maintainers": [
    {
      "name": "Brad Chesney",
      "email": "bradchesney79@gmail.com",
      "web": ""
    }
  ],
  "repository": {
    "type": "git",
    "url": "https://github.com/bradchesney79/2015DebianJessieWebserverProject"
  },
  "license": "Unlicense",
  "dependencies": {
    "font-awesome": "^4.5.0",
    "pngjs": "^2.2.0",
    "zxcvbn": "^4.2.0"

  },
  "devDependencies": {
    "gulp-karma": "0.0.5",
    "gulp-sass": "^2.1.1",
    "jasmine-core": "^2.4.1",
    "karma": "^0.12.37",
    "karma-browserstack-launcher": "^0.1.8",
    "karma-jasmine": "^0.3.6",
    "node-inspector": "^0.12.5",
    "phantomjs": "^1.9.19",
    "sassdoc": "^2.1.19",
    "webpack": "^1.12.9"
  }
}' > $WEBROOT/https/package.json

chmod 770 $WEBROOT/https/package.json

# reset ownership & permissions on files

printf "\n########## FIRST ASSIGNMENT OF OWNERSHIP & PERMISSIONS ###\n"

chown -R $WEBUSER:$WEBUSER $WEBROOT
chmod -R 774 $WEBROOT

chown -R www-data:www-data $WEBROOT/sockets
find $WEBROOT -type d -exec chmod -R 775 {} \;

printf "\n########## INSTALL FRONT END ASSETS & RESOURCES ###\n"

if [ "$DEV" = 'TRUE' ]
then

  runuser -l "$WEBUSER" -c "cd $WEBROOT/https; npm install"
  # you'll want this back on...
  php5enmod xdebug

else
  runuser -l "$WEBUSER" -c "cd $WEBROOT/https; npm install --production"
fi