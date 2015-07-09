<?php
	include_once 'common/functions.php';
	
	$issue = parse_issue($_REQUEST);
	var_dump($issue);
	save_issue($issue);
?>