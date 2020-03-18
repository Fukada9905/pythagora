<?php
set_time_limit(300);

require '../../config.php';

session_start();
try{
	$pdo = new db_csv();
	
	$output_method = isset($_REQUEST['method']) ? $_REQUEST['method'] : null;
	$user_info = unserialize($_SESSION[SESSION_USER_INFO]);
	
	$params = array();
	foreach ($_POST as $key=>$val){
		if($val != ""){
			$params[$key] = $val;
		}
	}
	$params["user_id"] = $user_info->user_id;
	$params["user_divide"] = $user_info->user_divide;
	$params["management_cd"] = !($user_info->management_cd) ? null : $user_info->management_cd;
	
	
	switch($output_method){
		default:
			$output_class = new csv_common($output_method,$params);
	}
	ini_set('memory_limit', '1024M');
	$output_class->init();
	$output_class->output();
}catch(Exception $e){
	$pdo->OutputErrorLog("CSV出力",null,$e->getMessage());
	$_SESSION[SESSION_ERROR_MSG1] = "CSV出力でエラーが発生しました。<br>管理者にお問い合わせください。";
	$_SESSION[SESSION_ERROR_MSG2] = "CSV Output Error.";
	header("Location:".URL."error.php");
	exit();
}
