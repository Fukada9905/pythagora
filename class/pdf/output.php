<?php
set_time_limit(300);
ini_set('memory_limit', '512M');
require '../../config.php';

session_start();
try{
    $pdo = new db_common();

    $data = $_SESSION[SESSION_PRINT_DATA];
    $user_info = unserialize($_SESSION[SESSION_USER_INFO]);

    $output_method = isset($_REQUEST['method']) ? $_REQUEST['method'] : null;
	 
    
    foreach ($_POST as $key=>$val){
        if($val != ""){
            $params[$key] = $val;
        }
    }
    $params["user_id"] = $user_info->user_id;
	$params["management_cd"] = !($user_info->management_cd) ? null : $user_info->management_cd;
	$params["is_partner"] = ($user_info->user_divide == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0;
	
	$process_divide = !($_REQUEST['process_divide']) ? !($params["process_divide"]) ? 0 : $params["process_divide"] : $_REQUEST['process_divide'];

    switch($output_method){
		case "101011":
			$output_class = new pdf_101011_index($output_method,$process_divide,$params);
			break;
		case "101012":
			$output_class = new pdf_101012_index($output_method,$process_divide,$params);
			break;
		case "101013":
			$output_class = new pdf_101013_index($output_method,$process_divide,$params);
			break;
		case "101014":
			$output_class = new pdf_101014_index($output_method,$process_divide,$params);
			break;
		case "101015":
			$output_class = new pdf_101015_index($output_method,$process_divide,$params);
			break;
		case "101020":
			$output_class = new pdf_101020_index($output_method,$process_divide,$params);
			break;
		case "101021":
			$output_class = new pdf_101021_index($output_method,$process_divide,$params);
			break;
        case "101041":
            $output_class = new pdf_101041_index($output_method,$process_divide,$params);
            break;
        case "101042":
            $output_class = new pdf_101042_index($output_method,$process_divide,$params);
            break;
        case "101043":
            $output_class = new pdf_101043_index($output_method,$process_divide,$params);
            break;
        case "101044":
            $output_class = new pdf_101044_index($output_method,$process_divide,$params);
            break;
        case "101045":
            $output_class = new pdf_101045_index($output_method,$process_divide,$params);
            break;
        case "101050":
            $output_class = new pdf_101050_index($output_method,$process_divide,$params);
            break;
        case "101051":
            $output_class = new pdf_101051_index($output_method,$process_divide,$params);
            break;
		case "103010":
			$output_class = new pdf_103010_index($output_method,$process_divide,$params);
			break;
		case "103020":
			$output_class = new pdf_103020_index($output_method,$process_divide,$params);
			break;
		case "103030":
			$output_class = new pdf_103030_index($output_method,$process_divide,$params);
			break;
        case "104000":
            $output_class = new pdf_104000_index($output_method,$process_divide,$params);
            break;
        case "105000":
            $output_class = new pdf_105000_index($output_method,$process_divide,$params);
            break;
		case "201010":
			$output_class = new pdf_201010_index($output_method,$process_divide,$params);
			break;
		case "201020":
			$output_class = new pdf_201020_index($output_method,$process_divide,$params);
			break;
		case "201030":
			$output_class = new pdf_201030_index($output_method,$process_divide,$params);
			break;
		case "202000":
			$output_class = new pdf_202000_index($output_method,$process_divide,$params);
			break;
		case "301000":
			$output_class = new pdf_301000_index($output_method,$process_divide,$params);
			break;
		case "304000":
			$output_class = new pdf_304000_index($output_method,$process_divide,$params);
			break;
        case "401000":
            $output_class = new pdf_401000_index($output_method,$process_divide,$params);
            break;
        case "402000":
            $output_class = new pdf_402000_index($output_method,$process_divide,$params);
            break;
        default:
            $output_class = new pdf_common($output_method,$process_divide,$params);
    }

    $output_class->init();
    $output_class->output();
}catch(Exception $e){
    $pdo->OutputErrorLog("サンプルPDF出力",null,$e->getMessage());
    $_SESSION[SESSION_ERROR_MSG1] = "PDF出力でエラーが発生しました。<br>管理者にお問い合わせください。";
    $_SESSION[SESSION_ERROR_MSG2] = "PDF Report Output Error.";
    header("Location:".URL."error.php");
    exit();
}
