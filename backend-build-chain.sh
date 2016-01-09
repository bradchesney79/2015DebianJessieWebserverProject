#!/bin/bash

WEBUSER=${1:-'default-web'}
DEV=${2:-'TRUE'}
WEBROOT=${3:-'/var/www'}
NTH_RUN=${4:-'TRUE'}

#todo test for ~3GB of ram available...
#todo for now just always make 3GB of swap

touch /root/swap.img
chmod 600 /root/swap.img
dd if=/dev/zero of=/root/swap.img bs=1024k count=3000
mkswap /root/swap.img
swapon /root/swap.img

php5dismod xdebug

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


echo '{

  "name": "Debian-Host",
  "description": "Performant, secure LAMP",
  "minimum-stability": "dev",

  "require": {
    "nategood/httpful": "*",
    "gabordemooij/redbean": "dev-master",
    "phpmailer/phpmailer": "~5.2",
    "swiftmailer/swiftmailer": "@stable",
    "league/csv": "^8.0",
    "funct/funct": "^1.1",
    "mobiledetect/mobiledetectlib": "^2.8",
    "ezyang/htmlpurifier": "^4.7",
    "google/apiclient": "^1.1",
    "fabpot/goutte": "^3.1",
    "phpoffice/phpexcel": "^1.8",
    "mpdf/mpdf": "^6.0",
    "cartalyst/sentinel": "2.0.*"
  },

  "require-dev": {
    "phpunit/phpunit": "5.0.*",
    "behat/behat": "2.4.*@stable",
    "behat/mink": "1.4@stable",
    "squizlabs/php_codesniffer": "*",
    "phpmd/phpmd": "*",
    "behat/symfony2-extension": "*",
    "behat/mink-extension": "*",
    "behat/mink-browserkit-driver": "*",
    "behat/mink-goutte-driver": "*",
    "behat/mink-selenium2-driver": "*",
    "behat/mink-sahi-driver": "*",
    "behat/mink-zombie-driver": "*",
    "filp/whoops": "dev-master",
    "guzzlehttp/guzzle": "~6.0",
    "roave/security-advisories": "dev-master"
  }
}' > $WEBROOT/composer.json

cd $WEBROOT

if [ "$DEV" = 'TRUE' ]
then
  composer install
else
  composer install --no-dev
fi

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

pushd $WEBROOT/https

if [ "$DEV" = 'TRUE' ]
then

  runuser -l "$WEBUSER" -c 'npm install'

  php5enmod xdebug

else
  npm install --production
fi

# reset ownership & permissions on files
chown -R $WEBUSER:$WEBUSER $WEBROOT
chmod -R 774 $WEBROOT

chown -R www-data:www-data $WEBROOT/sockets
find $WEBROOT -type d -exec chmod -R 775 {} \;

popd
swapoff -a