<?php
class db_101041_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getData($process_divide,$selections,$user_id,$nnsicd){
		$params = array(
			"process_divide"=>$process_divide
		,	"selections"=>$selections
		,	"user_id"=>$user_id
        ,   "nnsicd"=>$nnsicd
		);
		$ret = $this->spExec("pyt_p_101041",$params);
		return $ret;
	}
}