<?php
require '../config.php';

class pg_103010_index extends page_front
{
	private $_data = array();
	private $_selections;

	
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

        $this->_selections = !($_SESSION["103040_SELECTION"]) ? null : $_SESSION["103040_SELECTION"];
        $recent_date = $this->pdo->getRecentDates(1,$this->_selections,$this->user_info->user_id);

		foreach ($recent_date as $date){
            $this->_def_data["target_date"][] = $date;
        }


        if($_SESSION["103040_NINUSHI"]){
            $data = array();
            foreach ($_SESSION["103040_NINUSHI"] as $row){
                $data[] = array("NNSICD"=>$row["id"],"NNSINM"=>$row["name"]);
            }
            $this->_data = $data;
        }
        else{
            $this->_data = $this->pdo->getNinushiList();
        }

		$nnsi_header = array();
		foreach ($this->_data as $row){
			$nnsi_header += array($row["NNSICD"]=>$row["NNSINM"]);
		}
		$nnsi_header += array("TOTAL"=>"合計");
		$_SESSION["103010_NNSI_HEADER"] = serialize($nnsi_header);
		
		
		parent::setJgsOrPartners("100000");
		
		$search_array = array();
		if(!$this->_is_partner){
			if(!$this->_is_partner_select){
				$jgstxt = !($_SESSION["100000_JGSCD"]) ? "指定なし" : $_SESSION["100000_JGSCD"][0]["id"] ."　". $_SESSION["100000_JGSCD"][0]["name"];
				$search_array += array("事業所"=>$jgstxt);
			}
			else{
				$ptntxt = !($_SESSION["100000_PTNCD"]) ? "指定なし" : $_SESSION["100000_PTNCD"][0]["id"] ."　". $_SESSION["100000_PTNCD"][0]["name"];
				$search_array += array("業者"=>$ptntxt);
			}
		}
		
		
		$_SESSION["103010_SEARCH_HEADER"] = serialize($search_array);
	}
	protected function render(){
		parent::render();
		$this->template->selections = $this->_selections;
		$this->template->data = $this->_data;
		$this->template->render(TEMPLATE_DIR. DS . '103/010.tpl.php');
	}
}

$page = new pg_103010_index();
$page->run();