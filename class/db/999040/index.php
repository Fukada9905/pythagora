<?php
class db_999040_index extends db_master
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getMaster($jgscd = null,$tmcptncd = null,$ckcptncd = null,$unsksptncd = null){
        $params = array(
            "JGSCD"=>$jgscd
        ,   "TMCPTNCD"=>$tmcptncd
        ,   "CKCPTNCD"=>$ckcptncd
        ,   "UNSKSPTNCD"=>$unsksptncd

        );
		return $this->spExec("pyt_p_999040",$params,true);
	}
	
    public function updateMaster($params){
        $this->spExec("pyt_p_999010_update",$params,false);
    }

    public function getComboMaster($get_divide){
        return $this->spExec("pyt_p_999040_combo_divide",array("get_divide"=>$get_divide),true);
    }

    public function getMasterDivide($get_divide){
		return $this->spExec("pyt_p_999040_divide",array("get_divide"=>$get_divide),true);
	}
	
	public function updateData($update_data,$user_id){
		$params = array(
			"update_data"=>$update_data
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_999040_update",$params,false);
	}


}