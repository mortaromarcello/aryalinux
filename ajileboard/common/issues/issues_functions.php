<?php
include_once 'common/functions.php';
function get_issues_by_assignee_email($emailAddress) {
}
function get_issues_by_creator_email($emailAddress) {
	return query("select * from tbl_issues");
}
function get_issue_by_id($id) {
}
function get_issue_by_multiple_filters($filter_map) {
}
function delete_issue($id) {
}
function update_issue($issue) {
}
function parse_issue($request) {
	$issue = array (
			"issue_identifier" => $request ["issue_id"],
			"title" => $request ["title"],
			"description" => $request ["description"] 
	);
	return $issue;
}
function save_issue($issue) {
	$result = save_object ( "tbl_issues", $issue );
	if ($result) {
		header("Location: new_issue.php?success");
	}
	else {
		header("Location: new_issue.php?failed");
	}
}
?>