<?php
class db_204000_index extends db_201000_index
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getData($is_partner, $date_from, $date_to, $denno, $jgscd, $sntcd, $management_cd,$user_id){
		$params = array(
			"is_partner"=>$is_partner
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"denno"=>$denno
		,	"jgscd"=>$jgscd
		,	"sntcd"=>$sntcd
		,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_204000",$params);
		return $ret;
	}
	
	public function getDetailData($ids,$user_id){
		$params = array(
			"p_ids"=>$ids
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_204000_details",$params);
		return $ret;
	}
	
	
	public function updateData($work_id,$user_id){
		$params = array(
			"work_id"=>$work_id
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_204000_update",$params,false);
	}
	
	public function cancelData($work_id,$user_id){
		$params = array(
				"work_id"=>$work_id
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_204000_cancel",$params,false);
		return $ret;
	}

}