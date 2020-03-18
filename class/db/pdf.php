<?php
class db_pdf extends db_common
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getPdfInformation($output_method,$process_divide = null){
    	$params = array(
			"function_id"=>$output_method
		,	"process_divide"=>!($process_divide) ? 0 : $process_divide
		);
    	$ret = $this->spExec("pyt_p_get_pdf_informations",$params);
    	if($ret){
    		return $ret[0];
		}
		else{
    		return null;
		}
	}
	
	
	public function getPdfData($output_method,$process_divide,$params){
    	$ret = array();
    	switch($output_method){
			case "101020":
				$ret = $this->getData101020($params["process"],$process_divide,$params["is_partner"],$params["params_date_divide"],$params["params_target_date"],$params["JGSCD"],$params["SNTCD"],$params["PTNCD"],$params["NNSICD"],$params["management_cd"]);
				break;
			case "101021":
				$ret = $this->getData101021($params["process"],$process_divide,$params["is_partner"],$params["params_date_divide"],$params["params_target_date"],$params["JGSCD"],$params["SNTCD"],$params["NNSICD"],$params["management_cd"]);
				break;
            case "101050":
                $ret = $this->getData101050($params["process"],$process_divide,$params["ids"],$params["user_id"]);
                break;
            case "101051":
                $ret = $this->getData101051($params["process"],$process_divide,$params["ids"],$params["user_id"]);
                break;
            case "103020":
				$ret = $this->getData103020($process_divide,$params["ids"],$params["user_id"]);
				break;
			case "103010":
			case "103030":
				$ret = unserialize($_SESSION["OUTPUTDATA_".$output_method][$params["target_divide"]][$params["target_date"]]);
				break;
            case "104000":
                $ret = $this->getData104000($params["process_divide"],$params["ids"],$params["user_id"]);
                break;
            case "105000":
                $ret = $this->getData105000($params["process_divide"],$params["ids"],$params["user_id"]);
                break;
			case "202000":
				$ret = $this->getData202000($params["work_id"],$params["user_id"]);
				break;
			case "301000":
				$ret = $this->getData301000($params["work_id"],$params["user_id"]);
				break;
			case "304000":
				$ret = $this->getData304000($params["work_id"],$params["user_id"]);
				break;
            case "401000":
                $ret = $this->getData401000($params["get_divide"],$params["work_id"],$params["user_id"]);
                break;
            case "402000":
                $ret = $this->getData402000($params["work_id"],$params["user_id"]);
                break;
			default:
				$ret = unserialize($_SESSION["OUTPUTDATA_".$output_method]);
				break;
		}
		return $ret;
	}
	
	private function getData101020($process_divide,$target_divide,$is_partner,$date_divide,$target_date,$jgscd,$sntcd,$ptncd,$nnsicd,$management_cd){
		$params = array(
			"process_divide"=>$process_divide
		,	"target_divide"=>$target_divide
		,	"is_partner"=>$is_partner
		,	"date_divide"=>$date_divide
		,	"target_date"=>!($target_date) ? null : $target_date
		,	"JGSCD"=>!($jgscd) ? null : $jgscd
		,	"SNTCD"=>!($sntcd) ? null : $sntcd
		,	"PTNCD"=>!($ptncd) ? null : $ptncd
        ,	"NNSICD"=>!($nnsicd) ? null : $nnsicd
		,	"management_cd"=>!($management_cd) ? null : $management_cd
		
		);
		$ret = $this->spExec("pyt_p_101020_pdf",$params);
		return $ret;
		
	}
	
	private function getData101021($process_divide,$target_divide,$is_partner,$date_divide,$target_date,$jgscd,$sntcd,$nnsicd,$management_cd){
		$params = array(
			"process_divide"=>$process_divide
		,	"target_divide"=>$target_divide
		,	"is_partner"=>$is_partner
		,	"date_divide"=>$date_divide
		,	"target_date"=>!($target_date) ? null : $target_date
		,	"JGSCD"=>!($jgscd) ? null : $jgscd
		,	"SNTCD"=>!($sntcd) ? null : $sntcd
        ,	"NNSICD"=>!($nnsicd) ? null : $nnsicd
		,	"management_cd"=>!($management_cd) ? null : $management_cd
		
		);
		$ret = $this->spExec("pyt_p_101021_pdf",$params);
		return $ret;
		
	}

    private function getData101050($process_divide,$target_divide,$target_ids,$user_id){
        $params = array(
            "process_divide"=>$process_divide
        ,	"target_divide"=>$target_divide
        ,	"ids"=>$target_ids
        ,	"user_id"=>$user_id
        );
        $ret = $this->spExec("pyt_p_101050_pdf",$params);
        return $ret;

    }

    private function getData101051($process_divide,$target_divide,$target_ids,$user_id){
        $params = array(
            "process_divide"=>$process_divide
        ,	"target_divide"=>$target_divide
        ,	"ids"=>$target_ids
        ,	"user_id"=>$user_id
        );
        $ret = $this->spExec("pyt_p_101051_pdf",$params);
        return $ret;

    }

	private function getData103020($process_divide,$target_id,$user_id){
		$params = array(
			"process_divide"=>$process_divide
		,	"work_id"=>$target_id
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_103020_pdf",$params);
		return $ret;
		
	}

    private function getData104000($process_divide,$target_ids,$user_id){
        $params = array(
            "process_divide"=>$process_divide
        ,	"ids"=>$target_ids
        ,	"user_id"=>$user_id
        );
        $ret = $this->spExec("pyt_p_104000_pdf",$params);
        return $ret;

    }

    private function getData105000($process_divide,$target_ids,$user_id){
        $params = array(
            "process_divide"=>$process_divide
        ,	"ids"=>$target_ids
        ,	"user_id"=>$user_id
        );
        $ret = $this->spExec("pyt_p_105000_pdf",$params);
        return $ret;

    }
	
	private function getData202000($target_id,$user_id){
		$params = array(
			"work_id"=>$target_id
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_202000_pdf",$params);
		return $ret;
		
	}
	
	private function getData301000($target_id,$user_id){
		$params = array(
			"work_id"=>$target_id
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_301000_pdf",$params);
		return $ret;
		
	}
	
	
	private function getData304000($target_id,$user_id){
		$params = array(
				"work_id"=>$target_id
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_304000_pdf",$params);
		return $ret;
		
	}

    private function getData401000($get_divide,$target_id,$user_id){
        $params = array(
            "get_divide"=>$get_divide
        ,   "work_id"=>$target_id
        ,	"user_id"=>$user_id
        );
        $ret = $this->spExec("pyt_p_401000_pdf",$params);

        $return = array();

        $work_id = "";
        $header = array();
        $details = array();
        $no = 1;

        foreach ($ret as $row){
            if($work_id != $row["work_id"]){
                if($work_id){
                    $header["details"] = $details;
                    $header["details_count"] = count($details);
                    $return[] = $header;

                    $header = array();
                    $details = array();
                    $no = 1;
                }

                $header["shipper_name"] = $row["shipper_name"];
                $header["slip_number"] = $row["slip_number"];
                $header["retrieval_date"] = $row["retrieval_date"];
                $header["delivery_date"] = $row["delivery_date"];
                $header["warehouse"] = $row["warehouse"];
                $header["delivery"] = $row["delivery"];
                $header["work_id"] = $row["work_id"];
                $header["dispatch_user_name"] = $row["dispatch_user_name"];
                $header["user_name"] = $row["user_name"];
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
                ,   "no"=>$no
                );
                $no++;
            }

            $work_id = $row["work_id"];
        }

        $header["details"] = $details;
        $header["details_count"] = count($details);
        $return[] = $header;


        return $return;

    }


    private function getData402000($target_id,$user_id){
        $params = array(
            "work_id"=>$target_id
        ,	"user_id"=>$user_id
        );
        $ret = $this->spExec("pyt_p_402000_pdf",$params);

        $return = array();

        $work_id = "";
        $header = array();
        $details = array();
        $no = 1;

        foreach ($ret as $row){
            if($work_id != $row["work_id"]){
                if($work_id){
                    $header["details"] = $details;
                    $header["details_count"] = count($details);
                    $return[] = $header;

                    $header = array();
                    $details = array();
                    $no = 1;
                }

                $header["shipper_name"] = $row["shipper_name"];
                $header["slip_number"] = $row["slip_number"];
                $header["retrieval_date"] = $row["retrieval_date"];
                $header["delivery_date"] = $row["delivery_date"];
                $header["warehouse_accounting_date"] = $row["warehouse_accounting_date"];
                $header["warehouse"] = $row["warehouse"];
                $header["delivery"] = $row["delivery"];
                $header["transporter"] = $row["transporter"];
            }

            if($row["work_id"]){
                $details[] = array(
                    "transporter_name" => !($row["transporter_name"]) ? "" : $row["transporter_name"]
                ,   "shaban" => !($row["shaban"]) ? "" : $row["shaban"]
                ,   "kizai" => !($row["kizai"]) ? "" : $row["kizai"]
                ,   "jomuin" => !($row["jomuin"]) ? "" : $row["jomuin"]
                ,   "tel" => !($row["tel"]) ? "" : $row["tel"]
                ,   "remarks" => !($row["remarks"]) ? "" : $row["remarks"]
                ,   "no"=>$no
                );
                $no++;
            }

            $work_id = $row["work_id"];
        }

        $header["details"] = $details;
        $header["details_count"] = count($details);
        $return[] = $header;


        return $return;

    }
}