<?php
require 'config.php';

class index extends page_base
{
    private $_menu = array();
	private $_pager = array();
	private $_sub_menu = array();

    public function __construct()
    {
        parent::__construct();
    }
	
	public function run()
	{
		
		if($_SESSION[SESSION_PAGE_ROOT]){
			
			if($_SESSION[SESSION_PAGE_ROOT][count($_SESSION[SESSION_PAGE_ROOT]) - 1]["id"] == "000000"){
				$this->_pager = $_SESSION[SESSION_PAGE_ROOT][count($_SESSION[SESSION_PAGE_ROOT]) - 1]["pager"];
				unset($_SESSION[SESSION_PAGE_ROOT][count($_SESSION[SESSION_PAGE_ROOT]) - 1]);
			}
			elseif($_SESSION[SESSION_PAGE_ROOT][count($_SESSION[SESSION_PAGE_ROOT]) - 2]["id"] == "000000"){
				$this->_pager = $_SESSION[SESSION_PAGE_ROOT][count($_SESSION[SESSION_PAGE_ROOT]) - 2]["pager"];
			}
			else{
				$ret = array();
				$cnt = 0;
				foreach ($_SESSION[SESSION_PAGE_ROOT][count($_SESSION[SESSION_PAGE_ROOT]) - 1]["pager"] as $val){
					if($val["id"] != "000000"){
						$ret[$cnt] = array("id"=>$val["id"],"name"=>$val["name"],"url"=>$val["url"]);
						$cnt++;
					}
					else{
						break;
					}
				}
				$ret[$cnt] = array("id"=>"000000","name"=>"メインメニュー","url"=>common_server::URL());
				$this->_pager = $ret;
			}
		}
		else{
			$this->_pager = array(array("id"=>"000000","name"=>"メインメニュー","url"=>common_server::URL()));
			$_SESSION[SESSION_PAGE_ROOT] = array();
		}
		$_SESSION[SESSION_PAGE_ROOT][count($_SESSION[SESSION_PAGE_ROOT])] = array("id"=>"000000","pager"=>$this->_pager);
		$this->_sub_menu = $this->pdo->GetMainMenu($this->user_info->user_id,'submenu');
		
		$this->load();
		$this->err();
		$this->render();
	}
	
	public function err(){}
	public function isProcess(){return true;}
    protected function load()
    {
    	if(!$_SESSION[SESSION_USER_INFO]){

            $cookies = null;
            
            if(isset($_COOKIE[CACHE_NAME_USER]) && $_COOKIE[CACHE_NAME_USER] != ""){
                $cookies_user = $_COOKIE[CACHE_NAME_USER];
                $cookies_pass = $this->pdo->GetPasswordByUserID($cookies_user);
                if($cookies_pass && $_COOKIE[CACHE_NAME_PASS] == sha1($cookies_pass)){
                    $user = new common_user();
                    $user->user_id = $cookies_user;
                    $user->user_password = $cookies_pass;
                    $return = $user->LoginCheck($this->pdo->getUserInformation($cookies_user));

                    if($return == STATUS_OK){
						$ticket = $_COOKIE[CACHE_NAME_TICKET];
						$this->pdo->ExclusionCheck($user->user_id,$ticket);
						$this->pdo->SetLoginInformation($user->user_id,$this->getFunctionIDFromClassName(""),$ticket);
                        $this->user_info = $user;
                        $_SESSION[SESSION_USER_INFO] = serialize($user);
						$_SESSION[SESSION_TICKET] = $ticket;
                        $this->_menu = $this->pdo->GetMainMenu($this->user_info->user_id);
                        $this->_sub_menu = $this->pdo->GetMainMenu($this->user_info->user_id,'submenu');
	
						setcookie(CACHE_NAME_USER, $cookies_user, time()+(3600*24*14),"/");
						setcookie(CACHE_NAME_PASS, $_COOKIE[CACHE_NAME_PASS], time()+(3600*24*14),"/");
						setcookie(CACHE_NAME_TICKET, $ticket, time()+(3600*24*14),"/");
						

                    }
                }
            }
        }
        else{
    		$this->user_info = unserialize($_SESSION[SESSION_USER_INFO]);
            $this->pdo->ExclusionCheck($this->user_info->user_id,$_SESSION[SESSION_TICKET]);
            $this->pdo->UpdateLoginInformation($this->user_info->user_id,$this->getFunctionIDFromClassName(""));
            $this->_menu = $this->pdo->GetMainMenu($this->user_info->user_id);
            $this->_sub_menu = $this->pdo->GetMainMenu($this->user_info->user_id,'submenu');

        }
        if ($this->isProcess()) {

            $this->process();
        }
        $this->view();
    }

    private function process(){
    }

    private function view()
    {
		
        if($this->user_info){
            $this->template->user_name = $this->user_info->user_name;
            $this->template->user_divide = $this->user_info->user_divide;
        }
    }

    protected function render()
    {
		$this->template->login_status = isset($this->user_info) ? true : false;
        if($_SESSION["LOGOUT_STATUS"]){
            $this->template->status = "logout";
            unset($_SESSION["LOGOUT_STATUS"]);
        }
        if($_SESSION["AUTO_LOGOUT"]){
            $this->template->auto_logout = true;
            $this->template->keep_user_id = $_SESSION["KEEP_USER_ID"];
            $this->template->keep_user_password = $_SESSION["KEEP_USER_PASSWORD"];
            unset($_SESSION["AUTO_LOGOUT"]);
            unset($_SESSION["KEEP_USER_ID"]);
            unset($_SESSION["KEEP_USER_PASSWORD"]);
        }
		$this->template->page_parent = $this->_pager;
        $this->template->sub_menu =$this->_sub_menu;
        $this->template->menu = $this->_menu;
        $this->template->render(TEMPLATE_DIR. DS . 'index.tpl.php');
    }
}

$page = new index();
$page->run();