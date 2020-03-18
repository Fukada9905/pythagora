<?php
class ajax_103030_index extends ajax_base{

	public function process($data){
		
		try{
			switch($this->process_divide){
				case "get_main_data":
					$this->GetMaindata($data["target_divide"],$data["target_date"]);
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
	
	
	private function GetMaindata($target_divide,$target_date){

        $process_divide = 2;
        $selection = !($_SESSION["103040_SELECTION"]) ? null : $_SESSION["103040_SELECTION"];



        $ret = $this->pdo->getData(
            $process_divide
            ,	($target_divide) ? $target_divide : 1
            ,	($target_date) ? $target_date : null
            ,   $selection
            ,   $this->user->user_id
        );
		
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = $ret;
		}
		else{
			if($target_divide == 1){
				$inclusion = array(
					'UNSKSNM'=>"運送会社名"
				,	'NHNSKNM'=>"納品先名"
				,	'SNTNM'=>"センター名"
				,	'NNSINM'=>"荷主名"
				,	'KKTSR1'=>"ケース"
				,	'WGT'=>"重量"
				,	'DATA_DIVIDE'=>"DATA_DIVIDE"
				);
			}
			else{
				$inclusion = array(
					'SNTNM'=>"センター名"
				,	'NNSINM'=>"荷主名"
				,	'NHNSKNM'=>"納品先名"
				,	'UNSKSNM'=>"運送会社名"
				,	'KKTSR1'=>"ケース"
				,	'WGT'=>"重量"
				,	'DATA_DIVIDE'=>"DATA_DIVIDE"
				);
			}
			
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
			$_SESSION["OUTPUTDATA_103030"][$target_divide][$target_date] = serialize($out);
			
			
			$this->return["status"] = STATUS_OK;
			$this->return["data"] = $ret;
		}
	}

}