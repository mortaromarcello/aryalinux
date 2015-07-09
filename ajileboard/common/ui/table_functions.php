<?php
function table($headings, $data, $properties = null, $style = null, $class = null) {
	echo "<table ";
	if (isset ( $properties )) {
		$props = "";
		foreach ( $properties as $key => $value ) {
			$props = $props . "$key=\"$value\" ";
		}
		echo $props;
	}
	if (isset ( $style )) {
		$style = "";
		echo "style=\"";
		foreach ( $style as $key => $value ) {
			$style = $style . "$key: $value; ";
		}
		
		echo "\"";
	}
	if (isset ( $class )) {
		echo " class=\"$class\"";
	}
	echo ">\n";
	echo "<tr>\n";
	foreach ( $headings as $key => $value ) {
		echo "<td>$value</td>\n";
	}
	echo "</tr>\n";
	foreach ( $data as $record ) {
		echo "<tr>\n";
		foreach ( $headings as $key => $value ) {
			echo "<td>$record[$key]</td>\n";
		}
		echo "</tr>\n";
	}
	echo "</table>\n";
}
?>