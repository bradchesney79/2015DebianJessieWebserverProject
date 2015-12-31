#!/bin/bash

DEV=${1:-'TRUE'}
WEBROOT=${2:-'/var/www'}

# so there is this networking executable that pre-exists as 'node'
# if you run:
# which node
#
# and you don't see any output-- you are not using that other 'node' executable
# and you are free to softlink nodejs (as it is installed on Debian)
# The following command softlinks 'nodejs' to 'node' as it is known just about everywhere else
ln -s /usr/bin/nodejs /usr/bin/node

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
    "roave/security-advisories": "dev-master"

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
    "guzzlehttp/guzzle": "~6.0"
  }
}' >> $WEBROOT/composer.json

cd $WEBROOT

if [ $DEV = 'TRUE' ]
composer install --dev
else
composer install --no-dev
fi

apt-get install nodejs npm

npm cache clean -f
npm install -g n
n stable

npm install -g n node-gyp npm
n stable

cd https


echo '{
  "name": "Debian-Host",
  "description": "Performant, secure LAMP",
  "version": "1.0.0",
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
  }
}' > package.json

chmod 770 package.json

npm install pngjs foundation-cli --save

if [ $DEV = 'TRUE' ]
npm install gulp gulp-sass webpack jasmine karma karma-jasmine karma-browserstack-launcher --save-dev --no-optional
fi

npm init



bower install foundation-apps --save