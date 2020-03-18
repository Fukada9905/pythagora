<?php
class ajax_201020_index extends ajax_base{

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
		$arr_ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);
		
		$ret = $this->pdo->getData(
					($this->user->user_divide == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0
				,	$date_from
				,	$date_to
				,	$jgscd
				,	$sntcd
				,	($this->user->user_divide == '30') ? $this->user->management_cd : $arr_ptncd
				,	$this->user->user_id
		);
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = array();
		}
		else{
			$this->return["status"] = STATUS_OK;
			$this->return["data"] = $ret;
			
			$inclusion = array(
				'NOHINYMD'=>"入荷予定日"
			,	'JGSNM'=>"出荷元名称"
			,	'NNSINM'=>"荷主名"
			,	'KKTSR1'=>"合計/ケース予定数"
			,	'MOD_PL'=>"合計/パレット数"
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
			$_SESSION["OUTPUTDATA_201020"] = serialize($out);
		}
	}

}