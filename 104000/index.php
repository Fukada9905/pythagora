<?php
require '../config.php';

class pg_104000_index extends page_front
{
	private $_recent_date;
	private $_process_divide;
	
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

        $this->_process_divide = !($this->request->divide) ? 1 : $this->request->divide;

        $this->_def_data["SYUKAYMD"] = "checked";
        $this->_def_data["NOHINYMD"] = "";
        $this->_def_data["DENPYOYMD"] = "";
        $this->_def_data["TRKMYMD"] = "";


        //$this->_recent_date = $this->pdo->getRecentDate();
        $this->_def_data["date_from"] = date('Y/m/d');
        $this->_def_data["date_to"] = date('Y/m/d');
		parent::setJgsOrPartners("100000");
	
	}
	protected function render(){
		parent::render();
		$this->template->process_divide = $this->_process_divide;
		$this->template->render(TEMPLATE_DIR. DS . '104/000.tpl.php');
	}
}

$page = new pg_104000_index();
$page->run();