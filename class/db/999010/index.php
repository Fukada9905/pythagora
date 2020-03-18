<?php
class db_999010_index extends db_master
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getMaster($user_group_id = null){
		return $this->spExec("pyt_p_999010",array("user_group_id"=>$user_group_id),true);
	}
	
    public function updateMaster($params){
        $this->spExec("pyt_p_999010_update",$params,false);
    }
    
    public function getMasterDivide($get_divide = 0){
		return $this->spExec("pyt_p_999010_divide",array("get_divide"=>$get_divide),true);
	}
	
	public function updateData($update_data,$user_id){
		$params = array(
			"update_data"=>$update_data
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_999010_update",$params,false);
	}


}