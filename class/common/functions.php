<?php
class common_functions{
	
	public static function setDbClassName($className)
	{
		return "db_" . $className;
	}
	
	public static function getTicket(){
		return md5(uniqid().mt_rand());
	}

    public static function is_in_array($needle, $array){

        foreach ($array as $key => $value){
            if(is_array($needle)){
                foreach ($needle as $val){
					if(strpos($val,$value) !== false){
						return true;
					}
                }
            }
            else{
            	if(strpos($needle,$value) !== false){
					return true;
				}
            }
        }
        return false;
    }
    
    public static function implodeAssociativeArray($glue = ",",$array){
    	if(!is_array($array)){
    		return $array;
		}
		$out = "";
		foreach ($array as $key=>$val){
  			$out .= $glue.$key . ":" . $val;
		}
		
		return substr($out, 1);
	}
	
	public static function NumberFormat($val,$out_put_type = null){
    	if(!$out_put_type){
			if(!$val || !is_numeric($val)){
				return $val;
			}
		}
		elseif ($out_put_type == 1){
    		if(!$val || !is_numeric($val)){
    			return "0";
			}
		}
		elseif ($out_put_type == 2){
			if(!$val || !is_numeric($val)){
				return " ";
			}
		}
  
		
		$degits = !(strpos(strval ($val),".")) ? 0 : strlen($val) - strpos(strval ($val),".")-1;
    	
    	return number_format($val,$degits);
		
		
		
	}
	
	public static function get_device($ua = null)
	{
		if ( is_null($ua) ) {
			$ua = $_SERVER['HTTP_USER_AGENT'];
		}
		
		if ( preg_match('/Windows Phone/ui', $ua) ) { //UAにAndroidも含まれるので注意
			return 'WindowsPhone';
		} else if (preg_match('/Windows NT 10.0/', $ua)) {
            return 'Windows 10';
        } elseif (preg_match('/Windows NT 6.3/', $ua)) {
            return 'Windows 8.1';
        } elseif (preg_match('/Windows NT 6.2/', $ua)) {
            return 'Windows 8';
        } elseif (preg_match('/Windows NT 6.1/', $ua)) {
            return 'Windows 7';
        } elseif (preg_match('/Windows NT 6.0/', $ua)) {
            return 'Windows Vista';
        } elseif (preg_match('/Windows NT 5.2/', $ua)) {
            return 'Windows XP x64 Edition';
        } elseif (preg_match('/Windows NT 5.1/', $ua)) {
            return 'Windows XP';
        } elseif (preg_match('/Windows NT 5.0/', $ua)) {
            return 'Windows 2000';
        } elseif (preg_match('/Windows NT 4.0/', $ua)) {
            return 'Microsoft Windows NT 4.0';
        } elseif (preg_match('/Mac OS X ([0-9\._]+)/', $ua, $matches)) {
            return 'Macintosh Intel ' . str_replace('_', '.', $matches[1]);
        } elseif (preg_match('/OS ([a-z0-9_]+)/', $ua, $matches)) {
            if ( preg_match('/iPhone/', $ua) ) {
                return 'iPhone'.' / iOS ' . str_replace('_', '.', $matches[1]);
            } else if ( preg_match('/iPad/', $ua) ) {
                return 'iPad'.' / iOS ' . str_replace('_', '.', $matches[1]);;
            } else if ( preg_match('/iPod/', $ua) ) {
                return 'iPod'.' / iOS ' . str_replace('_', '.', $matches[1]);;
            }
        } elseif (preg_match('/Android ([a-z0-9\.]+)/', $ua, $matches)) {
            return 'Android ' . $matches[1];
        } elseif (preg_match('/Linux ([a-z0-9_]+)/', $ua, $matches)) {
            return 'Linux ' . $matches[1];
        } else {
            return 'unidentified';
        }
	}
	
	public static function get_browser($ua = null){
		if ( is_null($ua) ) {
			$ua = $_SERVER['HTTP_USER_AGENT'];
		}
		
		if ( preg_match('/edge/', $ua) ) { //UAにAndroidも含まれるので注意
			return 'edge';
		} else if ( preg_match('/iemobile/i', $ua) ) {
			return 'Internet Explorer Mobile';
		} else if ( preg_match('/trident|msie/i', $ua) ) {
			if(preg_match('/trident/i', $ua)){
				return 'Internet Explorer 11';
			}
			elseif(preg_match('/msie 6./i', $ua)){
				return 'Internet Explorer 6';
			}
			elseif(preg_match('/msie 7./i', $ua)){
				return 'Internet Explorer 7';
			}
			elseif(preg_match('/msie 8./i', $ua)){
				return 'Internet Explorer 8';
			}
			elseif(preg_match('/msie 9./i', $ua)){
				return 'Internet Explorer 9';
			}
			elseif(preg_match('/msie 10./i', $ua)){
				return 'Internet Explorer 10';
			}
		} else if ( preg_match('/chrome/i', $ua) ) {
			return 'Google Chrome';
		} else if ( preg_match('/firefox/i', $ua) ) {
			return 'Firefox';
		} else if ( preg_match('/safari/i', $ua) ) {
			return 'Safari';
		} else if ( preg_match('/opera/i', $ua) ) {
			return 'Opera';
		} else {
			return 'unknown';
		}
	}

    public static function getStringFromHash($hash){
        $return = array();
        foreach ($hash as $key=>$val){
            $return[] = $key . ":" . $val;
        }
        return implode(",",$return);
    }
    
    


}