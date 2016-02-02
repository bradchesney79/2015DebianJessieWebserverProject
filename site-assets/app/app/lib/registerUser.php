require_once $WEBROOT . '/vendor/autoload.php';



$validator = new Zend\Validator\EmailAddress(
    array(
        'allow' => Zend\Validator\Hostname::ALLOW_DNS,
        'useMxCheck'    => true,
        'useDeepMxCheck'  => true
    )
);
if ($validator->isValid($email)) {
    // email appears to be valid
} else {
    // email is invalid; print the reasons
    foreach ($validator->getMessages() as $message) {
        echo "$message\n";
    }
}

