<?php
class db_401000_index extends db_400000_index{

    public function __construct(){
        parent::__construct();
    }
	
	public function getData($is_partner, $get_divide, $date_divide, $date_from, $date_to, $jgscd, $nnsicd, $ptncd, $denno, $sntcd, $nohincd, $rootpt1, $rootpt2, $rootpt3, $management_cd,$user_id){
		$params = array(
			"is_partner"=>$is_partner
        ,	"get_divide"=>$get_divide
        ,	"date_divide"=>$date_divide
        ,	"date_from"=>$date_from
        ,	"date_to"=>$date_to
        ,	"jgscd"=>$jgscd
        ,	"nnsicd"=>$nnsicd
        ,	"ptncd"=>$ptncd
        ,	"denno"=>$denno
		,	"sntcd"=>$sntcd
		,	"nohincd"=>$nohincd
		,	"rootpt1"=>$rootpt1
        ,	"rootpt2"=>$rootpt2
        ,	"rootpt3"=>$rootpt3
		,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_401000",$params);
		return $ret;
	}
	
	
	public function getDetailData($get_divide,$target_id,$user_id){
		$params = array(
		    "get_divide"=>$get_divide
		,	"target_id"=>$target_id
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_401000_details",$params);
		$return = array();

		$work_id = "";
		$header = array();
        $details = array();
        $max_detail_no = 0;

		foreach ($ret as $row){
            if($work_id != $row["work_id"]){
                if($work_id){
                    $header["details"] = $details;
                    $header["details_count"] = count($details);
                    $header["max_detail_no"] = $max_detail_no;
                    $return[] = $header;

                    $header = array();
                    $details = array();
                    $max_detail_no = 0;
                }

                $header["shipper_name"] = $row["shipper_name"];
                $header["slip_number"] = $row["slip_number"];
                $header["retrieval_date"] = $row["retrieval_date"];
                $header["delivery_date"] = $row["delivery_date"];
                $header["warehouse"] = $row["warehouse"];
                $header["delivery"] = $row["delivery"];
                $header["work_id"] = $row["work_id"];
            }

            if($row["id"]){
                $details[] = array(
                    "transporter_name" => !($row["transporter_name"]) ? "" : $row["transporter_name"]
                ,   "shaban" => !($row["shaban"]) ? "" : $row["shaban"]
                ,   "kizai" => !($row["kizai"]) ? "" : $row["kizai"]
                ,   "jomuin" => !($row["jomuin"]) ? "" : $row["jomuin"]
                ,   "tel" => !($row["tel"]) ? "" : $row["tel"]
                ,   "remarks" => !($row["remarks"]) ? "" : $row["remarks"]
                ,   "detail_no"=> $row["detail_no"]
                );
                $max_detail_no = (int)$row["detail_no"] > $max_detail_no ? (int)$row["detail_no"] : $max_detail_no;
            }

            $work_id = $row["work_id"];
        }

        $header["details"] = $details;
        $header["details_count"] = count($details);
        $header["max_detail_no"] = $max_detail_no;
        $return[] = $header;


		return $return;
	}
	
	public function updateData($get_divide, $update_data,$dispatcher,$user_id){
		$params = array(
            "get_divide"=>$get_divide
        ,	"update_data"=>$update_data
		,	"dispatcher"=>$dispatcher
		,	"user_id"=>$user_id
		
		);
		$this->spExec("pyt_p_401000_update",$params,false);
	}
}