<?php
require "config.php";

session_start();

$user_info = unserialize($_SESSION[SESSION_USER_INFO]);
$pdo = new db_common();

$user_id = $user_info->user_id;
$user_password = $user_info->user_password;

$pdo->SetLogout($user_info->user_id);

session_destroy();
session_start();
setcookie(CACHE_NAME_USER, '', time() - 1800,'/'); // 1分前
setcookie(CACHE_NAME_PASS, '', time() - 1800,'/'); // 1分前
setcookie(CACHE_NAME_TICKET, '', time() - 1800,'/'); // 1分前

$_SESSION["LOGOUT_STATUS"] = true;
if($_REQUEST["AUTO_LOGOUT"]){
    $_SESSION["AUTO_LOGOUT"] = true;
    $_SESSION["KEEP_USER_ID"] = $user_id;
    $_SESSION["KEEP_USER_PASSWORD"] = $user_password;
}
header('Location:'.URL);