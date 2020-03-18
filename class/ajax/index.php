<?php
class ajax_index extends ajax_base{

	public function process($data){
		
		try{
			switch($this->process_divide){
				case "login":
					$this->return = $this->GetLoginInformation($data["user_id"],$data["user_password"],$data["auto_login"]);
					break;
				case "get_menu":
					$this->return = $this->GetMenu();
					break;
				default:
					$this->return["status"] = STATUS_ERROR;
					$this->return["message"] = "ajax通信でエラーが発生しました。\n処理区分が不明です";
					break;
			}
			if(!$this->return["status"]) $this->return["status"] = STATUS_OK;
		}catch(Exception $e){
			common_log::OutputLog($e->getMessage());
			$this->return["status"] = STATUS_ERROR;
			$this->return["message"] = $e->getMessage();
		}
	}
	
	private function GetLoginInformation($user_id,$user_password,$auto_login){
		$this->user->user_id = $user_id;
		$this->user->user_password = $user_password;

		$data = $this->pdo->getUserInformation($user_id);
		$ret = $this->user->LoginCheck($data);

		if($ret === STATUS_OK) {
			$ticket = common_functions::getTicket();
			if ($this->pdo->DoExclusionCheck($user_id, $ticket)) {
				$ret = STATUS_OTHER_LOGIN;
			} else {
				
				$_SESSION[SESSION_TICKET] = $ticket;
				$_SESSION[SESSION_USER_INFO] = serialize($this->user);
				$this->pdo->SetLoginInformation($user_id, $this->getFunctionID(), $ticket);
				
				if ($auto_login) {
					$cookies_user = $user_id;
					$cookies_password = sha1($user_password);//暗号化してセッションに保存
					setcookie(CACHE_NAME_USER, $cookies_user, time() + (3600 * 24 * 14), "/");
					setcookie(CACHE_NAME_PASS, $cookies_password, time() + (3600 * 24 * 14), "/");
					setcookie(CACHE_NAME_TICKET, $ticket, time() + (3600 * 24 * 14), "/");
				}
			}
		}

		$ret_data = array("status"=>$ret,"data"=>$data);
		return array("status"=>$ret,"data"=>$ret_data);
	}
	
	private function GetMenu(){
		$main_menu = $this->pdo->GetMainMenu($this->user->user_id,null);
		$sub_menu = $this->pdo->GetMainMenu($this->user->user_id,"submenu");
		
		return array("status"=>STATUS_OK,"data"=>array("main_menu"=>$main_menu,"sub_menu"=>$sub_menu));
	}

}