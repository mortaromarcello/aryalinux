<?php
include_once 'library/dbfunctions.php';
include_once 'library/formfunctions.php';
include_once 'library/tablefunctions.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome to Ajileboard</title>
<link rel="stylesheet" type="text/css" href="style.css">
<link href='http://fonts.googleapis.com/css?family=Play:400,700'
	rel='stylesheet' type='text/css'>
</head>
<body>
<?php
form ( array (
		"method" => "POST",
		"action" => "onLogin.php",
		"fields" => array (
				"Username" => array (
						"type" => "textField",
						"name" => "username",
						"size" => 25,
						"class" => "textfield" 
				),
				"Password" => array (
						"type" => "password",
						"name" => "password",
						"size" => 25,
						"class" => "textfield" 
				),
				"&nbsp;" => array (
						"type" => "submit",
						"value" => "Login",
						"class" => "btn" 
				) 
		) 
) );
?>
</body>
</html>