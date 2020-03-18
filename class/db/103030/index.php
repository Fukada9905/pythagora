<?php
class db_103030_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }

    public function getData($process_divide, $target_divide,$target_date, $selections,$user_id){

        $params = array(
            "process_divide"=>$process_divide
        ,	"target_divide"=>$target_divide
        ,	"target_date"=>$target_date
        ,   "selections"=>$selections
        ,   "user_id"=>$user_id
        );
		$ret = $this->spExec("pyt_p_103030",$params);
		return $ret;
	}
	
	public function getRecentDates($process_divide, $selections,$user_id){

        $sql = "SELECT DISTINCT DENPYOYMD FROM pyt_w_103040_details WHERE user_id = :user_id AND process_divide = :process_divide ";
        if($selections) $sql .= "AND work_id IN(".$selections.") ";
        $sql .= "ORDER BY DENPYOYMD";

		$params = array(
		    "user_id"=>$user_id
        ,   "process_divide"=>$process_divide
        );

		$ret = $this->query($sql,$params);
		
		if(!$ret){
			return array(date('Y/m/d'));
		}
		else{
		    $return = array();
		    foreach ($ret as $row){
                $return[] = $row["DENPYOYMD"];
            }
			return $return;
		}
	}
}