<?php
require '../config.php';

class pg_101010_index extends page_menus
{
	public function __construct()
	{
		parent::__construct();
	}
	protected function load()
	{
		parent::load();
	}
	protected function process(){}
	protected function view(){
		parent::view();
		
		//$recent_date = $this->pdo->getRecentDate($_SESSION["100000_PROCESS_DIVIDE"]);
        $recent_date = date('Y/m/d');
		
		$this->_def_data["SYUKAYMD"] = (!($_SESSION["101010_DATE_DIVIDE"]) || $_SESSION["101010_DATE_DIVIDE"] == 1) ? "checked" : "";
		$this->_def_data["NOHINYMD"] = ($_SESSION["101010_DATE_DIVIDE"] == "2") ? "checked" : "";
        $this->_def_data["DENPYOYMD"] = ($_SESSION["101010_DATE_DIVIDE"] == "3") ? "checked" : "";
        $this->_def_data["TRKMYMD"] = ($_SESSION["101010_DATE_DIVIDE"] == "4") ? "checked" : "";
		
		
		$this->_def_data["date_to"] = (isset($_SESSION["101010_DATE_TO"])) ? $_SESSION["101010_DATE_TO"] : $recent_date;
		//$from_date = ($recent_date < date("Y/m/d",strtotime("-5 day", time()))) ? $recent_date : date("Y/m/d",strtotime("-5 day", time()));
        $from_date = date('Y/m/d');
		$this->_def_data["date_from"] = (isset($_SESSION["101010_DATE_FROM"])) ? $_SESSION["101010_DATE_FROM"] : $from_date;
		
		
		parent::setJgsOrPartners("100000");
		
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '101/010.tpl.php');
	}
}

$page = new pg_101010_index();
$page->run();