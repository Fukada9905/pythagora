<?php
require '../config.php';

class pg_103040_index extends page_front
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
		
		$this->_def_data["SYUKAYMD"] = (!($_SESSION["103040_DATE_DIVIDE"]) || $_SESSION["103040_DATE_DIVIDE"] == 1) ? "checked" : "";
		$this->_def_data["NOHINYMD"] = ($_SESSION["103040_DATE_DIVIDE"] == "2") ? "checked" : "";
        $this->_def_data["DENPYOYMD"] = ($_SESSION["103040_DATE_DIVIDE"] == "3") ? "checked" : "";
        $this->_def_data["TRKMYMD"] = ($_SESSION["103040_DATE_DIVIDE"] == "4") ? "checked" : "";

        switch($_SESSION["103040_DATE_DIVIDE"]){
            case "2":
                $this->_def_data["DATEYMD_TITLE"] = "納品日";
                break;
            case "3":
                $this->_def_data["DATEYMD_TITLE"] = "伝票日付";
                break;
            case "4":
                $this->_def_data["DATEYMD_TITLE"] = "取込日";
                break;
            default:
                $this->_def_data["DATEYMD_TITLE"] = "出荷日";
                break;
        }


		$this->_def_data["date_to"] = (isset($_SESSION["103040_DATE_TO"])) ? $_SESSION["103040_DATE_TO"] : $recent_date;
		$from_date = date('Y/m/d');
		$this->_def_data["date_from"] = (isset($_SESSION["103040_DATE_FROM"])) ? $_SESSION["103040_DATE_FROM"] : $from_date;
		
		
		parent::setJgsOrPartners("100000");
		
	}
	protected function render(){
		parent::render();
        $this->template->process_divide = $_SESSION["100000_PROCESS_DIVIDE"];
		$this->template->render(TEMPLATE_DIR. DS . '103/040.tpl.php');
	}
}

$page = new pg_103040_index();
$page->run();