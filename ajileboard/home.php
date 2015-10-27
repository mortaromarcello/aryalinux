<?php include_once 'common/functions.php';?>
<?php include_once 'common/general_header.php';?>
<?php
// showMenu();
?>
<a href="new_issue.php">New Issue</a>
<?php
$data = get_issues_by_creator_email ( null );
	 $headings = array (
		"issue_identifier" => "Identifier",
		"title" => "Title",
		"description" => "Description" 
);
	 table($headings, $data, array("cellspacing"=>"0", "cellpadding"=>"10"));
?>
<?php include_once 'common/general_footer.php';?>