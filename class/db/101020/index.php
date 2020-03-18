<?php
class db_101020_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getRecentDate($process_divide){
    	$sql = "SELECT pyt_ufn_get_date_format(IFNULL(MAX(retrieval_date),CURRENT_TIMESTAMP)) AS recent_date FROM ";
    	$sql .= ($process_divide) ? "t_shipment" : "t_provisional_shipment";
    	
    	$ret = $this->query($sql);
    	
    	if(!$ret){
    		return date('Y/m/d');
		}
		else{
    		return $ret[0]['recent_date'];
		}
	}
    

}