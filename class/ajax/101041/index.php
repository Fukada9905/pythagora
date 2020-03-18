<?php
class ajax_101041_index extends ajax_base{

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
			$this->return["message"] = "ajax通信でエラーが発生しました。\n管理者へお問い合わせください";
		}catch(Exception $e){
			common_log::OutputLog($e->getMessage());
			$this->return["status"] = STATUS_ERROR;
			$this->return["message"] = $e->getMessage();
		}
	}
	
	
	private function GetMaindata(){
		$process_divide = $_SESSION["100000_PROCESS_DIVIDE"];
        $selection = !($_SESSION["101040_SELECTION"]) ? null : $_SESSION["101040_SELECTION"];
        $date_divide = $_SESSION["101040_DATE_DIVIDE"];

        $arr_nnsicd = array();
        if($_SESSION["101040_NINUSHI"]){
            $arr_nnsicd = array_map(function($value){
                return "'".$value["id"] ."'";
            },$_SESSION["101040_NINUSHI"]);
        }
        $nnsicd = !($arr_nnsicd) ? null : implode(",",$arr_nnsicd);

		$ret = $this->pdo->getData(
					$process_divide
				,	$selection
				,	$this->user->user_id
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
				'JGSCD'=>"事業所コード"
			,	'JGSNM'=>"事業所名"
			,	'SNTCD'=>"センターコード"
			,	'SNTNM'=>"センター名"
			,	'DATEYMD'=>$date_divide == 1 ? "出荷日" : "納品日"
			,	'DATA_DIVIDE'=>"DATA_DIVIDE"
			);
			$inclusion2 = array(
				'KKTSR1'=>"ケース"
			,	'KKTSR3'=>"バラ"
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
			$_SESSION["OUTPUTDATA_101041"] = serialize($out);
		}
	}

}