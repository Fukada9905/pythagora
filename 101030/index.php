<?php
require '../config.php';

class pg_101030_index extends page_front
{
	private $_date_conditions;
	private $_date_conditions_divide;
	
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
		
		$this->_def_data["SYUKAYMD"] = "checked";
        $this->_def_data["NOHINYMD"] = "";
        $this->_def_data["DENPYOYMD"] = "";
        $this->_def_data["TRKMYMD"] = "";
		
		//$recent_date = $this->pdo->getRecentDate($_SESSION["100000_PROCESS_DIVIDE"]);
		//$from_date = ($recent_date < date("Y/m/d",strtotime("-5 day", time()))) ? $recent_date : date("Y/m/d",strtotime("-5 day", time()));
        $recent_date = date('Y/m/d');
        $from_date = date('Y/m/d');

		$this->_def_data["date_from"] = $from_date;
		$this->_def_data["date_to"] = $recent_date;
		
		parent::setJgsOrPartners("100000");
	
	}
	protected function render(){
		parent::render();
		$this->template->process_divide = $_SESSION["100000_PROCESS_DIVIDE"];
		$this->template->render(TEMPLATE_DIR. DS . '101/030.tpl.php');
	}
}

$page = new pg_101030_index();
$page->run();