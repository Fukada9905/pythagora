<?php
class ajax_101050_index extends ajax_base{

	public function process($data){
		
		try{
			switch($this->process_divide){
				case "get_main_data":
					$this->GetMaindata($data);
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

        $process_divide = $_SESSION["100000_PROCESS_DIVIDE"];

        $date_divide = ($data["DATE_DIVIDE"]) ? $data["DATE_DIVIDE"] : 1;
		$date_from = ($data["DATE_FROM"]) ? $data["DATE_FROM"] : null;
		$date_to = ($data["DATE_TO"]) ? $data["DATE_TO"] : null;

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
        $arr_ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);

        $arr_nnsicd = array();
        if($data["NNSICD"]){
            $arr_nnsicd = array_map(function($value){
                return "'".$value["id"] ."'";
            },$data["NNSICD"]);
        }
        $nnsicd = !($arr_nnsicd) ? null : implode(",",$arr_nnsicd);

        $arr_sntcd = array();
        if($data["SNTCD"]){
            $arr_sntcd = array_map(function($value){
                return "('".$value["JGSCD"] ."','".$value["SNTCD"] ."')";
            },$data["SNTCD"]);
        }
        $sntcd = !($arr_sntcd) ? null : implode(",",$arr_sntcd);



        $ret = $this->pdo->getData(
            $process_divide
            ,	($this->user->user_divide == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0
            ,	$date_divide
            ,	$date_from
            ,	$date_to
            ,	$jgscd
            ,	($this->user->user_divide == '30') ? $this->user->management_cd : $arr_ptncd
            ,	$this->user->user_id
            ,   $nnsicd
            ,   $sntcd
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

}