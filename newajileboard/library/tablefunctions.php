<?php
function table($tableData, $headings, $data, $keyColumn=null, $links=null) {
	$str = "<table";
	foreach ( $tableData as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str>";
	echo $str;
	$str = "<tr>";
	foreach ( $headings as $key => $value ) {
		$str = "$str<th>$value</th>";
	}
	if ($links != null) {
		foreach ( array_keys ( $links ) as $i ) {
			$str = "$str<th></th>";
		}
	}
	$str = "$str</tr>";
	echo $str;
	$position = "even";
	foreach ( $data as $record ) {
		$str = "<tr class=\"$position\"";
		if ($position == "even") {
			$position = "odd";
		} else {
			$position = "even";
		}
		$str = "$str>";
		foreach ( $headings as $key => $value ) {
			$str = "$str<td>$record[$key]</td>";
		}
		if ($links != null) {
			foreach ( $links as $key => $value ) {
				$str = "$str<td><a href=\"$value?id=$record[$keyColumn]\">$key</a></td>";
			}
		}
		$str = "$str</tr>";
		echo $str;
	}
	echo "</table>";
}
?>