<?php
require '../config.php';

class pg_100000_index extends page_menus
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
		$this->template->render(TEMPLATE_DIR. DS . '100/common.tpl.php');
	}
}

$page = new pg_100000_index();
$page->run();