<?php
class db_csv extends db_common
{
    public function __construct(){
        parent::__construct();
    }
    
    public function getCsvInformation($output_method,$process_divide = null){
    	$params = array(
			"function_id"=>$output_method
		,	"process_divide"=>!($process_divide) ? 0 : $process_divide
		);
    	$ret = $this->spExec("pyt_p_get_csv_informations",$params);
    	if($ret){
    		return $ret[0];
		}
		else{
    		return null;
		}
	}
	
	
	public function getCsvData($output_method,$params){
    	$ret = array();
    	switch($output_method){
			case "101011":
			case "101012":
			case "101013":
			case "101014":
			case "101015":
				$process_divide = $_SESSION["100000_PROCESS_DIVIDE"];
				$is_partner = ($params["user_divide"] == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0;
				$date_divide = $_SESSION["101010_DATE_DIVIDE"];
				$date_from = ($_SESSION["101010_DATE_FROM"]) ? $_SESSION["101010_DATE_FROM"] : null;
				$date_to = ($_SESSION["101010_DATE_TO"]) ? $_SESSION["101010_DATE_TO"] : null;
			
				$arr_jgscd = array();
				if($_SESSION["100000_JGSCD"]){
					$arr_jgscd = array_map(function($value){
						return "'".$value["id"] ."'";
					},$_SESSION["100000_JGSCD"]);
				}
				$jgscd = !($arr_jgscd) ? null : implode(",",$arr_jgscd);

                if($_SESSION["101010_NINUSHI"]){
                    $arr_nnsicd = array_map(function($value){
                        return "'".$value["id"] ."'";
                    },$_SESSION["101010_NINUSHI"]);
                }
                $nnsicd = !($arr_nnsicd) ? null : implode(",",$arr_nnsicd);

				$arr_ptncd = array();
		
				$sntcd = !($params["sntcd"]) ? null : $params["sntcd"];
			
				if($_SESSION["100000_PTNCD"]){
					$arr_ptncd = array_map(function($value){
						return $value["id"];
					},$_SESSION["100000_PTNCD"]);
				}
				
			
				
				if($params["user_divide"] == "30"){
					$ptncd = $params["management_cd"];
				}
				else{
					$ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);
				}
				$ret = $this->getData101common($process_divide,$is_partner,$date_divide,$date_from,$date_to,$jgscd,$sntcd,$ptncd,$nnsicd);
			
				break;
			case "101030":
				$ret = $this->getData101030($params["process_divide"],$params["ids"],$params["pt_name_divide"],$params["user_id"]);
				break;
            case "101041":
            case "101042":
            case "101043":
            case "101044":
            case "101045":

                $process_divide = $_SESSION["100000_PROCESS_DIVIDE"];

                $selections = !($_SESSION["101040_SELECTION"]) ? null : $_SESSION["101040_SELECTION"];
                $sntcd = !($params["sntcd"]) ? null : $params["sntcd"];



                $ret = $this->getData10104common($process_divide,$selections,$sntcd,$params["user_id"]);

                break;
            case "106000":
                $ret = $this->getData106000($params["process_divide"],$params["ids"],$params["user_id"]);
                break;
			case "103010":
			case "103030":

			    /*
				$is_partner = ($params["user_divide"] == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0;
				$target_date = ($params["target_date"]) ? $params["target_date"] : null;
				
				$arr_jgscd = array();
				if($_SESSION["100000_JGSCD"]){
					$arr_jgscd = array_map(function($value){
						return "'".$value["id"] ."'";
					},$_SESSION["100000_JGSCD"]);
				}
				$jgscd = !($arr_jgscd) ? null : implode(",",$arr_jgscd);
			
				$arr_ptncd = array();
				if($_SESSION["100000_PTNCD"]){
					$arr_ptncd = array_map(function($value){
						return $value["id"];
					},$_SESSION["100000_PTNCD"]);
				}
				if($params["user_divide"] == "30"){
					$ptncd = $params["management_cd"];
				}
				else{
					$ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);
				}
				$ret = $this->getData103common($is_partner,$target_date,$jgscd,$ptncd);
			    */

                $target_date = ($params["target_date"]) ? $params["target_date"] : null;
                $process_divide = $params["process_divide"];
                $selections = !($params["selections"]) ? null : $params["selections"];
                $ret = $this->getData103common($process_divide,$selections,$params["user_id"],$target_date);

				break;
			case "103020":
				$ret = $this->getData103020($params["ids"],$params["pt_name_divide"],$params["user_id"]);
				break;
			/*
			case "201010":
				$ret = $this->getData201010($params["user_id"]);
				break;
			case "201020":
				$ret = $this->getData201020($params["user_id"]);
				break;
			case "201030":
				$ret = $this->getData201030($params["user_id"]);
				break;
			*/
			case "201010":
			case "201020":
			case "201030":
				$is_partner = ($params["user_divide"] == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0;
				$date_from = ($_SESSION["201000_DATE_FROM"]) ? $_SESSION["201000_DATE_FROM"] : null;
				$date_to = ($_SESSION["201000_DATE_TO"]) ? $_SESSION["201000_DATE_TO"] : null;
		
				$arr_jgscd = array();
				if($_SESSION["200000_JGSCD"]){
					$arr_jgscd = array_map(function($value){
						return "'".$value["id"] ."'";
					},$_SESSION["200000_JGSCD"]);
				}
				$jgscd = !($arr_jgscd) ? null : implode(",",$arr_jgscd);
			
			
				$arr_sntcd = array();
				if($_SESSION["201000_CENTER"]){
					$arr_sntcd = array_map(function($value){
						return "('".$value["JGSCD"] ."','".$value["SNTCD"] ."')";
					},$_SESSION["201000_CENTER"]);
				}
				$sntcd = !($arr_sntcd) ? null : implode(",",$arr_sntcd);
			
			
				$arr_ptncd = array();
				if($_SESSION["200000_PTNCD"]){
					$arr_ptncd = array_map(function($value){
						return $value["id"];
					},$_SESSION["200000_PTNCD"]);
				}
				if($params["user_divide"] == "30"){
					$ptncd = $params["management_cd"];
				}
				else{
					$ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);
				}
				$ret = $this->getData201common($is_partner,$date_from,$date_to,$jgscd,$sntcd,$ptncd);
				break;
			case "202000":
				$ret = $this->getData202000($params["ids"],$params["user_id"]);
				break;
			case "305000":
				$ret = $this->getData305000($params["ids"],$params["user_id"]);
				break;
            case "402000":
                $ret = $this->getData402000($params["work_id"],$params["user_id"]);
                break;
			case "999010":
				$ret = $this->getData999010($params["params_user_group_id"]);
				break;
            case "999920":
                $ret = $this->getData999920($params["target_date_from"],$params["target_date_to"]);
                break;
            case "999040":
                $ret = $this->getData999040($params["params_jgscd"],$params["params_tmcptncd"],$params["params_ckcptncd"],$params["params_unsksptncd"]);
                break;
			default:
				$ret = unserialize($_SESSION["OUTPUTDATA_".$output_method]);
				break;
		}
		return $ret;
		
	}
	private function getData101common($process_divide,$is_partner, $date_divide, $date_from, $date_to, $jgscd, $sntcd, $management_cd, $nnsicd){
		$params = array(
			"process_divide"=>$process_divide
		,	"is_partner"=>$is_partner
		,	"date_divide"=>$date_divide
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"sntcd"=>$sntcd
		,	"management_cd"=>$management_cd
        ,   "nnsicd"=>$nnsicd
		);
		$ret = $this->spExec("pyt_p_101_common_csv",$params);
		return $ret;

	}

    private function getData10104common($process_divide,$selections, $sntcd, $user_id){
        $params = array(
            "process_divide"=>$process_divide
        ,	"selections"=>$selections
        ,	"sntcd"=>$sntcd
        ,   "user_id"=>$user_id
        );
        $ret = $this->spExec("pyt_p_10104_common_csv",$params);
        return $ret;

    }

    private function getData103common($process_divide,$selections, $user_id,$target_date){
        $params = array(
            "process_divide"=>$process_divide
        ,	"selections"=>$selections
        ,   "user_id"=>$user_id
        ,   "target_date"=>$target_date
        );
        $ret = $this->spExec("pyt_p_103_common_csv",$params);
        return $ret;

    }
    /*
	private function getData103common($is_partner, $target_date, $jgscd, $management_cd){
		$params = array(
			"is_partner"=>$is_partner
		,	"target_date"=>$target_date
		,	"jgscd"=>$jgscd
		,	"management_cd"=>$management_cd
		);
		$ret = $this->spExec("pyt_p_103_common_csv",$params);
		return $ret;
		
	}
    */
	
	private function getData101030($process_divide,$ids,$pt_name_divide,$user_id){
		$params = array(
			"process_divide"=>$process_divide
		,	"ids"=>$ids
		,	"pt_name_divide"=>$pt_name_divide
		,	"user_id"=>$user_id
		
		);
		
		$ret = $this->spExec("pyt_p_101030_csv",$params);
		return $ret;
	
	}

    private function getData106000($process_divide,$ids,$user_id){
        $params = array(
            "process_divide"=>$process_divide
        ,	"ids"=>$ids
        ,	"user_id"=>$user_id

        );

        $ret = $this->spExec("pyt_p_106000_csv",$params);
        return $ret;

    }
	
	private function getData103020($ids,$pt_name_divide,$user_id){
		$params = array(
			"ids"=>$ids
		,	"pt_name_divide"=>$pt_name_divide
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_103020_csv",$params);
		return $ret;
		
	}
	
	private function getData201common($is_partner, $date_from, $date_to, $jgscd, $sntcd, $management_cd){
		$params = array(
			"is_partner"=>$is_partner
		,	"date_from"=>$date_from
		,	"date_to"=>$date_to
		,	"jgscd"=>$jgscd
		,	"sntcd"=>$sntcd
		,	"management_cd"=>$management_cd
		);
		$ret = $this->spExec("pyt_p_201_common_csv",$params);
		return $ret;
		
	}
	
	private function getData201010($user_id){
		$params = array(
				"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_201010_csv",$params);
		return $ret;
		
	}
	
	private function getData201020($user_id){
		$params = array(
				"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_201020_csv",$params);
		return $ret;
		
	}
	
	private function getData201030($user_id){
		$params = array(
				"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_201030_csv",$params);
		return $ret;
		
	}
	
	private function getData202000($ids,$user_id){
		$params = array(
			"ids"=>$ids
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_202000_csv",$params);
		return $ret;
		
	}
	
	private function getData305000($ids,$user_id){
		$params = array(
			"ids"=>$ids
		,	"user_id"=>$user_id
		);
		$ret = $this->spExec("pyt_p_305000_csv",$params);
		return $ret;
		
	}

    private function getData402000($target_id,$user_id)
    {
        $params = array(
            "work_id" => $target_id
        , "user_id" => $user_id
        );
        $ret = $this->spExec("pyt_p_402000_csv", $params);
        return $ret;
    }
	
	private function getData999010($user_group_id){
		$params = array(
				"user_group_id"=>$user_group_id
		);
		$ret = $this->spExec("pyt_p_999010_csv",$params);
		return $ret;
		
	}

    private function getData999920($target_date_from,$target_date_to){
        $ret = $this->spExec("pyt_p_999920",array("target_date_from"=>$target_date_from,"target_date_to"=>$target_date_to),true);
        $return = array();
        $key_names = array("login_date"=>"ログイン日","user_id"=>"ユーザーID","user_name"=>"ユーザー名");
        foreach ($ret as $index => $row){
            $out = array();
            foreach ($row as $key => $val){
                if($key == "user_agent"){
                    $out["デバイス"] = common_functions::get_device($val);
                    $out["ブラウザ"] = common_functions::get_browser($val);
                }
                else{
                    $out[$key_names[$key]] = $val;
                }
            }
            $return[$index] = $out;
        }
        return $return;
    }

    public function getData999040($jgscd = null,$tmcptncd = null,$ckcptncd = null,$unsksptncd = null){
        $params = array(
            "JGSCD"=>$jgscd
        ,   "TMCPTNCD"=>$tmcptncd
        ,   "CKCPTNCD"=>$ckcptncd
        ,   "UNSKSPTNCD"=>$unsksptncd

        );
        return $this->spExec("pyt_p_999040_csv",$params,true);
    }
}