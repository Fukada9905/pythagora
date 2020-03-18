<?php
class db_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }
    
    
    public function GetPasswordByUserID($user_id){
        $sql = "SELECT user_password FROM pyt_m_users WHERE user_id= :user_id AND del_flag = 0";
        $params = array("user_id"=>$user_id);
        $ret = $this->query($sql,$params);

        if($ret){
            return $ret[0]["user_password"];
        }
        return null;
    }
	
	



}