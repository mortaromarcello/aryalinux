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
		<?php textfield("username", array("size"=>"20"), "textfield")?>
	</div>
	<div class="label">Password</div>
	<div class="control">
		<?php password("password", null, "textfield")?>
	</div>
	<div class="control">
		<?php submit("Login", "btn")?>
	</div>
	<?php endform();?>
</div>
<?php include_once 'common/login_footer.php';?>