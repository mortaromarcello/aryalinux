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
	echo "<tr class=\"heading\">\n";
	foreach ( $headings as $key => $value ) {
		echo "<td>$value</td>\n";
	}
	echo "</tr>\n";
	$num = -1;
	foreach ( $data as $record ) {
		if ($num * -1 == 1) {
			echo "<tr class=\"r1\">\n";
		}
		else {
			echo "<tr class=\"r0\">\n";
		}
		$num = $num * -1;
		foreach ( $headings as $key => $value ) {
			echo "<td>$record[$key]</td>\n";
		}
		echo "</tr>\n";
	}
	echo "</table>\n";
}
?>