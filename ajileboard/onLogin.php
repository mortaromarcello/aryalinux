<?php
include_once 'common/functions.php';

$authRequest = getAuthRequest ( $_REQUEST );
var_dump($authRequest);
$authResponse = authenticate ( $authRequest );
var_dump($authResponse);
takeAuthAction ( $authResponse );
?>