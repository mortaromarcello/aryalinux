<?php
include_once 'library/dbfunctions.php';
include_once 'library/formfunctions.php';
include_once 'library/tablefunctions.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>New Project</title>
<link rel="stylesheet" type="text/css" href="style.css">
<link href='http://fonts.googleapis.com/css?family=Play:400,700'
	rel='stylesheet' type='text/css'>
</head>
<body>
<?php include_once 'header.php';?>
<?php

form ( array (
		"method" => "post",
		"action" => "onNewProject.php",
		"fields" => array (
				"Project Name" => array (
						"type" => "textField",
						"name" => "name",
						"style" => "width: 100%",
						"class" => "textfield" 
				),
				"" => array (
						"type" => "submit",
						"value" => "Save Project" 
				) 
		) 
) );
?>
<?php include_once 'footer.php';?>
</body>
</html>