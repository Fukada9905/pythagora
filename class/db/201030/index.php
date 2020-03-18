<?php
class db_201030_index extends db_201000_index
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getData($is_partner, $date_from, $date_to, $jgscd, $sntcd, $management_cd,$user_id){
		$params = array(
			"is_partner"=>$is_partner
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"sntcd"=>$sntcd
		,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_201030",$params);
		return $ret;
	}
}