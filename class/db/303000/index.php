<?php
class db_303000_index extends db_300000_index
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getData($is_partner, $date_from, $date_to, $jgscd, $sntcd, $is_partner_only, $management_cd,$user_id){
		$params = array(
			"is_partner"=>$is_partner
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"sntcd"=>$sntcd
		,	"is_partner_only" => $is_partner_only
		,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_303000",$params);
		return $ret;
	}
	
	
	public function getDetailData($target_id,$user_id){
		$params = array(
			"target_id"=>$target_id
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_303000_details",$params);
		return $ret;
	}
	
	public function updateData($work_id, $user_id){
		$params = array(
			"work_id"=>$work_id
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_303000_update",$params,false);
	}
	
	public function cancelData($work_id, $comment, $user_id){
		$params = array(
			"work_id"=>$work_id
		,	"Comment"=>	$comment
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_303000_cancel",$params,false);
	}
}