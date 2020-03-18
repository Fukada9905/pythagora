<?php
set_time_limit(300);
require '../config.php';

$output_file = LOG_FILE_DIR. DS . "batch_log" . DS . "master_update" . DS . date('Ymd').".log";
$output = date('Y/m/d H:i:s') . "\n";
$output .= "事業所＋センターマスタ更新処理 開始" . "\n\n";


try{
	$target_date = !($_REQUEST["target_date"]) ? null : date("Y/m/d",strtotime($_REQUEST["target_date"]));
    $pdo = new db_batch();
    try{
        $data = $pdo->SetMasterUpdate($target_date);

        foreach ($data as $row){
            $output .= $row["TABLE_NAMES"] . " 新規登録件数 : " . $row["PROCESS_COUNT_INSERT"] . " 更新件数 : " . $row["PROCESS_COUNT_UPDATE"] . "\n";
        }

    }catch(Exception $e){
        $pdo->OutputErrorLog("事業所＋センターマスタ更新処理",null,$e->getMessage());
        throw  $e;
    }
}catch (Exception $e){
    common_log::OutputLog($e->getMessage());
    $output .= "エラーの為処理を中断しました\n";
    $output .= "エラー内容\n";
    $output .= $e->getMessage() . "\n";
}

$output .= "--------------------------------\n";

try{
    common_log::OutputLogLine($output_file,$output);
}
catch (Exception $e){
    common_log::OutputLog($e->getMessage());
}




