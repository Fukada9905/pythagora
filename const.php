<?php
/*SITE SETTING*/
define('SITE_TITLE', 'PYTHAGORA');

/*PROTOCOL*/
if (empty($_SERVER['HTTPS'])) {
    define('PROTOCOL','http://');
}
else{
    define('PROTOCOL','https://');
}

//LOCAL DEVELOPMENT
if(DEVELOPMENT_FLAG == 1){
    define('URL', PROTOCOL."pythagora/");
    define('HOST_NAME','nuc-dev.com');

    /** DB SETTING **/
    define('DB_NAME','c_one');
    define('DB_USER', 'ptgr_admin');
    define('DB_PASSWORD', 'ptgr_admin');
    define('DSN', 'mysql:host='.HOST_NAME.';dbname='.DB_NAME.';charset=utf8;');
}
//DEVELOPMENT ON SERVER
elseif(DEVELOPMENT_FLAG == 2){
    define('URL', PROTOCOL."cone-pythagora.nuc-dev.com/");
    define('HOST_NAME','localhost');

    /** DB SETTING **/
    define('DB_NAME','c_one');
    define('DB_USER', 'ptgr_admin');
    define('DB_PASSWORD', 'ptgr_admin');
    define('DSN', 'mysql:host='.HOST_NAME.';dbname='.DB_NAME.';charset=utf8;');
//STAGING SERVER(NO USE!!!!)
}
elseif(DEVELOPMENT_FLAG == 3){
    define('URL', "https://devpythagora.otsukawh.co.jp/");
    define('HOST_NAME','conedb01-stg-cluster-1.cluster-cp0mpksu06vt.ap-northeast-1.rds.amazonaws.com');

    /** DB SETTING **/
    define('DB_NAME','c_one');
    define('DB_USER', 'nuc-mnt');
    define('DB_PASSWORD', 't7uVaTr2M!pe');
    define('DSN', 'mysql:host='.HOST_NAME.';dbname='.DB_NAME.';charset=utf8;');
}
//PROD RELEASE
else{
    define('URL', "https://pythagora.otsukawh.co.jp/");
    define('HOST_NAME','conedb01-prd-cluster.cluster-cp0mpksu06vt.ap-northeast-1.rds.amazonaws.com');

    /** DB SETTING **/
    define('DB_NAME','c_one');
    define('DB_USER', 'nuc-mnt');
    define('DB_PASSWORD', 't7uVaTr2M!pe');

    define('DSN', 'mysql:host='.HOST_NAME.';dbname='.DB_NAME.';charset=utf8;');
}



/*DIRECTORY PATH */
define('DS', DIRECTORY_SEPARATOR);
define('ROOT_DIR',dirname(__FILE__));

define('CLASS_DIR', ROOT_DIR . DS . 'class');
define('TEMPLATE_DIR', ROOT_DIR . DS . 'template');
define('MODULE_DIR', ROOT_DIR . DS . 'module');
define('TEMP_FILE_DIR', ROOT_DIR . DS . 'temp');
define('LOG_FILE_DIR', ROOT_DIR . DS . 'log');

define('CSS_DIR', URL . 'css');
define('JS_DIR', URL . 'js');
define('IMG_DIR', URL . 'img');
define('PDF_TEMPLATE_DIR', URL . 'class/pdf_template');




/** CHACHE NAME **/
define('CACHE_NAME_USER', 'AUTO_LOGIN_USER');
define('CACHE_NAME_PASS', 'AUTO_LOGIN_PASS');
define('CACHE_NAME_TICKET', 'AUTO_LOGIN_TICKET');

/** SESSION NAME **/
define('SESSION_USER_INFO', 'USER_INFO');
define('SESSION_ERROR_MSG1', 'ERROR_MSG1');
define('SESSION_ERROR_MSG2', 'ERROR_MSG2');
define('SESSION_ERROR_UNSET_FLG', 'ERROR_UNSET_FLG');
define('SESSION_PAGE_PARENT', 'PAGE_PARENT');
define('SESSION_PAGE_ROOT', 'PAGE_ROOT');
define('SESSION_PRINT_DATA', 'PRINT_DATA');
define('SESSION_TICKET', 'SESSION_TICKET');

/** AJAX PARAMS **/
define('AJAX_PARAMS_CLASS', 'CLASS_NAME');
define('AJAX_PARAMS_PROCESS', 'PROCESS_DIVIDE');
define('AJAX_PARAMS_DATA', 'DATA');

/** AJAX STATUS **/
define('STATUS_OK', 'OK');
define('STATUS_ERROR', 'ERROR');
define('STATUS_NO_DATA', 'NO_DATA');
define('STATUS_NG_USER', 'NG_USER');
define('STATUS_NG_PASS', 'NG_PASS');
define('STATUS_NO_PROCESS', 'NO_PROCESS');
define('STATUS_OTHER_LOGIN', 'OTHER_LOGIN');

/** GLOBAL VARIABLE */
$num_fields = array("No","slip_no","case_quantity","quantity","weight","重量","ケース数量","中間数量","バラ数量","ケース入数","総バラ数","ケース単位","バラ単位","K","S","F");



const PAPER_SIZE = array(
    "A2" => array("W"=>420,"H"=>594)
,   "A3" => array("W"=>297,"H"=>420)
,   "A4" => array("W"=>210,"H"=>297)
,   "A5" => array("W"=>148,"H"=>210)
,   "A6" => array("W"=>105,"H"=>148)
,   "B2" => array("W"=>500,"H"=>707)
,   "B3" => array("W"=>353,"H"=>500)
,   "B4" => array("W"=>250,"H"=>353)
,   "B5" => array("W"=>176,"H"=>250)
,   "B6" => array("W"=>125,"H"=>176)
);
