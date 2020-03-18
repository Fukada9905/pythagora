<?php
class db_103020_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getData($is_partner, $date_divide, $date_from, $date_to, $jgscd, $management_cd, $pt_name_divide, $nnsicd, $user_id){
		$params = array(
			"is_partner"=>$is_partner
        ,	"date_divide"=>$date_divide
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"management_cd"=>$management_cd
		,	"pt_name_divide"=>$pt_name_divide
        ,   "nnsicd"=>$nnsicd
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_103020",$params);
		return $ret;
	}
	
	public function getRecentDate(){
		$sql = "SELECT ufn_get_date_format(IFNULL(MAX(shipper_accounting_date),CURRENT_TIMESTAMP)) AS recent_date FROM t_shipment";
		$ret = $this->query($sql);
		
		if(!$ret){
			return date('Y/m/d');
		}
		else{
			return $ret[0]['recent_date'];
		}
	}
}