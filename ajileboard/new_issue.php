<?php include_once 'common/general_header.php';?>
<a href="home.php">All Issues</a>
<?php
include_once 'common/functions.php';
$messages = array (
		"success" => "Issue saved successfully.",
		"failed" => "Could not save the issue. Please retry." 
);
$tf_props = array (
		"size" => "60" 
);
$ta_props = array (
		"rows" => "10",
		"cols" => "60" 
);
form ( "new_issue", "POST", "on_new_issue.php", $messages );
?>
<div class="label">Issue ID</div>
<div class="control">
<?php textfield("issue_id", $tf_props, "textfield");?>
</div>
<div class="label">Title</div>
<div class="control">
<?php textfield("title", $tf_props, "big-textfield");?>
</div>
<div class="label">Description</div>
<div class="control">
<?php textarea("description", $ta_props, "textarea");?>
</div>
<div class="control">
<?php submit("Save", "btn")?>
</div>
<?php endform();?>
<?php include_once 'common/general_footer.php';?>