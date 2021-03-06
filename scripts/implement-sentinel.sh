#!/bin/bash

source /root/bin/setup.conf

mkdir -p $WEBROOT/lib

echo "<?php

// Import the necessary classes
use Cartalyst\Sentinel\Native\Facades\Sentinel;
use Illuminate\Database\Capsule\Manager as Capsule;

// Include the composer autoload file
require '$WEBROOT/vendor/autoload.php';

// Setup a new Eloquent Capsule instance
$capsule = new Capsule;

$capsule->addConnection([
    'driver'    => 'mysql',
    'host'      => 'localhost',
    'database'  => '$SENTINELDB',
    'username'  => '$DEFAULTSITEDBUSER',
    'password'  => '$DEFAULTSITEDBPASSWORD',
    'charset'   => 'utf8',
    'collation' => 'utf8_unicode_ci',
]);

$capsule->bootEloquent();

?>" > "$WEBROOT/lib/defaultDbConn.php"

echo "<?php

require $WEBROOT/lib/defaultDbConn.php;

class userRegistration {

  $email;
  $password;
  $error;
  $errorType;
  $errorDescription;

  public function registerUser(dirtyEmail, dirtyPassword) {
  
  this.email=saniVali::validateEmail(email);
  this.email=saniVali::sanitizePassword(password);
  
  if (isset(this.email) {
    // Register a new user
    
  }
  else {
  


Sentinel::register([
    'email'    => 'test@example.com',
    'password' => 'foobar',
]);

}


