<?php
class db_101043_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }

    public function getData($process_divide,$selections,$user_id,$sntcd,$nnsicd){
        $params = array(
            "process_divide"=>$process_divide
        ,	"selections"=>$selections
        ,	"user_id"=>$user_id
        ,	"sntcd"=>$sntcd
        ,   "nnsicd"=>$nnsicd
        );
		$ret = $this->spExec("pyt_p_101043",$params);
		return $ret;
	}
}