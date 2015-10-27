<?php
function textfield($name, $properties = null, $class = null) {
	echo "<input type=\"text\" name=\"$name\" ";
	$props = "";
	if (isset ( $properties )) {
		foreach ( $properties as $key => $value ) {
			$props = $props . "$key=\"$value\" ";
		}
	}
	if (isset ( $_REQUEST [$name] )) {
		$props = $props . "value=\"" . stripslashes ( $_REQUEST [$name] ) . "\" ";
	}
	echo $props;
	if (isset ( $class )) {
		echo "class=\"$class\" ";
	}
	echo "/>";
}
function textarea($name, $properties=null, $class=null) {
	echo "<textarea name=\"$name\" ";
	$props = "";
	if (isset ( $properties )) {
		foreach ( $properties as $key => $value ) {
			$props = $props . "$key=\"$value\" ";
		}
	}
	if (isset ( $_REQUEST [$name] )) {
		$props = $props . "value=\"" . stripslashes ( $_REQUEST [$name] ) . "\" ";
	}
	echo $props;
	if (isset ( $class )) {
		echo "class=\"$class\" ";
	}
	echo "></textarea>";
}
function password($name, $properties = null, $class = null) {
	echo "<input type=\"password\" name=\"$name\" ";
	$props = "";
	if (isset ( $properties )) {
		foreach ( $properties as $key => $value ) {
			$props = $props . "$key=\"$value\" ";
		}
	}
	echo $props;
	if (isset ( $class )) {
		echo "class=\"$class\" ";
	}
	echo "/>";
}
function submit($label, $class = null) {
	echo "<input type=\"submit\" value=\"$label\" ";
	if (isset ( $class )) {
		echo "class=\"$class\" ";
	}
	echo "/>";
}
function form($name, $method = "GET", $action = NULL, $messages = NULL) {
	form_messages ( $messages );
	if (! isset ( $method )) {
		$method = "GET";
	}
	if (! isset ( $action )) {
		$action = "";
	}
	echo "<form method=\"$method\" action=\"$action\">";
}
function endform() {
	echo "</form>";
}
function form_messages($messages) {
	if (isset ( $messages )) {
		foreach ( $messages as $key => $value ) {
			if (isset ( $_REQUEST ["$key"] )) {
				echo "<li>$value</li>";
			}
		}
	}
}
?>