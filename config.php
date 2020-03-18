<?php
/*
 * SETTING RELEASE MODE
 * 1 : LOCAL DEVELOPMENT
 * 2 : DEVELOPMENT ON SERVER
 * 3 : STAGING SERVER
 * 4 : PROD RELEASE
 * */
define('DEVELOPMENT_FLAG',1);


/*INCLUDE CONST VALUES*/
require_once "const.php";

/*SET TIMEZONE */
date_default_timezone_set('Asia/Tokyo');

/*AUTO LOADER*/
spl_autoload_register('myAutoload');
function myAutoload($className){

    $chunk = explode('_',$className);
    $path = CLASS_DIR . DS . str_replace('pg'.DS,'',implode(DS,$chunk)) . '.php';
    if(!is_readable($path)){
		var_dump($className);
        var_dump("CLASSファイルが読み込めません path=".$path);
        exit();
    }
    require($path);
}

