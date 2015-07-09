<?php
include_once 'common/functions.php';
function getAuthRequest($request) {
	$username = $request ["username"];
	$password = $request ["password"];
	return array (
			"email_address" => $username,
			"password" => $password 
	);
}
function authenticate($authRequest) {
	$result = multi_filter_select ( "users", null, $authRequest );
	return $result;
}
function takeAuthAction($authResponse) {
	if (count ( $authResponse ) > 0) {
		header ( "Location: home.php" );
	} else {
		header ( "Location: index.php?authfailure" );
	}
}
function register($user) {
}
function delete_user($id) {
}
function update_user($user) {
}
function get_users_by_multiple_filters($filter_map) {
}

?>