<?php
class db_999020_index extends db_master
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getMaster(){
		return $this->spExec("pyt_p_999020",array(),true);
	}
	
    public function updateData($update_data,$user_id){
		$params = array(
			"update_data"=>$update_data
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_999020_update",$params,false);
	}


}