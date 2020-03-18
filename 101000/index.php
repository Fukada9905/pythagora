<?php
require '../config.php';

class pg_101000_index extends page_menus
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
		
		$_SESSION["100000_PROCESS_DIVIDE"] = !($this->request->divide) ? 1 : $this->request->divide;
		
		//clear
		unset($_SESSION["101010_DATE_DIVIDE"]);
		unset($_SESSION["101010_DATE_FROM"]);
		unset($_SESSION["101010_DATE_TO"]);
		
		parent::setJgsOrPartners("100000");
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '100/submenu.tpl.php');
	}
}

$page = new pg_101000_index();
$page->run();