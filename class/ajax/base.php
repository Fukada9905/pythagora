<?php

abstract class ajax_base{
	protected $pdo;
	protected $user;
	protected $post;
	protected $process_divide;
	protected $return = array(
		'data' => null,
		'status' => null,
		'message' => null
	);
	public function __construct($process_divide){
		session_start();
		$class = str_replace("ajax_",'',get_class($this));
		$db_name = common_functions::setDbClassName($class);

		try{
			$this->pdo = new $db_name;
		}catch(PDOException $e){
			$this->return['status'] = STATUS_ERROR;
			$this->return['message'] = "DBへの接続に失敗しました。<br>管理者へお問い合わせください。";
			return;
		}

		if($_SESSION[SESSION_USER_INFO]){
			$this->user = unserialize($_SESSION[SESSION_USER_INFO]);
		}
		else{
			$this->user = new common_user();
		}
		$this->process_divide = $process_divide;
	}
	abstract protected function process($data);
	public function GetReturns(){
		return json_encode($this->return);
	}
	public function IsError(){
		return ($this->return['status'] == STATUS_ERROR);
	}
	protected function getFunctionID(){
		$class_name = str_replace("ajax_","",get_class($this));
		if(!$class_name || $class_name == "index"){
			$class_name = "000000";
		}
		return $class_name;
	}
}

?>