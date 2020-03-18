<?php
class db_common extends db_base
{

    public function __construct(){
        parent::__construct();
    }

    public function GetUserInformation($user_id){
        $data = $this->spExec("pyt_p_get_user_information",array("user_id" => $user_id));
        return $data;
    }
	
	public function SetLoginInformation($user_id,$function_id,$ticket){
		$params = array(
				"process_divide"=>1,
				"user_id"=>$user_id,
				"function_id"=>$function_id,
				"remote_ip"=>common_server::IP(),
				"user_agent"=>common_server::UserAgent(),
				"ticket"=>$ticket
		);
		
		$this->spExec("pyt_p_set_login_information",$params,false);
	}
	public function UpdateLoginInformation($user_id,$function_id){
		$params = array(
				"process_divide"=>2,
				"user_id"=>$user_id,
				"function_id"=>$function_id,
				"remote_ip"=>null,
				"user_agent"=>null,
				"ticket"=>null
		);
		$this->spExec("pyt_p_set_login_information",$params,false);
	}
	
	public function GetMainMenu($user_id,$parent_url = null){
		try{
			
			$data = $this->spExec("pyt_p_get_main_menu",array("user_id" => $user_id,"parent_menu_url"=>$parent_url));
			return $data;
		}catch(Exception $e){
			throw $e;
		}
	}
	
	public function GetFunctionName($user_group_id, $function_id){
		$ret = "";
		$params = array(
			"user_group_id"=>$user_group_id,
			"function_id"=>$function_id
		);
		$data = $this->spExec("pyt_p_get_function_name",$params);
		if($data){
			$ret = $data[0]["menu_name"];
		}

		return $ret;
    }
	
	public function GetFunctionAuthority($user_group_id, $function_name){
		$params = array("user_group_id"=>$user_group_id,"function_name"=>$function_name);
		$ret = $this->spExec("pyt_p_get_function_authorization",$params);
		
		if(!$ret){
			$_SESSION[SESSION_ERROR_UNSET_FLG] = true;
			$_SESSION[SESSION_ERROR_MSG2] = "STATUS 403 : Access Denied";
			$_SESSION[SESSION_ERROR_MSG1] = "このページへのアクセスは禁止されています";
			header("Location:".URL."error.php");
			exit();
		}
	}
	
	
	public function SetLogout($user_id){
		try{
			$this->spExec("pyt_p_set_logout",array("user_id" => $user_id),false);
		}catch(Exception $e){
			//NOTHING TO DO
		}
	}
    

    public function ExclusionCheck($user_id,$ticket){
		
		$ret = $this->DoExclusionCheck($user_id,$ticket);
		if(count($ret) > 0){
			$_SESSION[SESSION_ERROR_MSG1] = "他の端末にてユーザーIDが使用されています。<br>他の端末での処理を終了させ、再度実行してください。";
			$_SESSION[SESSION_ERROR_MSG2] = "OTHER TERMINAL LOGIN";
			$_SESSION[SESSION_ERROR_UNSET_FLG] = true;

			header("Location:".URL."error.php");
			exit();
        }
    }
	
	public function DoExclusionCheck($user_id,$ticket){
		$params = array("user_id"=>$user_id,"ticket"=>$ticket);
		$ret = $this->spExec("pyt_p_get_login_information",$params);
		return $ret;
	}
	
	public function getNinushiList(){
		$sql = "SELECT NNSICD,NNSINM FROM pyt_m_ninushi WHERE del_flag = 0";
		return $this->query($sql);
	}
	public function getJigyoshoList(){
		return $this->spExec("pyt_p_get_jigyosho");
	}
	public function getCenterList($jgscd = null,$process_divide = 1, $is_partner = 0, $management_cd = null){
		return $this->spExec("pyt_p_get_center"
				,	array(
						"jgscd"=>$jgscd
					,	"process_divide"=>$process_divide
					,	"is_partner"=>$is_partner
					,	"management_cd"=>$management_cd
				)
		);
	}
	public function getPartnerList($jgscd = null){
		return $this->spExec("pyt_p_get_partner",array("jgscd"=>$jgscd));
	}

    public function getRootPartnerList($get_divide, $jgscd = null, $ptncd = null){
        return $this->spExec("pyt_p_get_root",array("get_divide"=>$get_divide,"jgscd"=>$jgscd,"ptncd"=>$ptncd));
    }




}