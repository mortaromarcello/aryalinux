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
	<p>All Issues</p>
<?php
$data = query ( "issues", array (
		"id",
		"title",
		"createdDate",
		"createdBy",
		"status" 
), array (
		"presentOwner" => "cks3383@gmail.com" 
) );
if (count ( $data ) == 0) {
	echo "No records found.";
} else {
	table ( array (
			"style" => "width: 100%" 
	), array (
			"title" => "Title",
			"createdDate" => "Created On",
			"createdBy" => "Created By",
			"status" => "Status" 
	), $data, "id", array (
			"Show" => "issueDetails.php" 
	) );
}
?>
<?php include_once 'footer.php';?>
</body>
</html>