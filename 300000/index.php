<?php
require '../config.php';

class pg_300000_index extends page_menus
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
		
		
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '300/common.tpl.php');
	}
}

$page = new pg_300000_index();
$page->run();