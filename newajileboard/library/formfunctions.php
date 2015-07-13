<?php
function textField($data) {
	$str = "<input type=\"text\" ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str/>";
	echo $str;
}
function password($data) {
	$str = "<input type=\"password\" ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str/>";
	echo $str;
}
function textArea($data) {
	$str = "<textarea ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str></textarea>";
	echo $str;
}
function submit($data) {
	$str = "<input type=\"submit\" ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str/>";
	echo $str;
}
function checkbox($data) {
	$str = "<input type=\"checkbox\" ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str/>";
	echo $str;
}
function radiobutton($data) {
	$str = "<input type=\"radio\" ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str/>";
	echo $str;
}
function resetButton($data) {
	$str = "<input type=\"reset\" ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str/>";
	echo $str;
}
function fileUpload($data) {
	$str = "<input type=\"file\" ";
	foreach ( $data as $attr => $value ) {
		$str = "$str $attr=\"$value\"";
	}
	$str = "$str/>";
	echo $str;
}
function comboBox($data) {
	$str = "<select ";
	foreach ( $data as $attr => $value ) {
		if ($attr != "data") {
			$str = "$str $attr=\"$value\"";
		}
	}
	$str = "$str>";
	foreach ( $data ["data"] as $key => $value ) {
		$str = "$str <option value=\"$value\">$key</option>";
	}
	$str = "$str</select>";
	echo $str;
}
function listBox($data) {
	$str = "<select ";
	foreach ( $data as $attr => $value ) {
		if ($attr != "data") {
			$str = "$str $attr=\"$value\"";
		}
	}
	$str = "$str>";
	foreach ( $data ["data"] as $key => $value ) {
		$str = "$str <option value=\"$value\">$key</option>";
	}
	$str = "$str</select>";
	echo $str;
}
function form($data) {
	$str = "<form ";
	foreach ( $data as $key => $value ) {
		if ($key != "fields") {
			$str = "$str $key=\"$value\"";
		}
	}
	$str = "$str>";
	echo $str;
	foreach ( $data ["fields"] as $label => $fieldData ) {
		echo "<div class=\"label\">$label</div>";
		if ($fieldData ["type"] == "textField") {
			echo textField ( $fieldData );
		}
		if ($fieldData ["type"] == "password") {
			echo password( $fieldData );
		}
		if ($fieldData ["type"] == "textArea") {
			echo textArea ( $fieldData );
		}
		if ($fieldData ["type"] == "submit") {
			echo submit ( $fieldData );
		}
		if ($fieldData ["type"] == "reset") {
			echo resetButton ( $fieldData );
		}
		if ($fieldData ["type"] == "comboBox") {
			echo comboBox ( $fieldData );
		}
		if ($fieldData ["type"] == "listBox") {
			echo listBox ( $fieldData );
		}
		if ($fieldData ["type"] == "checkBox") {
			echo checkbox ( $fieldData );
		}
	}
	$str = "$str</form>";
	echo $str;
}
?>