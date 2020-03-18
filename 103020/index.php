<?php
require '../config.php';

class pg_103020_index extends page_front
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
		
		//$recent_date = $this->pdo->getRecentDate();
		//$from_date = ($recent_date < date("Y/m/d",strtotime("-5 day", time()))) ? $recent_date : date("Y/m/d",strtotime("-5 day", time()));
		//$this->_def_data["date_from"] = $from_date;
		//$this->_def_data["date_to"] = $recent_date;

        $this->_def_data["SYUKAYMD"] = "checked";
        $this->_def_data["NOHINYMD"] = "";
        $this->_def_data["DENPYOYMD"] = "";
        $this->_def_data["TRKMYMD"] = "";

        $recent_date = date('Y/m/d');
        $to_date = date("Y/m/d",strtotime("5 day", time()));

        $this->_def_data["date_from"] = $recent_date;
        $this->_def_data["date_to"] = $to_date;

		parent::setJgsOrPartners("100000");
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '103/020.tpl.php');
	}
}

$page = new pg_103020_index();
$page->run();