<?php
require '../config.php';

class pg_201000_index extends page_menus
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
		
		//$recent_date = $this->pdo->getRecentDate();

        $this->_def_data["date_from"] = ($_SESSION["201000_DATE_FROM"]) ? $_SESSION["201000_DATE_FROM"] : date('Y/m/d');
		$this->_def_data["date_to"] = ($_SESSION["201000_DATE_TO"]) ? $_SESSION["201000_DATE_TO"] : '';

		//$this->_def_data["recent_date"] = $recent_date;
		
		
		unset($_SESSION["201000_DATE_FROM"]);
		unset($_SESSION["201000_DATE_TO"]);
		unset($_SESSION["201000_CENTER"]);
		
		parent::setJgsOrPartners("200000");
		
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '201/000.tpl.php');
	}
}

$page = new pg_201000_index();
$page->run();