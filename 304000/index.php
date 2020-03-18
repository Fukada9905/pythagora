<?php
require '../config.php';

class pg_304000_index extends page_front
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
		
		parent::setJgsOrPartners("300000");
		
		//$recent_date = $this->pdo->getRecentDate();
		//$from_date = ($recent_date < date("Y/m/d",strtotime("-90 day", time()))) ? $recent_date : date("Y/m/d",strtotime("-90 day", time()));

        $recent_date = date('Y/m/d');

        $this->_def_data["date_from"] = $recent_date;
		$this->_def_data["date_to"] = $recent_date;
		
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '304/000.tpl.php');
	}
}

$page = new pg_304000_index();
$page->run();