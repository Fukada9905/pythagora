<?php
class db_205000_index extends db_201000_index
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getLastDate(){
		$sql = "SELECT pyt_ufn_get_date_format(IFNULL(MAX(wms_processing_date),CURRENT_TIMESTAMP)) AS recent_date FROM t_arrival";
		
		$ret = $this->query($sql);
		
		if(!$ret){
			return date('Y/m/d');
		}
		else{
			return $ret[0]['recent_date'];
		}
	}
	
	public function getData($is_partner, $date_from, $date_to, $denno, $jgscd, $sntcd, $nnsicd, $shcd, $has_comment, $management_cd,$user_id){
		$params = array(
			"is_partner"=>$is_partner
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"denno"=>$denno
		,	"jgscd"=>$jgscd
		,	"sntcd"=>$sntcd
		,	"nnsicd"=>$nnsicd
		,	"shcd"=>$shcd
		,	"has_comment"=>$has_comment
		,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_205000",$params);
		return $ret;
	}
	
	public function getDetailData($ids,$user_id){
		$params = array(
			"p_ids"=>$ids
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_205000_details",$params);
		return $ret;
	}
	

}