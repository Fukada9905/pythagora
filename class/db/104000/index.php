<?php
class db_104000_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getData($process_divide, $is_partner, $date_divide, $date_from, $date_to, $jgscd, $nnsicd, $management_cd,$user_id){
		$params = array(
		    "process_divide"=>$process_divide
		,	"is_partner"=>$is_partner
        ,	"date_divide"=>$date_divide
        ,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
        ,	"nnsicd"=>$nnsicd
		,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_104000",$params);
		return $ret;
	}
}