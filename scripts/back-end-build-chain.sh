
#todo test for ~3GB of ram available...
#todo for now just always make 3GB of swap

touch /root/swap.img
chmod 600 /root/swap.img
dd if=/dev/zero of=/root/swap.img bs=1024k count=3000
mkswap /root/swap.img
swapon /root/swap.img

printf "\n########## TURN OFF XDEBUG IF A DEV SERVER ###\n"

if [ "$DEV" = 'TRUE' ]
then
  php5dismod xdebug
fi

printf "\n########## INSTALL COMPOSER ###\n"

# only want to install the global resources the first time--
# specified via supplied argument or a default setting
if [ "$NTH_RUN" = 'FALSE' ] 
then
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi

printf "\n########## PLACE A POPULATED composer.json FILE ###\n"

echo '{

  "name": "bradchesney79/Debian-Host",
  "description": "Performant, secure LAMP",
  "minimum-stability": "dev",
  "license": "Unlicense",

  "require": {
    "nategood/httpful": "^0.2",
    "gabordemooij/redbean": "^4.3",
    "phpmailer/phpmailer": "~5.2",
    "swiftmailer/swiftmailer": "^5.4",
    "league/csv": "^8.0",
    "funct/funct": "^1.1",
    "mobiledetect/mobiledetectlib": "^2.8",
    "ezyang/htmlpurifier": "^4.7",
    "google/apiclient": "^1.1",
    "fabpot/goutte": "^3.1",
    "phpoffice/phpexcel": "^1.8",
    "mpdf/mpdf": "^6.0",
    "cartalyst/sentinel": "2.0.*",
    "illuminate/database": "^5.2",
    "zendframework/zendframework": "^2.5"
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

printf "\n########## INSTALL COMPOSER DEPENDENCIES FROM THE composer.json ###\n"

cd $WEBROOT

if [ "$DEV" = 'TRUE' ]
then
  composer install
else
  composer install --no-dev
fi



printf "\n########## SECOND ASSIGNMENT OF OWNERSHIP & PERMISSIONS ###\n"

# reset ownership & permissions on files
chown -R $USER:$USER $WEBROOT
chmod -R 774 $WEBROOT

chown -R www-data:www-data $WEBROOT/sockets
find $WEBROOT -type d -exec chmod -R 775 {} \;

popd

swapoff -a


