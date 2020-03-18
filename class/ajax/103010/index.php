<?php
class ajax_103010_index extends ajax_base{

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

        $process_divide = 1;
        $selection = !($_SESSION["103040_SELECTION"]) ? null : $_SESSION["103040_SELECTION"];

        $arr_nnsicd = array();
        if($_SESSION["103040_NINUSHI"]){
            $arr_nnsicd = array_map(function($value){
                return "'".$value["id"] ."'";
            },$_SESSION["103040_NINUSHI"]);
        }
        $nnsicd = !($arr_nnsicd) ? null : implode(",",$arr_nnsicd);

		
		$ret = $this->pdo->getData(
		            $process_divide
				,	($target_divide) ? $target_divide : 1
				,	($target_date) ? $target_date : null
                ,   $selection
				,	$nnsicd
                ,   $this->user->user_id
		);
		
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = $ret;
		}
		else{
			
			if($target_divide == 1){
				$inclusion = array(
					'JGSNM'=>"事業所名"
				,	'NHNSKNM'=>"納品先名"
				,	'DATA_DIVIDE'=>"DATA_DIVIDE"
				);
			}
			else{
				$inclusion = array(
					'SNTNM'=>"センター名"
				,	'DATA_DIVIDE'=>"DATA_DIVIDE"
				);
			}
			$inclusion2 = array(
				'KKTSR1'=>"CS数"
			,	'WGT'=>"重量"
			);
			
			$search = array_keys($inclusion2);
			$replace = array_values($inclusion2);
			$out = array();
			foreach ($ret as $index=> $row){
				$out_row = array();
				foreach ($row as $key => $val){
					if(in_array($key,array_keys($inclusion))){
						$out_row[$inclusion[$key]] = strpos($val,'ZZZZ') !== false ? '' :$val;
					}
					elseif(common_functions::is_in_array($key,$search)){
						$nnsicd = str_replace("_","",str_replace($search,"",$key));
						$item_key = str_replace("_","",str_replace($nnsicd,"",str_replace($search,$replace,$key)));
						$out_row[$nnsicd][$item_key] = strpos($val,'ZZZZ') !== false ? '' :$val;
					}
				}
				$out[$index] = $out_row;
			}
			$_SESSION["OUTPUTDATA_103010"][$target_divide][$target_date] = serialize($out);
			
			$this->return["status"] = STATUS_OK;
			$this->return["data"] = $ret;
		}
	}

}