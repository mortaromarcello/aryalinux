<?php
include_once 'library/dbfunctions.php';
include_once 'library/formfunctions.php';
include_once 'library/tablefunctions.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ajileboard</title>
<link rel="stylesheet" type="text/css" href="style.css">
<link href='http://fonts.googleapis.com/css?family=Play:400,700'
	rel='stylesheet' type='text/css'>
</head>
<body>
<?php include_once 'header.php';?>
<div class="mainContent">
		<p>
			<a href="newIssue.php">Create New Issue</a>&nbsp; <a
				href="allIssues.php">All Issues</a>
		</p>
		<p>New Issue Form</p>
<?php
form ( array (
		"method" => "POST",
		"action" => "onNewIssue.php",
		"fields" => array (
				"Title" => array (
						"type" => "textField",
						"name" => "title",
						"size" => 80,
						"class" => "textfield",
						"style" => "font-size: 1.5em;padding: 5px;" 
				),
				"Description" => array (
						"type" => "textArea",
						"name" => "description",
						"class" => "textfield",
						"style" => "font-size: 1em;height:350px;padding: 5px;" 
				),
				"&nbsp;" => array (
						"type" => "submit",
						"value" => "Save",
						"class" => "btn" 
				) 
		) 
) );
?>
</div>
<?php include_once 'footer.php';?>
</body>
</html>