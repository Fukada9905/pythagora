<?php
require '../config.php';

class pg_302000_index extends page_front
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
		
		//$from_date = ($recent_date < date("Y/m/d",strtotime("-5 day", time()))) ? $recent_date : date("Y/m/d",strtotime("-5 day", time()));

        //$recent_date = date('Y/m/d');
        $recent_date = date("Y/m/d",strtotime("-1 day", time()));
        $from_date = date("Y/m/d",strtotime("-1 day", time()));

        $this->_def_data["date_from"] = $from_date;
        $this->_def_data["date_to"] = $recent_date;
	
	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '302/000.tpl.php');
	}
}

$page = new pg_302000_index();
$page->run();