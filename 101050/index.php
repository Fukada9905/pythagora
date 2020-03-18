<?php
require '../config.php';

class pg_101050_index extends page_front
{
	public function __construct()
	{
		parent::__construct();
	}
	protected function load()
	{
        if ($this->isProcess()) {

            $this->process();
        }
        $this->view();
	}
	protected function process(){}
	protected function view(){

	    $recent_date = date('Y/m/d');
		
		$this->_def_data["SYUKAYMD"] = "checked";
		$this->_def_data["NOHINYMD"] = "";
        $this->_def_data["DENPYOYMD"] = "";
        $this->_def_data["TRKMYMD"] = "";

        $this->_def_data["DATEYMD_TITLE"] = "出荷日";

		$this->_def_data["date_to"] = $recent_date;
		$this->_def_data["date_from"] = $recent_date;

		
		parent::setJgsOrPartners("100000");
		
	}
	protected function render(){
		parent::render();
        $this->template->process_divide = $_SESSION["100000_PROCESS_DIVIDE"];
		$this->template->render(TEMPLATE_DIR. DS . '101/050.tpl.php');
	}
}

$page = new pg_101050_index();
$page->run();