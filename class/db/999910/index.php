<?php
class db_999910_index extends db_master
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getMaster(){
		return $this->spExec("pyt_p_999910",array(),true);
	}
	
    public function updateMaster($target_user_id){
        $this->spExec("pyt_p_999910_update",array("target_user_id"=>$target_user_id),false);
    }
    

}