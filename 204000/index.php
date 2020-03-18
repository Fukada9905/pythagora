<?php
require '../config.php';

class pg_204000_index extends page_front
{
	private $_recent_date;
	
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
		
		//$this->_recent_date = $this->pdo->getRecentDate();
        $this->_def_data["date_from"] = date('Y/m/d');
		parent::setJgsOrPartners("200000");
	
	}
	protected function render(){
		parent::render();
		//$this->template->recent_date = $this->_recent_date;
		$this->template->render(TEMPLATE_DIR. DS . '204/000.tpl.php');
	}
}

$page = new pg_204000_index();
$page->run();