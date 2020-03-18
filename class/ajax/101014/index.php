<?php
class ajax_101014_index extends ajax_base{

	public function process($data){
		
		try{
			switch($this->process_divide){
				case "get_main_data":
					$this->GetMaindata();
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
			$this->return["message"] = $e->getMessage()."ajax通信でエラーが発生しました。\n管理者へお問い合わせください";
		}catch(Exception $e){
			common_log::OutputLog($e->getMessage());
			$this->return["status"] = STATUS_ERROR;
			$this->return["message"] = $e->getMessage();
		}
	}
	
	
	private function GetMaindata(){
		$process_divide = $_SESSION["100000_PROCESS_DIVIDE"];
		
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
		
		$arr_ptncd = array();
		if($_SESSION["100000_PTNCD"]){
			$arr_ptncd = array_map(function($value){
				return $value["id"];
			},$_SESSION["100000_PTNCD"]);
		}
		$arr_ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);

        $arr_nnsicd = array();
        if($_SESSION["101010_NINUSHI"]){
            $arr_nnsicd = array_map(function($value){
                return "'".$value["id"] ."'";
            },$_SESSION["101010_NINUSHI"]);
        }
        $nnsicd = !($arr_nnsicd) ? null : implode(",",$arr_nnsicd);
		
		$ret = $this->pdo->getData(
					$process_divide
				,	($this->user->user_divide == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0
				,	$date_divide
				,	$date_from
				,	$date_to
				,	$jgscd
				,	($this->user->user_divide == '30') ? $this->user->management_cd : $arr_ptncd
            ,   $nnsicd
		);
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = array();
		}
		else{
			$this->return["status"] = STATUS_OK;
			$this->return["data"] = $ret;
			
			$inclusion = array(
				'NNSICD'=>"荷主コード"
			,	'NNSINM'=>"荷主名"
			,	'DATEYMD'=>$date_divide == 1 ? "出荷日" : "納品日"
			,	'KKTSR1'=>"ケース"
			,	'KKTSR3'=>"バラ"
			,	'WGT'=>"重量"
			,	'DATA_DIVIDE'=>"DATA_DIVIDE"
			);
			$out = array();
			foreach ($ret as $index=> $row){
				$out_row = array();
				foreach ($row as $key => $val){
					if(in_array($key,array_keys($inclusion))){
						$out_row[$inclusion[$key]] = strpos($val,'ZZZZ') !== false ? '' :$val;
					}
				}
				$out[$index] = $out_row;
			}
			$_SESSION["OUTPUTDATA_101014"] = serialize($out);
		}
	}

}