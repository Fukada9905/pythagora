<?php
require '../config.php';

class pg_205000_index extends page_front
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
        /*

        $recent_date = $this->pdo->getLastDate();
        $from_date = ($recent_date < date("Y/m/d",strtotime("-90 day", time()))) ? $recent_date : date("Y/m/d",strtotime("-90 day", time()));
        */
        $recent_date = date('Y/m/d');
        $from_date = date('Y/m/d');

		$this->_def_data["date_from"] = $from_date;
		$this->_def_data["date_to"] = $recent_date;
		
		parent::setJgsOrPartners("200000");
	
	}
	protected function render(){
		parent::render();
		$this->template->def_data = $this->_def_data;
		$this->template->render(TEMPLATE_DIR. DS . '205/000.tpl.php');
	}
}

$page = new pg_205000_index();
$page->run();