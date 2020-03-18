<?php
class ajax_999040_index extends ajax_base{

	public function process($data){
		
		try{
			switch($this->process_divide){
				case "get_main_data":
					$this->GetMaindata($data["jgscd"],$data["tmcptncd"],$data["ckcptncd"],$data["unsksptncd"]);
					break;
				case "get_divide_data":
					$this->GetDivideData();
					break;
				case "update_data":
					$this->UpdateData($data["Update_data"]);
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
	
	
	private function GetMaindata($jgscd = null,$tmcptncd = null,$ckcptncd = null,$unsksptncd = null){
        $jgscd = ($jgscd) ? $jgscd : null;
        $tmcptncd = ($tmcptncd) ? $tmcptncd : null;
        $ckcptncd = ($ckcptncd) ? $ckcptncd : null;
        $unsksptncd = ($unsksptncd) ? $unsksptncd : null;
		
		$ret = $this->pdo->getMaster($jgscd,$tmcptncd,$ckcptncd,$unsksptncd);
		
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = array();
		}
		else{
			$this->return["status"] = STATUS_OK;
			$this->return["data"] = $ret;
		}
	}
	
	private function GetDivideData(){
		$ret = $this->pdo->getComboMaster(0);
		$ret2 = $this->pdo->getComboMaster(1);

        $this->return["data"] = array(
            $ret,
            $ret2
        );

		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;

		}
		else{
			$this->return["status"] = STATUS_OK;
		}
	}
	
	private function UpdateData($update_data){
		
		$this->pdo->updateData(
			$update_data
		,	$this->user->user_id
		);
		
		$this->return["status"] = STATUS_OK;
		$this->return["data"] = array();
	}

}