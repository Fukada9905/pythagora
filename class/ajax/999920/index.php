<?php
class ajax_999920_index extends ajax_base{

	public function process($data){
		
		try{
			switch($this->process_divide){
				case "get_main_data":
					$this->GetMaindata($data["target_date_from"],$data["target_date_to"]);
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
	
	
	private function GetMaindata($target_date_from,$target_date_to){
		
		$ret = $this->pdo->getMaster($target_date_from,$target_date_to);
		
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = array();
		}
		else{
			$this->return["status"] = STATUS_OK;
			$return = array();
			foreach ($ret as $index => $row){
				$out = array();
				foreach ($row as $key => $val){
					if($key == "user_agent"){
						$out["device"] = common_functions::get_device($val);
						$out["browser"] = common_functions::get_browser($val);
					}
					else{
						$out[$key] = $val;
					}
				}
				$return[$index] = $out;
			}
			
			
			$this->return["data"] = $return;
		}
	}

}