<?php
set_time_limit(300);
require '../config.php';

$output_file = LOG_FILE_DIR. DS . "batch_log" . DS . "delete_old_files" . DS . date('Ymd').".log";
$output = date('Y/m/d H:i:s') . "\n";
$output .= "過去データ削除処理 開始" . "\n\n";

try{


    $pdo = new db_batch();
    try{
        $data = $pdo->SetOldFileDelete();

        foreach ($data as $row){
            $output .= $row["TABLE_NAMES"] . " 処理件数 : " . $row["PROCESS_COUNT"] . "\n";
        }

    }catch(Exception $e){
        $pdo->OutputErrorLog("過去データ削除",null,$e->getMessage());
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




