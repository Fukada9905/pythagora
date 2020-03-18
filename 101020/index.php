<?php
require '../config.php';

class pg_101020_index extends page_menus
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


        $this->_def_data["SYUKAYMD"] = "checked";
        $this->_def_data["NOHINYMD"] = "";
        $this->_def_data["DENPYOYMD"] = "";
        $this->_def_data["TRKMYMD"] = "";

		$this->_def_data["target_date"] = date("Y/m/d");
		
		parent::setJgsOrPartners("100000");
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '101/020.tpl.php');
	}
}

$page = new pg_101020_index();
$page->run();