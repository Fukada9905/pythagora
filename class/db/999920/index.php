<?php
class db_999920_index extends db_master
{
    public function __construct(){
        parent::__construct();
    }
	
	public function getMaster($target_date_from,$target_date_to){
		return $this->spExec("pyt_p_999920",array("target_date_from"=>$target_date_from,"target_date_to"=>$target_date_to),true);
	}

}