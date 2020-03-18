<?php
class ajax_401000_index extends ajax_base{

	public function process($data){
		
		try{
			switch($this->process_divide){
				case "get_main_data":
					$this->GetMaindata($data);
					break;
				case "get_detail_data":
					$this->GetDetailData($data["get_divide"], $data["target_id"]);
					break;
				case "update_data":
					$this->UpdateData($data["get_divide"], $data["Update_data"],$data["Dispatcher"]);
					break;
				default:
					$this->return["status"] = STATUS_ERROR;
					$this->return["message"] = "ajax通信でエラーが発生しました。\n処理区分が不明です";
					break;
			}
			if(!$this->return["status"]) $this->return["status"] = STATUS_OK;
		}catch(PDOException $e){
			common_log::OutputLog($e->getMessage());
			$this->return["status"] = STATUS_ERROR;
			$this->return["message"] = "ajax通信でエラーが発生しました。\n管理者へお問い合わせください";
		}catch(Exception $e){
			common_log::OutputLog($e->getMessage());
			$this->return["status"] = STATUS_ERROR;
			$this->return["message"] = $e->getMessage();
		}
	}
	
	
	private function GetMaindata($data){

        $get_divide = ($data["GET_DIVIDE"]) ? $data["GET_DIVIDE"] : 1;

        $date_divide = ($data["DATE_DIVIDE"]) ? $data["DATE_DIVIDE"] : 4;
	    $date_from = ($data["DATE_FROM"]) ? $data["DATE_FROM"] : null;
		$date_to = ($data["DATE_TO"]) ? $data["DATE_TO"] : null;
		
		$arr_jgscd = array();
		if($_SESSION["400000_JGSCD"]){
			$arr_jgscd = array_map(function($value){
				return "'".$value["id"] ."'";
			},$_SESSION["400000_JGSCD"]);
		}
		$jgscd = !($arr_jgscd) ? null : implode(",",$arr_jgscd);

        $arr_nnsicd = array();
        if($data["NNSICD"]){
            $arr_nnsicd = array_map(function($value){
                return "'".$value["id"]."'";
            },$data["NNSICD"]);
        }
        $nnsicd = !($arr_nnsicd) ? null : implode(",",$arr_nnsicd);

        $arr_sub_ptncd = array();
        if($data["PTNCD"]){
            $arr_sub_ptncd = array_map(function($value){
                return "'".$value["id"]."'";
            },$data["PTNCD"]);
        }
        $sub_ptncd = !($arr_sub_ptncd) ? null : implode(",",$arr_sub_ptncd);


        $denno = ($data["DENNO"]) ? $data["DENNO"] : null;

        $nohincd = ($data["NOHINCD"]) ? $data["NOHINCD"] : null;


		$arr_sntcd = array();
		if($data["SNTCD"]){
			$arr_sntcd = array_map(function($value){
				return "('".$value["JGSCD"] ."','".$value["SNTCD"] ."')";
			},$data["SNTCD"]);
		}
		$sntcd = !($arr_sntcd) ? null : implode(",",$arr_sntcd);
		
		
		$arr_ptncd = array();
		if($_SESSION["400000_PTNCD"]){
			$arr_ptncd = array_map(function($value){
				return $value["id"];
			},$_SESSION["400000_PTNCD"]);
		}
		$ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);



        $arr_rootpt1 = array();
        if($data["ROOTPT1"]){
            $arr_rootpt1 = array_map(function($value){
                return "'".$value["id"]."'";
            },$data["ROOTPT1"]);
        }
        $rootpt1 = !($arr_rootpt1) ? null : implode(",",$arr_rootpt1);

        $arr_rootpt2 = array();
        if($data["ROOTPT2"]){
            $arr_rootpt2 = array_map(function($value){
                return "'".$value["id"]."'";
            },$data["ROOTPT2"]);
        }
        $rootpt2 = !($arr_rootpt2) ? null : implode(",",$arr_rootpt2);

        $arr_rootpt3 = array();
        if($data["ROOTPT3"]){
            $arr_rootpt3 = array_map(function($value){
                return "'".$value["id"]."'";
            },$data["ROOTPT3"]);
        }
        $rootpt3 = !($arr_rootpt3) ? null : implode(",",$arr_rootpt3);

		$ret = $this->pdo->getData(
			($this->user->user_divide == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0
        ,   $get_divide
        ,   $date_divide
        ,	$date_from
		,	$date_to
		,	$jgscd
        ,	$nnsicd
        ,	$sub_ptncd
        ,	$denno
        ,	$sntcd
        ,	$nohincd
        ,	$rootpt1
        ,	$rootpt2
        ,	$rootpt3
		,	($this->user->user_divide == '30') ? $this->user->management_cd : $ptncd
		,	$this->user->user_id
		);


		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = array();
		}
		else{
			$this->return["status"] = STATUS_OK;
			$this->return["data"] = $ret;
		}
	}
	
	private function GetDetailData($get_divide,$target_id){
		
		$ret = $this->pdo->getDetailData(
            $get_divide
        ,	$target_id
        ,	$this->user->user_id
		);
		
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = array();
		}
		else{
			$this->return["status"] = STATUS_OK;
			$this->return["data"] = $ret;
		}
	}
	
	private function UpdateData($get_divide, $update_data,$dispatcher){
		
		$this->pdo->updateData(
            $get_divide
        ,	$update_data
        ,	$dispatcher
        ,	$this->user->user_id
		);
		
		$this->return["status"] = STATUS_OK;
		$this->return["data"] = array();
	}


}