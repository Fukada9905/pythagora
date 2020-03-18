<?php
class ajax_common extends ajax_base{

	public function process($data){
		try{
			switch($this->process_divide){
				case "get_menu":
					$this->return["data"] = $this->pdo->hasNewInformation($this->user->TenantCD);
					break;
				case "set_logout":
					$this->SetLogout($this->user->user_id);
					break;
				case "set_storage":
					$this->SetStorage($data);
					break;
                case "reset_storage":
                    $this->ResetStorage($data);
                    break;
				case "get_jigyosho":
					$this->getMasterData("jigyosho");
					break;
				case "get_ninushi":
					$this->getMasterData("ninushi");
					break;
				case "get_center":
					$this->getMasterData("center",array("JGSCD"=>$data["JGSCD"],"PTNCD"=>$data["PTNCD"],"PROCESS_DIVIDE"=>$data["PROCESS_DIVIDE"]));
					break;
				case "get_partner":
                case "get_sub_partner":
					$this->getMasterData("partner",array("JGSCD"=>$data["JGSCD"]));
					break;
                case "get_root_partner1":
                    $this->getMasterData("root_partner1",array("JGSCD"=>$data["JGSCD"],"PTNCD"=>$data["PTNCD"]));
                    break;
                case "get_root_partner2":
                    $this->getMasterData("root_partner2",array("JGSCD"=>$data["JGSCD"],"PTNCD"=>$data["PTNCD"]));
                    break;
                case "get_root_partner3":
                    $this->getMasterData("root_partner3",array("JGSCD"=>$data["JGSCD"],"PTNCD"=>$data["PTNCD"]));
                    break;
				case "error_log":
					$this->pdo->OutputErrorLog("AJAX ERROR",$data["params"],$data["message"]);
					break;
                case "continue":
                    session_start();
                    $this->return["status"] = STATUS_OK;
                    break;
				default:
					$this->return["status"] = STATUS_ERROR;
					$this->return["message"] = "ajax通信でエラーが発生しました。\n処理区分が不明です";
					break;
			}
		}catch(Exception $e){
			common_log::OutputLog($e->getMessage());
			$this->return["status"] = STATUS_ERROR;
			$this->return["message"] = $e->getMessage();
		}
	}
	
	private function SetLogout($user_id){
	    $this->pdo->SetLogout($user_id);
	}
	
	private function SetStorage($params){
		foreach ($params as $key => $val){
		    if($val === "null" || $val === "undefined"){
                $_SESSION[$key] = null;
            }
		    else{
                $_SESSION[$key] = $val;
            }
		}
		$this->return["status"] = STATUS_OK;
		$this->return["data"] = $params;
	}

    private function ResetStorage($params){
        foreach ($params as $val){
            unset($_SESSION[$val]);
        }
        $this->return["status"] = STATUS_OK;
        $this->return["data"] = $params;
    }
	
	private function GetMasterData($process_type,$params = array()){
		
		$ret = array();
		switch ($process_type){
			case 'jigyosho':
				$ret = $this->pdo->getJigyoshoList();
				break;
			case 'ninushi':
				$ret = $this->pdo->getNinushiList();
				break;
			case 'center':
				$ret = $this->pdo->getCenterList(
						!($params["JGSCD"]) ? null : $params["JGSCD"]
						,	!($params["PROCESS_DIVIDE"]) ? 1 : $params["PROCESS_DIVIDE"]
						,	($this->user->user_divide == '30' || $_SESSION["IS_PARTNER"]) ? 1 : 0
						,	$this->user->user_divide == '30' ? $this->user->management_cd : $params["PTNCD"]
				);
				break;
			case 'partner':
				$ret = $this->pdo->getPartnerList(!($params["JGSCD"]) ? null : $params["JGSCD"]);
				break;
            case 'root_partner1':
                if($this->user->user_divide == '30'){
                    $ptncd = "'".$this->user->management_cd."'";
                }
                else{
                    $ptncd = !($params["PTNCD"]) ? null : $params["PTNCD"];
                }
                $ret = $this->pdo->getRootPartnerList(1,!($params["JGSCD"]) ? null : $params["JGSCD"],$ptncd);
                break;
            case 'root_partner2':
                if($this->user->user_divide == '30'){
                    $ptncd = "'".$this->user->management_cd."'";
                }
                else{
                    $ptncd = !($params["PTNCD"]) ? null : $params["PTNCD"];
                }
                $ret = $this->pdo->getRootPartnerList(2,!($params["JGSCD"]) ? null : $params["JGSCD"],$ptncd);

                break;
            case 'root_partner3':
                if($this->user->user_divide == '30'){
                    $ptncd = "'".$this->user->management_cd."'";
                }
                else{
                    $ptncd = !($params["PTNCD"]) ? null : $params["PTNCD"];
                }
                $ret = $this->pdo->getRootPartnerList(3,!($params["JGSCD"]) ? null : $params["JGSCD"],$ptncd);
                break;
		}
		
		
		if(!$ret){
			$this->return["status"] = STATUS_NO_DATA;
			$this->return["data"] = array();
		}
		else{
			$this->return["status"] = STATUS_OK;
			$this->return["data"] =$ret;
		}
		
		
		
	}


	
}