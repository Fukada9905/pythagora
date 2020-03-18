<?php
class db_101030_index extends db_101010_index
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getData($process_divide,$is_partner, $date_divide, $date_from, $date_to, $jgscd, $ptncd,$management_cd, $pt_name_divide,$nnsicd,$user_id){
		$params = array(
			"process_divide"=>$process_divide
		,	"is_partner"=>$is_partner
		,	"date_divide"=>$date_divide
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"ptncd"=>$ptncd
		,	"management_cd"=>$management_cd
		,	"pt_name_divide"=>$pt_name_divide
        ,   "nnsicd"=>$nnsicd
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_101030",$params);
		return $ret;
	}
	
}