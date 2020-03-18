<?php


class common_server
{

    public static function IP(){
        return ($_SERVER["HTTP_X_FORWARDED_FOR"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
    }

    public static function UserAgent(){
        return ($_SERVER["HTTP_USER_AGENT"]) ? $_SERVER["HTTP_USER_AGENT"] : "UNKNOWN USER AGENT";
    }
    
    public static function URL(){
    	return substr(URL, 0, -1).$_SERVER['REQUEST_URI'];
	}

}