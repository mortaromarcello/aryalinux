<?php
include_once 'common/functions.php';
include_once 'common/login_header.php';
?>
<div class="login-div">
	<?php
	$messages = array (
			"authfailure" => "Could not authenticate as the username/password was incorrect. Please retry." 
	);
	?>
	<?php form("loginForm", "POST", "onLogin.php", $messages);?>
	<div class="label">Username</div>
	<div class="control">
		<?php textfield("username")?>
	</div>
	<div class="label">Password</div>
	<div class="control">
		<?php password("password")?>
	</div>
	<div class="control">
		<?php submit("Login")?>
	</div>
	<?php endform();?>
</div>
<?php include_once 'common/login_footer.php';?>
<?php

$headings = array (
		"username" => "Username",
		"password" => "Password" 
);
$data = array (
		array (
				"username" => "cks3386@gmail.com",
				"password" => "password@123" 
		) 
);

$props = array("width"=>"100%");

table ( $headings, $data , $props);

?>