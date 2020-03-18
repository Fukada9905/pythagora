<?php
abstract class page_base
{
    protected $request;
    protected $template;
    protected $pdo;
    protected $db_name;
    protected $user_info;
    protected $class_name;
    protected $page_title;


    protected function __construct()
    {

        session_start();

        switch (self::getHttpMethod()) {
            case 'GET':
                $this->request = (object) $_GET;
                break;
            case 'POST':
                $this->request = (object) $_POST;
                break;
        }

        $this->template = new template();
        $this->class_name = $this->getFunctionNameFromClassName(get_class($this));
        $this->db_name = $this->setDbClassName(get_class($this));

        try{
            $this->pdo = new $this->db_name;
        }catch(PDOException $e){
            $_SESSION[SESSION_ERROR_MSG1] = "DBへの接続に失敗しました。<br>管理者へお問い合わせください。";
            $_SESSION[SESSION_ERROR_MSG2] = "DB Connection Error.";
            header("Location:".URL."error.php");
            exit();
        }
    }

    protected static function getHttpMethod()
    {
        return isset($_SERVER['REQUEST_METHOD']) ? strtoupper($_SERVER['REQUEST_METHOD']) : null;
    }

    protected static function isPost()
    {
        return (self::getHttpMethod() === 'POST') ? true : false;
    }

    abstract protected function load();
    abstract protected function render();
    abstract protected function err();
    abstract protected function run();

    protected static function setDbClassName($className)
    {
        return "db_" . str_replace('pg_','',$className);
    }
    protected static function getFunctionNameFromClassName($className){
        $ret = explode("_",str_replace('pg_','',$className));
        return $ret[0];
    }
	protected static function getFunctionIDFromClassName($className){
		$ret = explode("_",$className);
		if(!$ret[0] || $ret[0] == "index"){
			return "000000";
		}
		else{
			return $ret[0];
		}
		
	}
    


}