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
<p>
		<a href="newIssue.php">Create New Issue</a>&nbsp; <a
			href="allIssues.php">All Issues</a>
	</p>
<?php
$result = persist ( "issues", array (
		"title" => $_REQUEST ["title"],
		"description" => $_REQUEST ["description"],
		"status" => "1",
		"createdBy" => "cks3383@gmail.com",
		"presentOwner" => "cks3383@gmail.com",
		"type" => "2" 
) );

if ($result == 1) {
	echo "New Issue Added successfully.";
}

?>
<?php include_once 'footer.php';?>
</body>
</html>