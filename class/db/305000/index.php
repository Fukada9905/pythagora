<?php
class db_305000_index extends db_300000_index
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getData($is_partner, $date_from, $date_to, $jgscd, $sntcd, $nnsicd, $ptncd, $management_cd,$user_id){
		$params = array(
			"is_partner"=>$is_partner
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"sntcd"=>$sntcd
		,	"nnsicd"=>$nnsicd
		,	"ptncd"=>$ptncd
		,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_305000",$params);
		return $ret;
	}
}