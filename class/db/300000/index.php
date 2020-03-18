<?php
class db_300000_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getRecentDate(){
		$sql = "SELECT pyt_ufn_get_date_format(IFNULL(MAX(wms_processing_date),CURRENT_TIMESTAMP)) AS recent_date FROM t_inventory";
		
		$ret = $this->query($sql);
		
		if(!$ret){
			return date('Y/m/d');
		}
		else{
			return $ret[0]['recent_date'];
		}
	}
	
}