<?php
class db_batch extends db_base
{

    public function __construct(){
        parent::__construct();
    }

    public function SetOldFileDelete(){

        $data = $this->spExec("pyt_p_batch_del_old_data");
        return $data;

    }

    public function SetMasterUpdate($target_date){
    	$params = array("target_date"=>!($target_date) ? null : $target_date);
        $data = $this->spExec("pyt_p_batch_set_masters",$params);
        return $data;

    }





}