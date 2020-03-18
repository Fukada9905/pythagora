<?php
abstract class page_system extends page_base
{

	protected $user_info;
	protected $_sub_menu = array();
	protected $_def_data = array();
	protected $_is_partner = false;
	protected $_pager = array();

	public function run()
	{
		//SESSION CHECK
		if(!$_SESSION[SESSION_USER_INFO]){
			header('Location:'.URL);
			exit();
		}
		//GET USER INFORMATION
		$this->user_info = unserialize($_SESSION[SESSION_USER_INFO]);
		
		//EXCLUSION CHECK
		$this->pdo->ExclusionCheck($this->user_info->user_id,$_SESSION[SESSION_TICKET]);
		
		//GET FUNCTION INFORMATIONS
		$function_name = $this->pdo->GetFunctionName($this->user_info->user_group_id,$this->class_name);
		$this->pdo->GetFunctionAuthority($this->user_info->user_group_id,$this->class_name);
		$this->pdo->UpdateLoginInformation($this->user_info->user_id,$this->class_name);
		$this->page_title = !($function_name) ? SITE_TITLE :$function_name;
		
		$this->_pager = array(array(),array("id"=>$this->class_name,"name"=>$function_name,"url"=>common_server::URL()));
		
		//GET SUB MENU
		$this->_sub_menu = $this->pdo->GetMainMenu($this->user_info->user_id,'submenu');
		
		//DIVIDE PROCESS
		switch ($this->user_info->user_divide){
			case 30:
				$this->_is_partner = true;
				break;
			case 99:
				break;
		}
		//LOAD
		$this->load();
		$this->err();
		$this->render();
	}
	public function err(){}

	public function isProcess(){
		return true;
	}
	
	protected function render(){
		
		global $num_fields;
		$this->template->is_partner = $this->_is_partner;
		$this->template->page_title = $this->page_title;
		$this->template->user_name = $this->user_info->user_name;
		$this->template->user_divide = $this->user_info->user_divide;
		$this->template->page_parent = $this->_pager;
		$this->template->num_fields =$num_fields;
		$this->template->sub_menu =$this->_sub_menu;
		$this->template->def_data = $this->_def_data;
	}
	
	protected function setJgsOrPartners($session_id){
		if($this->_is_partner){
			$_SESSION["IS_PARTNER"] = true;
			$this->template->is_partner_select = true;
		}
		else{
			if($_SESSION[$session_id."_PTNCD"]){
				$_SESSION["IS_PARTNER"] = true;
				$this->template->is_partner_select = true;
			}
			else{
				$_SESSION["IS_PARTNER"] = false;
				$this->template->is_partner_select = false;
			}
		}
	}
}