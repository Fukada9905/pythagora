<?php
class db_402000_index extends db_400000_index{

    public function __construct(){
        parent::__construct();
    }
	
	public function getData($is_partner, $is_get_divide1, $is_get_divide2, $is_get_divide3, $is_get_divide4, $date_divide, $date_from, $date_to, $jgscd, $nnsicd, $ptncd, $rootpt3, $management_cd,$user_id){
		$params = array(
			"is_partner"=>$is_partner
        ,	"is_get_divide1"=>$is_get_divide1
        ,	"is_get_divide2"=>$is_get_divide2
        ,	"is_get_divide3"=>$is_get_divide3
        ,	"is_get_divide4"=>$is_get_divide4
        ,	"date_divide"=>$date_divide
        ,	"date_from"=>$date_from
        ,	"date_to"=>$date_to
        ,	"jgscd"=>$jgscd
        ,	"nnsicd"=>$nnsicd
        ,	"ptncd"=>$ptncd
        ,	"rootpt3"=>$rootpt3
        ,	"management_cd"=>$management_cd
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_402000",$params);
		return $ret;
	}
	
	
	public function getDetailData($target_id,$user_id){
		$params = array(
		    "target_id"=>$target_id
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_402000_details",$params);
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
                $header["id"] = $row["id"];
                $header["target_divide"] = $row["target_divide"];
            }

            if($row["work_id"]){
                $details[] = array(
                    "transporter_name" => !($row["transporter_name"]) ? "" : $row["transporter_name"]
                ,   "shaban" => !($row["shaban"]) ? "" : $row["shaban"]
                ,   "kizai" => !($row["kizai"]) ? "" : $row["kizai"]
                ,   "jomuin" => !($row["jomuin"]) ? "" : $row["jomuin"]
                ,   "tel" => !($row["tel"]) ? "" : $row["tel"]
                ,   "remarks" => !($row["remarks"]) ? "" : $row["remarks"]
                ,   "departure_datetime" => !($row["departure_datetime"]) ? "" : $row["departure_datetime"]
                ,   "arrival_datetime" => !($row["arrival_datetime"]) ? "" : $row["arrival_datetime"]
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
	
	public function updateData($update_divide, $target_divide, $id, $detail_no,$user_id){
		$params = array(
            "update_divide"=>$update_divide
        ,   "target_divide"=>$target_divide
        ,	"id"=>$id
		,	"detail_no"=>$detail_no
		,	"user_id"=>$user_id
		
		);
		$ret = $this->spExec("pyt_p_402000_update",$params,true);
		return ($ret) ? $ret[0]["update_datetime"] : date('Y/m/d') . "\n" . date("H:i");
	}
}