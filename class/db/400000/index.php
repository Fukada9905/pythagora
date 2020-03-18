<?php
class db_400000_index extends db_common
{
    public function __construct(){
        parent::__construct();
    }

    public function getManagementInfo($management_cd){
        $sql = "SELECT PTNCD, CONCAT(IFNULL(PTNCDNM1,''),IFNULL(PTNCDNM2,'')) AS PTNNM FROM pyt_m_partners WHERE PTNCD = :ManagementCD";
        $params = array("ManagementCD"=>$management_cd);
        $ret = $this->query($sql,$params);

        if($ret){
            return array("PTNCD"=>$ret[0]["PTNCD"], "PTNNM"=>$ret[0]["PTNNM"]);
        }
        else{
            return array("PTNCD"=>null, "PTNNM"=>null);
        }
    }

}