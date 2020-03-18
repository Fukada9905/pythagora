<?php
class db_201000_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getRecentDate(){
    	$sql = "SELECT CASE WHEN MAX(created_at) IS NULL THEN '対象なし' ELSE pyt_ufn_get_date_format(MAX(created_at)) END AS recent_date FROM t_arrival";
		$sql .= " WHERE created_at >= CURRENT_DATE()";
		//$sql .= " WHERE TRKMJ BETWEEN '2018-03-15' AND DATE_ADD('2018-03-15', INTERVAL 1 DAY)";
		
    	$ret = $this->query($sql);
    	
    	if(!$ret){
    		return '対象なし';
		}
		else{
    		return $ret[0]['recent_date'];
		}
	}
    

}