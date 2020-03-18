<?php
class db_999030_index extends db_master
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getMaster($ptncd = null){
		return $this->spExec("pyt_p_999030",array("PTNCD"=>$ptncd),true);
	}
	
    public function updateMaster($params){
        $this->spExec("pyt_p_999030_update",$params,false);
    }
    
    public function getMasterDivide($get_divide = 0){
		return $this->spExec("pyt_p_999030_divide",array("get_divide"=>$get_divide),true);
	}
	
	public function updateData($update_data,$user_id){
		$params = array(
			"update_data"=>$update_data
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_999030_update",$params,false);
	}


}