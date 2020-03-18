<?php
require '../config.php';

class pg_200000_index extends page_menus
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
		
		unset($_SESSION["201000_DATE_FROM"]);
		unset($_SESSION["201000_DATE_TO"]);
		unset($_SESSION["201000_CENTER"]);
		
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '200/common.tpl.php');
	}
}

$page = new pg_200000_index();
$page->run();