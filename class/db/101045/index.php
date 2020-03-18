<?php
class db_101045_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }

    public function getData($process_divide,$selections,$user_id){
        $params = array(
            "process_divide"=>$process_divide
        ,	"selections"=>$selections
        ,	"user_id"=>$user_id
        );
		$ret = $this->spExec("pyt_p_101045",$params);
		return $ret;
	}
}