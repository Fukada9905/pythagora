<?php
require '../config.php';

class pg_103000_index extends page_menus
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
		
		parent::setJgsOrPartners("100000");
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '100/submenu.tpl.php');
	}
}

$page = new pg_103000_index();
$page->run();