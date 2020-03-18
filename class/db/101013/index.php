<?php
class db_101013_index extends db_101010_index
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getData($process_divide,$is_partner, $date_divide, $date_from, $date_to, $jgscd, $management_cd, $sntcd, $nnsicd){
		$params = array(
			"process_divide"=>$process_divide
		,	"is_partner"=>$is_partner
		,	"date_divide"=>$date_divide
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"management_cd"=>$management_cd
		,	"sntcd"=>$sntcd
        ,   "nnsicd"=>$nnsicd
		);
		$ret = $this->spExec("pyt_p_101013",$params);
		return $ret;
	}
}