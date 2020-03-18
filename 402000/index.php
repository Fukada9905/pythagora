<?php
require '../config.php';

class pg_402000_index extends page_front
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

        parent::setJgsOrPartners("400000");

        if($this->user_info->user_divide == "30"){
            $ptninfo = $this->pdo->getManagementInfo($this->user_info->management_cd);
            $this->_def_data["PTNINFO"] = $ptninfo["PTNCD"].":".$ptninfo["PTNNM"];
        }


        $recent_date = date('Y/m/d');
        $this->_def_data["SYUKAYMD"] = "";
        $this->_def_data["NOHINYMD"] = "";
        $this->_def_data["DENPYOYMD"] = "";
        $this->_def_data["TORIKOMIYMD"] = "checked";

        $this->_def_data['HOKYU'] = "checked";
        $this->_def_data['KOUJO'] = "checked";
        $this->_def_data['TC'] = "checked";
        $this->_def_data['OROSHI'] = "checked";

        $this->_def_data["date_from"] = $recent_date;
		$this->_def_data["date_to"] = $recent_date;
		

	}
	protected function render(){
		parent::render();
		$this->template->render(TEMPLATE_DIR. DS . '402/000.tpl.php');
	}
}

$page = new pg_402000_index();
$page->run();