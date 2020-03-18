<?php
require "../../config.php";
set_time_limit(180);
$class_name = $_POST[AJAX_PARAMS_CLASS];
$process = $_POST[AJAX_PARAMS_PROCESS];
$data = $_POST[AJAX_PARAMS_DATA];

switch($class_name){
	case "index":
		$cls = new ajax_index($process);
		break;
	default:
		if(ctype_digit($class_name)){
			$caller = "ajax_".$class_name."_index";
			$cls = new $caller($process);
		}
		else{
			$cls = new ajax_common($process);
		}
		break;
}
if($cls->IsError()){
	echo $cls->GetReturns();
	exit();
}
$cls->process($data);
echo $cls->GetReturns();