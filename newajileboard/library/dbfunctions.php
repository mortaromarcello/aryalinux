<?php
/**
 * The connect function.
 * @return mysqli The connection established with the database.
 * TODO : Remove connnection data to configuration file.
 */
function connect() {
	$username = "root";
	$password = "password@123";
	$database = "ffphp";
	$host = "localhost";
	
	$con = mysqli_connect ( $host, $username, $password, $database );
	return $con;
}
/**
 * Execute a query and fetch the results.
 *
 * @param string $sql
 *        	The SQL query that needs to be executed
 * @return unknown The result is an array of records that are returned by the database.
 */
function dbQuery($sql) {
	$con = connect ();
	$result = mysqli_query ( $con, $sql );
	$records = array ();
	while ( $row = mysqli_fetch_assoc ( $result ) ) {
		$records [count ( $records )] = $row;
	}
	mysqli_close ( $con );
	return $records;
}
/**
 * Execute an SQL insert/udpate/delete statement
 *
 * @param unknown $sql
 *        	The SQL statement to be executed
 * @return unknown The number of rows that were affected.
 */
function dbUpdate($sql) {
	$con = connect ();
	$result = mysqli_query ( $con, $sql );
	mysqli_close ( $con );
	return $result;
}
/**
 * This function would query the database given the name of the table, the array of columns that need to be fetched and the filters
 *
 * @param unknown $table        	
 * @param unknown $columns        	
 * @param unknown $filters        	
 * @return unknown
 */
function query($table, $columns, $filters, $columnMap = null) {
	$cols = "";
	$conditions = "";
	if ($columns == null) {
		$cols = "*";
	} else {
		foreach ( $columns as $col ) {
			if ($cols == "") {
				$cols = "$col";
			} else {
				$cols = "$cols, $col";
			}
		}
	}
	if ($filters != null) {
		foreach ( $filters as $col => $val ) {
			if ($conditions == "") {
				$conditions = "$col='" . addslashes ( $val ) . "'";
			} else {
				$conditions = "$conditions and $col='" . addslashes ( $val ) . "'";
			}
		}
	}
	if ($filters == null) {
		$sql = "select $cols from $table";
	} else {
		$sql = "select $cols from $table where $conditions";
	}
	$result = dbQuery ( $sql );
	if ($columnMap == null) {
		return $result;
	} else {
		$newResult = array ();
		foreach ( $result as $record ) {
			$newResult [count ( $newResult )] = swapKeys ( $record, $columnMap );
		}
		return $newResult;
	}
}
/**
 * This function would save the contents of an array into a table
 *
 * @param unknown $table        	
 * @param unknown $array        	
 * @return unknown
 */
function persist($table, $array) {
	$sql = "insert into $table ";
	$cols = "";
	$values = "";
	foreach ( $array as $col => $val ) {
		if ($cols == "") {
			$cols = "$col";
		} else {
			$cols = "$cols, $col";
		}
		if ($values == "") {
			$values = "'" . addslashes ( $val ) . "'";
		} else {
			$values = "$values, '" . addslashes ( $val ) . "'";
		}
	}
	$sql = "$sql ($cols) values ($values)";
	return dbUpdate ( $sql );
}
/**
 * This function would update a record in a table given the filters
 *
 * @param unknown $table        	
 * @param unknown $array        	
 * @param unknown $filters        	
 * @return unknown
 */
function update($table, $array, $filters) {
	$updates = "";
	$conditions = "";
	foreach ( $array as $col => $val ) {
		if ($updates == "") {
			$updates = "$col='" . addslashes ( $val ) . "'";
		} else {
			$updates = "$conditions, $col='" . addslashes ( $val ) . "'";
		}
	}
	if ($filters != null) {
		foreach ( $filters as $col => $val ) {
			if ($conditions == "") {
				$conditions = "$col='" . addslashes ( $val ) . "'";
			} else {
				$conditions = "$conditions, $col='" . addslashes ( $val ) . "'";
			}
		}
	}
	if ($filters == null) {
		$sql = "update $table set $updates";
	} else {
		$sql = "update $table set $updates where $conditions";
	}
	return dbUpdate ( $sql );
}
/**
 * This function would delete a record given the filters
 *
 * @param unknown $table        	
 * @param unknown $filters        	
 * @return unknown
 */
function delete($table, $filters) {
	$columns = "";
	$conditions = "";
	if ($filters != null) {
		foreach ( $filters as $col => $val ) {
			if ($conditions == "") {
				$conditions = "$col='" . addslashes ( $val ) . "'";
			} else {
				$conditions = "$conditions, $col='" . addslashes ( $val ) . "'";
			}
		}
	}
	if ($filters == null) {
		$sql = "delete from $table";
	} else {
		$sql = "delete from $table where $conditions";
	}
	return dbUpdate ( $sql );
}
function swapKeys($dataMap, $columnMap) {
	$keys = array_keys ( $dataMap );
	$result = array ();
	foreach ( $keys as $key ) {
		if (array_key_exists ( $key, $columnMap )) {
			$result [$columnMap [$key]] = $dataMap [$key];
		} else {
			$result [$key] = $dataMap [$key];
		}
	}
	return $result;
}
function reverseSwapKeys($dataMap, $columnMap) {
	$result = array ();
	foreach ( $dataMap as $key => $value ) {
		$colName = null;
		foreach ( $columnMap as $k => $v ) {
			if ($v == $key) {
				$colName = $k;
				break;
			}
		}
		if ($colName != null) {
			$result [$colName] = $value;
		} else {
			$result [$key] = $value;
		}
	}
	return $result;
}
?>