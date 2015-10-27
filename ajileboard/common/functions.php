<?php
include_once 'dbconfig.php';
include_once 'ui/form_functions.php';
include_once 'ui/table_functions.php';
include_once 'users/users_functions.php';
include_once 'issues/issues_functions.php';

function connect() {
	global $username;
	global $password;
	global $server;
	global $database;
	
	$con = mysqli_connect ( $server, $username, $password, $database );
	if (! isset ( $con )) {
		die ( "Database connection failed!" );
	}
	return $con;
}
function query($sql) {
	$con = connect ();
	$result = mysqli_query ( $con, $sql );
	$data = array ();
	if ($result) {
		while ( $row = mysqli_fetch_assoc ( $result ) ) {
			$data [] = $row;
		}
	}
	return $data;
}
function update($sql) {
	$con = connect ();
	$result = mysqli_query ( $con, $sql );
	return $result;
}
function save_object($table, $data) {
	$con = connect();
	$cols = "";
	$vals = "";
	$sql = "insert into $table ";
	foreach ($data as $key=>$value) {
		$cols = "$cols, $key";
		$vals = "$vals, '" . addslashes($value) . "'";
	}
	$sql = "$sql ($cols) values ($vals)";
	$sql = str_replace("(, ", "(", $sql);
	echo $sql;
	return update($sql);
}
function multi_filter_select($table_name, $column_list = null, $filter_map = null) {
	$sql = "select ";
	if (! isset ( $column_list ) || count ( $column_list ) == 0) {
		$columns = "*";
	} else {
		$columns = "";
		foreach ( $column_list as $col ) {
			$columns = $columns . $col . ", ";
		}
	}
	$sql = $sql . $columns . " from " . $table_name;
	$filters = "";
	if (isset ( $filter_map ) && count ( $filter_map ) > 0) {
		$sql = $sql . " where ";
		foreach ( $filter_map as $key => $value ) {
			$filters = $filters . "$key='" . addslashes ( $value ) . "' and ";
		}
		$filters = $filters . ".";
	}
	$sql = $sql . $filters;
	$sql = str_replace ( ",  from", " from", $sql );
	$sql = str_replace ( " and .", "", $sql );
	$con = connect ();
	$result = query ( $sql );
	return $result;
}
?>