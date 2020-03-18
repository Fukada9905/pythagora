<?php

/**
 * Created by PhpStorm.
 * User: shun_kubota
 * Date: 2017/01/25
 * Time: 16:08
 */
class common_log
{
    public static function OutputLog($val,$file_path = ""){
		try{
        	if(!$file_path){
				chmod(LOG_FILE_DIR,0777);
                $file_path = LOG_FILE_DIR. DS . date('Ymd')."log.txt";
            }
        	else{
                chmod($file_path,0777);
            }
            $current = "[".date("H:i:s") ."]\n";
			$current .= $val ."\n";
			$current .= "\n";
			$current .= "-------------------------------------------\n";
			common_log::OutputLogLine($file_path, $current);
        }
        catch(Exception $e){
			//何もしない
			
        }
    }


    public static function OutputLogLine($file_path,$val){
        $current = file_get_contents($file_path);
        $val .= "\n";
        file_put_contents($file_path, $current.$val);
    }



    public static function ErrorTrace($trace){
    	$out = "";
    	foreach($trace as $line) {
			$out .= "{$line["file"]}: line {$line["line"]}" . "\n";
		}
		common_log::OutputLog($out);
	}

}