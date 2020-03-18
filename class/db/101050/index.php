<?php
class db_101050_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }

    public function getData($process_divide,$is_partner, $date_divide, $date_from, $date_to, $jgscd, $management_cd,$user_id,$nnsicd,$sntcd){
        $params = array(
            "process_divide"=>$process_divide
        ,	"is_partner"=>$is_partner
        ,	"date_divide"=>$date_divide
        ,	"date_from"=>$date_from
        ,	"date_to"=>$date_to
        ,	"jgscd"=>$jgscd
        ,	"management_cd"=>$management_cd
        ,	"user_id"=>$user_id
        ,   "nnsicd"=>$nnsicd
        ,   "sntcd"=>$sntcd
        );
        $ret = $this->spExec("pyt_p_101050",$params);
        return $ret;
    }

    

}